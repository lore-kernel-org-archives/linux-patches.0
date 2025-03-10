Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCC717CA12;
	Mon, 10 Mar 2025 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629195; cv=none; b=sn3s3JIE2Ux3nXlmzISpbKondS+q6wO8yk/uoBpfsd8bvF69Iwv+o8xrxo/tfkc6m5GVJ01PDapisDw4Bj8Pc6Az1XefIefhsdz/jQw+qqWJT675LRxuwbYt1qvK/B4lMy0UYyv+CcMI16r1l/ODNXAZeYc0a35jP2VNl/lA71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629195; c=relaxed/simple;
	bh=fRfhGHKrjNZcUH1+6Nx6gdPdMoJtlExX9GrI/veCYF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fngkaAVdPPfgTLZ7wp66dPs4gwkThGD5aYVVEBfGlZfgvWwFr7BsJcnx9x4Pri1n98N6N7B0YUJ2QNLlgsRRPf3yLyj2zxxTVr527fhc18C1D4rCtb5RmJPe1FDDIhoK7jZR1RPhLaYpwz32tWTlP3zuhzbVqILnNJqwcfK+7sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kR27G2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kR27G2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C8BC4CEE5;
	Mon, 10 Mar 2025 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629195;
	bh=fRfhGHKrjNZcUH1+6Nx6gdPdMoJtlExX9GrI/veCYF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kR27G2nDthvd+0q9Op/mn39aqDxvqsyB4NfEw/FqxD2qAjKmpAJsa33akfVd9ns2
	 TTFjHtEPfHoDMCzzT6DVosBXsgacACXs7lboFngkf/D9wGoEHpsW5aikFuqO+PzF4L
	 GaJL8UUFe2AZmR3E3UoverIjaTEqoazfeMmfzrds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stas Sergeev <stsp2@yandex.ru>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/620] tun: fix group permission check
Date: Mon, 10 Mar 2025 18:00:55 +0100
Message-ID: <20250310170553.875350778@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 959ca6b9cd138..a85f743aa1573 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -575,14 +575,18 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
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
@@ -2718,7 +2722,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    !!(tun->flags & IFF_MULTI_QUEUE))
 			return -EINVAL;
 
-		if (tun_not_capable(tun))
+		if (!tun_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
 		if (err < 0)
-- 
2.39.5



