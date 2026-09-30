Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A65187F2;
	Wed, 30 Sep 2026 18:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793388; cv=none; b=JUTLz53X6OAQ1f+3fsqFetC9JvpaVaa0CYynSyj/OfgfJt7jDSBatqbySi/BZYPLJcqbyNwphXQwngmBttujJmJrwrt7EYY7/Lnu5a5I44vWnyTJAN6DbFqet9QCIjiT53lvpyTrymnsB79yD+unQvKmWbsTwkwnt7WRwsggBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793388; c=relaxed/simple;
	bh=nT25m1otKWxAiPVOkN3WL9zIdyIdbB2WUyLQtk6Ftm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpEjKFGwGExUGH5rX01cQs2A3AFCe7o3LGhizOGKvQ5UOc1VaE1ECJu/ZF8OTEgFlpAVpK0erTi83dljx6AZHCVaZlVRM2bCEZGy70CuliNO6K6r445bIDRh098Ii7xxk0KiQV67kEF0ccVm3rFMVSztBbDvrnj6oREBoW9qDKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=170kfcHE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="170kfcHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A051F000FF;
	Wed, 30 Sep 2026 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793386;
	bh=Y6ZpdVs26fkCQRm5eLmLOSTDS8cpGCSJm1l1MuVImnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=170kfcHEOs50VyAO/rmNSFio7YoaysGCinJHhnxh5HHnmLLOjajuClbwJU+KxYo2W
	 5XcGznJN3987hFS2XLQnhXKC6QO+PFd70mwxq9NcziHmskN0RUCW4UoyNJnvR02qWK
	 36sGGD7YMwdvE1WpYyc/Zs6yWWNxAAGBNY/g7iIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 220/395] fou: reject omitted FOU_ATTR_IPPROTO on FOU_ENCAP_DIRECT
Date: Wed, 30 Sep 2026 17:28:02 +0200
Message-ID: <20260930152345.434549426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit d22609f3d13fc5baacd92c222731b03c593401db upstream.

Commit 7a9bc9e3f423 ("fou: Don't allow 0 for FOU_ATTR_IPPROTO.") added
NLA_POLICY_MIN(NLA_U8, 1) to fou_nl_policy[FOU_ATTR_IPPROTO], which
rejects an explicitly supplied FOU_ATTR_IPPROTO == 0 attribute with
-ERANGE.

However, FOU_ATTR_IPPROTO is an optional netlink attribute. When a user
sends FOU_CMD_ADD with FOU_ATTR_TYPE set to FOU_ENCAP_DIRECT and omits
FOU_ATTR_IPPROTO entirely, nla_policy validation succeeds and
parse_nl_config() leaves cfg->protocol as 0 (from memset(cfg, 0,
sizeof(*cfg))). fou_create() then creates a FOU_ENCAP_DIRECT socket with
fou->protocol == 0.

In fou_udp_recv(), returning -fou->protocol to udp_queue_rcv_one_skb()
triggers IP protocol resubmission when fou->protocol > 0, whereas
returning 0 tells the UDP tunnel layer that the skb was consumed without
freeing it. When fou->protocol == 0, every packet received on the socket
returns 0 from fou_udp_recv() and leaks the sk_buff.

Reject FOU_ENCAP_DIRECT when !cfg->protocol in fou_create() so that
creating a direct encapsulation port without FOU_ATTR_IPPROTO fails with
-EINVAL while leaving FOU_CMD_DEL and FOU_CMD_GET (which share
parse_nl_config()) unaffected.

Tested in QEMU against Linux 7.3.0-rc3 by sending a FOU_CMD_ADD Generic
Netlink request with FOU_ATTR_PORT = 5555 and FOU_ATTR_TYPE =
FOU_ENCAP_DIRECT while omitting FOU_ATTR_IPPROTO. On the unfixed kernel,
FOU_CMD_ADD succeeds (err = 0), FOU_CMD_GET reports fou->type = 1 and
fou->protocol = 0, and sending 4000 UDP packets to 127.0.0.1:5555 leaks
all 4000 sk_buffs (SUnreclaim in /proc/meminfo grows from 41456 kB to
59008 kB, +17552 kB); with this patch applied, FOU_CMD_ADD is rejected
with -EINVAL (-22).

Fixes: 23461551c006 ("fou: Support for foo-over-udp RX path")
Fixes: 7a9bc9e3f423 ("fou: Don't allow 0 for FOU_ATTR_IPPROTO.")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260921045920.1613098-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -603,6 +603,10 @@ static int fou_create(struct net *net, s
 	/* Initial for fou type */
 	switch (cfg->type) {
 	case FOU_ENCAP_DIRECT:
+		if (!cfg->protocol) {
+			err = -EINVAL;
+			goto error;
+		}
 		tunnel_cfg.encap_rcv = fou_udp_recv;
 		tunnel_cfg.gro_receive = fou_gro_receive;
 		tunnel_cfg.gro_complete = fou_gro_complete;


