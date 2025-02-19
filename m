Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFC81E5716;
	Wed, 19 Feb 2025 09:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956882; cv=none; b=JiQjN1epKuK6Xfe2Ky8JxeOgxO51KULG/djGj5ub99PVDJIz/qEwA6Cm6hUbpgUN/gBFFC26qC7SHFrp4NvbIB61ShNcEjzm9qU2s24lJfGKjF/LQhADkBKCnW1MgrlGVZ7tY868tZr23//hjT36UUs9O5b6lM4/arBc678vi7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956882; c=relaxed/simple;
	bh=Q9U9JPlmquelH+gTVProAnRThM7OxRNtCtlw4YUMRvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIY8sBfjlQkB7B6CyUO10ir5TkUUSJjteC8cpwK1YInyKGZPEJU/AihkAvLXwci8IrWG/+eBFwP4HYg7e+Vh9nq93ie3Ib3sLt4L4cFu5HPNeoKuSn0royIXpxKaOsBQSeGhUTDMIqOxBHCqNvv3e5UFn4h0oBJEEdk469Iy9e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPIygfK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPIygfK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25488C4CED1;
	Wed, 19 Feb 2025 09:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956881;
	bh=Q9U9JPlmquelH+gTVProAnRThM7OxRNtCtlw4YUMRvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPIygfK8L6fCbkNP6GgRyAgzqbTiAvXv21DwmOyD09Pz5xiL+wnpEfKefwVme+TGA
	 WSQ9ZEsuD64U+ztOTn3s7gwxYz9e6qJJHesuxk2zjWcyzSq2DvLda5bf59nJaunU6m
	 0trDJzU9X//HawYBanhWNCkhfH9Ty3F4oQo3C7Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Stas Sergeev <stsp2@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 333/578] tun: revert fix group permission check
Date: Wed, 19 Feb 2025 09:25:37 +0100
Message-ID: <20250219082706.117244664@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit a70c7b3cbc0688016810bb2e0b9b8a0d6a530045 ]

This reverts commit 3ca459eaba1bf96a8c7878de84fa8872259a01e3.

The blamed commit caused a regression when neither tun->owner nor
tun->group is set. This is intended to be allowed, but now requires
CAP_NET_ADMIN.

Discussion in the referenced thread pointed out that the original
issue that prompted this patch can be resolved in userspace.

The relaxed access control may also make a device accessible when it
previously wasn't, while existing users may depend on it to not be.

This is a clean pure git revert, except for fixing the indentation on
the gid_valid line that checkpatch correctly flagged.

Fixes: 3ca459eaba1b ("tun: fix group permission check")
Link: https://lore.kernel.org/netdev/CAFqZXNtkCBT4f+PwyVRmQGoT3p1eVa01fCG_aNtpt6dakXncUg@mail.gmail.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Stas Sergeev <stsp2@yandex.ru>
Link: https://patch.msgid.link/20250204161015.739430-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a6c9f9062dbd4..03478ae3ff244 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -574,18 +574,14 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return ret;
 }
 
-static inline bool tun_capable(struct tun_struct *tun)
+static inline bool tun_not_capable(struct tun_struct *tun)
 {
 	const struct cred *cred = current_cred();
 	struct net *net = dev_net(tun->dev);
 
-	if (ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return 1;
-	if (uid_valid(tun->owner) && uid_eq(cred->euid, tun->owner))
-		return 1;
-	if (gid_valid(tun->group) && in_egroup_p(tun->group))
-		return 1;
-	return 0;
+	return ((uid_valid(tun->owner) && !uid_eq(cred->euid, tun->owner)) ||
+		(gid_valid(tun->group) && !in_egroup_p(tun->group))) &&
+		!ns_capable(net->user_ns, CAP_NET_ADMIN);
 }
 
 static void tun_set_real_num_queues(struct tun_struct *tun)
@@ -2771,7 +2767,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    !!(tun->flags & IFF_MULTI_QUEUE))
 			return -EINVAL;
 
-		if (!tun_capable(tun))
+		if (tun_not_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
 		if (err < 0)
-- 
2.39.5



