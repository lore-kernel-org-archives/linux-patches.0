Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56B5206F05;
	Thu, 13 Feb 2025 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457222; cv=none; b=qNum6xqV/CLe//jqtVwatlxyf5CwQRwN0jzIVzYmZYgT1HCzdI+DddL1hlcSvVqGxLFG8+TnbC8+sqv5AQOqtnvXu8OrTIv2EVwN0aFGSVa5gJca6+cT5M2An8dHq31ukdMEFLWbdXn2YmPrRxqPAsrOug2nmS0WDyNGUyn2Exg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457222; c=relaxed/simple;
	bh=FqFf9kpvJma/sKqv++XkblVW3vJWi7YdYeJDit+ZljQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzuTJlm4qPMIcdwGH+98A/KN4c+eaJIJRJmMYx8pa/pisuhdDQ6qzrUkeiOHbtvI/xhoy1fbdfJfgYKsZ5+WFp3iZ2S0htddcpDHJcgszHm7ybgjuvPBJFkDBusFjTsTI12f7gH9MHN6cYJOMENQDJxbV5fRzQblxay+8tDpRNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cknrqEHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cknrqEHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421E3C4CEE2;
	Thu, 13 Feb 2025 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457222;
	bh=FqFf9kpvJma/sKqv++XkblVW3vJWi7YdYeJDit+ZljQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cknrqEHYxxY54CJT+XR2XXY38tUh29OJV3JexBxhWRVjnKOfxbaRk0NOrSTQEfS53
	 t0OSLpgtZGB+ryoJzlPOVXlJU0Ll1p0jbh33tsUBnbj4EIGszlf7z38rIi7incRdsA
	 rsscEQlkqa6FXZmXNKzRnfnd/61ce8K07t0Bctnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stas Sergeev <stsp2@yandex.ru>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/422] tun: fix group permission check
Date: Thu, 13 Feb 2025 15:23:18 +0100
Message-ID: <20250213142438.455229760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stas Sergeev <stsp2@yandex.ru>

[ Upstream commit 3ca459eaba1bf96a8c7878de84fa8872259a01e3 ]

Currently tun checks the group permission even if the user have matched.
Besides going against the usual permission semantic, this has a
very interesting implication: if the tun group is not among the
supplementary groups of the tun user, then effectively no one can
access the tun device. CAP_SYS_ADMIN still can, but its the same as
not setting the tun ownership.

This patch relaxes the group checking so that either the user match
or the group match is enough. This avoids the situation when no one
can access the device even though the ownership is properly set.

Also I simplified the logic by removing the redundant inversions:
tun_not_capable() --> !tun_capable()

Signed-off-by: Stas Sergeev <stsp2@yandex.ru>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20241205073614.294773-1-stsp2@yandex.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6fc60950100c7..6c24a9ce6c155 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -574,14 +574,18 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return ret;
 }
 
-static inline bool tun_not_capable(struct tun_struct *tun)
+static inline bool tun_capable(struct tun_struct *tun)
 {
 	const struct cred *cred = current_cred();
 	struct net *net = dev_net(tun->dev);
 
-	return ((uid_valid(tun->owner) && !uid_eq(cred->euid, tun->owner)) ||
-		  (gid_valid(tun->group) && !in_egroup_p(tun->group))) &&
-		!ns_capable(net->user_ns, CAP_NET_ADMIN);
+	if (ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return 1;
+	if (uid_valid(tun->owner) && uid_eq(cred->euid, tun->owner))
+		return 1;
+	if (gid_valid(tun->group) && in_egroup_p(tun->group))
+		return 1;
+	return 0;
 }
 
 static void tun_set_real_num_queues(struct tun_struct *tun)
@@ -2778,7 +2782,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    !!(tun->flags & IFF_MULTI_QUEUE))
 			return -EINVAL;
 
-		if (tun_not_capable(tun))
+		if (!tun_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
 		if (err < 0)
-- 
2.39.5



