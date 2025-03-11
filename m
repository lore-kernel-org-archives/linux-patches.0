Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7765B846D;
	Tue, 11 Mar 2025 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706690; cv=none; b=LzU8QmPrwfBPyWzCDEuBDLR6I+0lg0/sI/TTKc/T7jKmM9vR0TzsTCfDbFlf5pEUqbQAtd59df4RVeXAk9IPmZdWfMbuH5cV4TY4akGtLleKbLv7AhgCTmvYNVqYNMvcryEsl1fnpiHGNNidffEWVia1QLbscH7a5qruCWa/BkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706690; c=relaxed/simple;
	bh=9M5frO+y7Q5pjH4eY2gvAJ4+J49+NYxAOp2rmg5pUVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNBZQOPkuz8jqGyW7xc9wfegyj9MoHsFW1Hup7Lqmaz7SNSzZZpiQ1iNzyNg9NOgxgmRZlFSNbhKDrUEIVdbUVwEsuA/+A1fOlchJm+KIpmzu/xTcTy1QLtC7o6Bhgh7iyADzqQi/lCWGHN1I8ZReGzSpKo8DGZC7rmx3uWT+tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1tVk5/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1tVk5/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94797C4CEE9;
	Tue, 11 Mar 2025 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706690;
	bh=9M5frO+y7Q5pjH4eY2gvAJ4+J49+NYxAOp2rmg5pUVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1tVk5/x59m3Z/nxcN/t8Bdc2OG++fKfONgCmWLijwZJWcYwNUS1XxNBsvs5OasHt
	 fToTnilgI/mUqS5eoJGs3xLQ7el4h0xYT0ZBDgUUdpfi1XqebVuJnYONGYK6NCfVzG
	 z/JZOg3k+c3iTiZ76qq3PVLOqo91g7+dCV83AtqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stas Sergeev <stsp2@yandex.ru>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/462] tun: fix group permission check
Date: Tue, 11 Mar 2025 15:56:39 +0100
Message-ID: <20250311145803.614155184@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c34c6f0d23efe..52ea9f81d388b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -586,14 +586,18 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
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
@@ -2772,7 +2776,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    !!(tun->flags & IFF_MULTI_QUEUE))
 			return -EINVAL;
 
-		if (tun_not_capable(tun))
+		if (!tun_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
 		if (err < 0)
-- 
2.39.5



