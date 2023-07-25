Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA271ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6439C433CA;
	Tue, 25 Jul 2023 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285576;
	bh=I/hnvNXgmXjXkNsmNFnOqYTB3WBKnVF542oAU0Y75bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRpn7Vjb02lGRxilQAE+kQIQ2EHmq/adfSYUuL/7arM/GSyMwaG8wgPg0BiMEM70+
	 ofe4EfO55+jJ/aozQ125oq3qCO0vb0l3yTfDvCNmKfQ79DFubWrxSkMqRi0A6MKT3+
	 VhXB74g9oFXJ8JGOgWWgGGG/kQO6JnP8E1F5ydMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/313] net/sched: flower: Ensure both minimum and maximum ports are specified
Date: Tue, 25 Jul 2023 12:46:18 +0200
Message-ID: <20230725104530.784189868@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d3f87278bcb80bd7f9519669d928b43320363d4f ]

The kernel does not currently validate that both the minimum and maximum
ports of a port range are specified. This can lead user space to think
that a filter matching on a port range was successfully added, when in
fact it was not. For example, with a patched (buggy) iproute2 that only
sends the minimum port, the following commands do not return an error:

 # tc filter add dev swp1 ingress pref 1 proto ip flower ip_proto udp src_port 100-200 action pass

 # tc filter add dev swp1 ingress pref 1 proto ip flower ip_proto udp dst_port 100-200 action pass

 # tc filter show dev swp1 ingress
 filter protocol ip pref 1 flower chain 0
 filter protocol ip pref 1 flower chain 0 handle 0x1
   eth_type ipv4
   ip_proto udp
   not_in_hw
         action order 1: gact action pass
          random type none pass val 0
          index 1 ref 1 bind 1

 filter protocol ip pref 1 flower chain 0 handle 0x2
   eth_type ipv4
   ip_proto udp
   not_in_hw
         action order 1: gact action pass
          random type none pass val 0
          index 2 ref 1 bind 1

Fix by returning an error unless both ports are specified:

 # tc filter add dev swp1 ingress pref 1 proto ip flower ip_proto udp src_port 100-200 action pass
 Error: Both min and max source ports must be specified.
 We have an error talking to the kernel

 # tc filter add dev swp1 ingress pref 1 proto ip flower ip_proto udp dst_port 100-200 action pass
 Error: Both min and max destination ports must be specified.
 We have an error talking to the kernel

Fixes: 5c72299fba9d ("net: sched: cls_flower: Classify packets using port ranges")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f0010e4850eb6..c92318f68f92d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -735,6 +735,16 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_range.tp_max.src,
 		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
 
+	if (mask->tp_range.tp_min.dst != mask->tp_range.tp_max.dst) {
+		NL_SET_ERR_MSG(extack,
+			       "Both min and max destination ports must be specified");
+		return -EINVAL;
+	}
+	if (mask->tp_range.tp_min.src != mask->tp_range.tp_max.src) {
+		NL_SET_ERR_MSG(extack,
+			       "Both min and max source ports must be specified");
+		return -EINVAL;
+	}
 	if (mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
 	    htons(key->tp_range.tp_max.dst) <=
 	    htons(key->tp_range.tp_min.dst)) {
-- 
2.39.2



