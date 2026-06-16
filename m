Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1746AEC5;
	Tue, 16 Jun 2026 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626850; cv=none; b=J/VdziMVFcVp76kVtxsjzrjG778c39H6vefxI2nyVoz3qQE3KxpT+38rady5q1zLarhjtddrX72N85ei074HOzQDjJVGs259BgXmNGuREl14WA68yv3kMJN1ON9BNcBzdmg8m7z5Zzs6ZzqVIOahQf4t6eH2aBOU8kkBXYIpUR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626850; c=relaxed/simple;
	bh=da6Q2dUSd9dl6Jxqx4birqi73xhf/zZsi2kJkWHqgbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkvB2nR1mOfCK+qjOqW9LqfWp7BKG1kmEar8Mr1V4oX/jvDf/YvxUs27xbOrZHXYE1gbLgFOP+Dwmmc7hkWuoQiGcS8xKqMks/0jk+oH4ZfN1qlBdC20pJp75c/9ZB5Pizt6jI3JpJ/w5Ahr+0FPQwSofbZeCLnDa4M3sVd8YMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fcpi11XQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fcpi11XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00551F00A3A;
	Tue, 16 Jun 2026 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626849;
	bh=uSL3DnMJh8bp3s8A9B7DDASPUpzJpFsA1i081m66j8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fcpi11XQyhnFtpm7Kz7237sPHscna04vHoqUXqI2+Oh1QnPuU/RM2QtOzs7rGT2N9
	 oBAYm+mcoVbj8Dkm+hZvC2Oj4wx1SZBiZzhjeevxWVLkxh6hId3BD+REcydnj4FbVy
	 OTbKNP81ArkWvus53L99bCypQCh0x4uTMjgc0ZJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/261] netdev: fix double-free in netdev_nl_bind_rx_doit()
Date: Tue, 16 Jun 2026 20:28:40 +0530
Message-ID: <20260616145048.866185076@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c849de7d8757a7af801fc4a4058f71d481d367f2 ]

Sashiko flags that genlmsg_reply() always consumes the skb.
The error path calls nlmsg_free(rsp) so we can't jump directly
to it. Let's not unbind, just propagate the error to the user.
This is the typical way of handling genlmsg_reply() failures.
They shouldn't happen unless user does something silly like
calling the kernel with an already-full rcvbuf.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 0fe537781bc4d9..6d4db55e90ed5a 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -854,12 +854,10 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 	genlmsg_end(rsp, hdr);
 
 	err = genlmsg_reply(rsp, info);
-	if (err)
-		goto err_unbind;
 
 	rtnl_unlock();
 
-	return 0;
+	return err < 0 ? err : 0;
 
 err_unbind:
 	net_devmem_unbind_dmabuf(binding);
-- 
2.53.0



