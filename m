Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3941ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12758C433C7;
	Tue, 25 Jul 2023 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285573;
	bh=fPiwuheSjttIx1ECWed5wpZmeZITbvNQnuyhe029QMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKeafbeaV6DFBIzrWdpHF3/F35e5LZaXD9ys/AC1mZ1gl2DFldf1JsdN7MpXrk2cb
	 zbGAkkv6sNBQTd6/Apm4U+vHpdxaZFjzTSyITHl8Mr0lm0qsRILQDiNUkEOsfHQbts
	 TgzmyVpi92YHXf679DUZIoa+HflSbK9VkFPJjfDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/313] cls_flower: Add extack support for src and dst port range options
Date: Tue, 25 Jul 2023 12:46:17 +0200
Message-ID: <20230725104530.741075533@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit bd7d4c12819b60b161939bc2f43053955d24d0df ]

Pass extack down to fl_set_key_port_range() and set message on error.

Both the min and max ports would qualify as invalid attributes here.
Report the min one as invalid, as it's probably what makes the most
sense from a user point of view.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d3f87278bcb8 ("net/sched: flower: Ensure both minimum and maximum ports are specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f21c97f02d361..f0010e4850eb6 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -719,7 +719,8 @@ static void fl_set_key_val(struct nlattr **tb,
 }
 
 static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
-				 struct fl_flow_key *mask)
+				 struct fl_flow_key *mask,
+				 struct netlink_ext_ack *extack)
 {
 	fl_set_key_val(tb, &key->tp_range.tp_min.dst,
 		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_range.tp_min.dst,
@@ -734,13 +735,22 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_range.tp_max.src,
 		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
 
-	if ((mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
-	     htons(key->tp_range.tp_max.dst) <=
-		 htons(key->tp_range.tp_min.dst)) ||
-	    (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
-	     htons(key->tp_range.tp_max.src) <=
-		 htons(key->tp_range.tp_min.src)))
+	if (mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
+	    htons(key->tp_range.tp_max.dst) <=
+	    htons(key->tp_range.tp_min.dst)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_PORT_DST_MIN],
+				    "Invalid destination port range (min must be strictly smaller than max)");
 		return -EINVAL;
+	}
+	if (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
+	    htons(key->tp_range.tp_max.src) <=
+	    htons(key->tp_range.tp_min.src)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_PORT_SRC_MIN],
+				    "Invalid source port range (min must be strictly smaller than max)");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1211,7 +1221,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 	if (key->basic.ip_proto == IPPROTO_TCP ||
 	    key->basic.ip_proto == IPPROTO_UDP ||
 	    key->basic.ip_proto == IPPROTO_SCTP) {
-		ret = fl_set_key_port_range(tb, key, mask);
+		ret = fl_set_key_port_range(tb, key, mask, extack);
 		if (ret)
 			return ret;
 	}
-- 
2.39.2



