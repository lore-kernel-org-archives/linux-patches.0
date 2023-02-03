Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6961FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5377DC433EF;
	Fri,  3 Feb 2023 10:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419678;
	bh=xNLlM0vgOoZumvkMe4pG8MRbbYt6SRM4dVC9pSEGDOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLo0ql6/M1CKnKcdEaH79BEiBGxCE9nr11jtW2r7JqxAeJiLCCmC77l3YN0d9CPeR
	 hLa6KANboWJ1tk7y/0uHlSt1KWU6bMC46tmhYOHl3WsdZdGJvpEos8ac6TPylLhl9V
	 tuQv3wf5iVuL6o1k29mSOcYtF2mauM8J3N+IC3hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/80] ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
Date: Fri,  3 Feb 2023 11:12:45 +0100
Message-Id: <20230203101017.389739574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1d1d63b612801b3f0a39b7d4467cad0abd60e5c8 ]

if (!type)
		continue;
	if (type > RTAX_MAX)
		return -EINVAL;
	...
	metrics[type - 1] = val;

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 6cf9dfd3bd62 ("net: fib: move metrics parsing to a helper")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230120133040.3623463-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/metrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 04311f7067e2..9a6b01d85cd0 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -1,4 +1,5 @@
 #include <linux/netlink.h>
+#include <linux/nospec.h>
 #include <linux/rtnetlink.h>
 #include <linux/types.h>
 #include <net/ip.h>
@@ -24,6 +25,7 @@ int ip_metrics_convert(struct net *net, struct nlattr *fc_mx, int fc_mx_len,
 		if (type > RTAX_MAX)
 			return -EINVAL;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 
-- 
2.39.0



