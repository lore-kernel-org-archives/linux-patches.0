Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1246223DD6;
	Tue, 30 Sep 2025 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246156; cv=none; b=OcZOFjPXd9AaHRdCzZ2inpB3hyn+VCzfjHUvO6TRWRqoZbLWEv1VVpJ2fPNvi9NYPOaxYVBMoJrUWMVkgjnJ4GjUUJe0sT9uPnJ3d4pGEafuCIO0Y6wCPfsMj/NYiQp6hXDwephlQJdjCB7FnTxHNsrQIYaDpqV2dJihlu+n1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246156; c=relaxed/simple;
	bh=U+ERv5sA8q082R7CuW0kcX4clP4GKhAlOTZ0L85lc2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTkik7RMDZwWzgQEx6zjGLAAqxBEUWHBbD+5XqdIyYCnAhErG6zw96H/7cdfky0P11G0s4tWC54lHty0HvUDvgYrqAJxCj+EL+Qs6lNBsbLc2ohGkkfvgNOwXbwZkHbBpOYnSmnRUTfKZeCvfo5EzlsJBWacU132DvMHdIgd6PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNmFg3iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNmFg3iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5AEC4CEF0;
	Tue, 30 Sep 2025 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246155;
	bh=U+ERv5sA8q082R7CuW0kcX4clP4GKhAlOTZ0L85lc2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNmFg3iY3ytb2lcJz5LPTS61IfaYiAinAFUo8pXv/hrzAZpwsx5d99aOZhurNsWma
	 HFftJ5PIJfGzoDkZP/QPY/TvN7FrfSdFioaQ/GWdQ27Elc9xs+9f7cGmR52t9UmMmD
	 DY98FM4I+ulk5UMY4KYf9akGU8rXiuRHdCB6dLzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a25ee9d20d31e483ba7b@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 39/89] xfrm: xfrm_alloc_spi shouldnt use 0 as SPI
Date: Tue, 30 Sep 2025 16:47:53 +0200
Message-ID: <20250930143823.541595363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cd8ae32e4e4652db55bce6b9c79267d8946765a9 ]

x->id.spi == 0 means "no SPI assigned", but since commit
94f39804d891 ("xfrm: Duplicate SPI Handling"), we now create states
and add them to the byspi list with this value.

__xfrm_state_delete doesn't remove those states from the byspi list,
since they shouldn't be there, and this shows up as a UAF the next
time we go through the byspi list.

Reported-by: syzbot+a25ee9d20d31e483ba7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a25ee9d20d31e483ba7b
Fixes: 94f39804d891 ("xfrm: Duplicate SPI Handling")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 6f99fd2d966c6..1e2f5ecd63248 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2502,6 +2502,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 
 	for (h = 0; h < range; h++) {
 		u32 spi = (low == high) ? low : get_random_u32_inclusive(low, high);
+		if (spi == 0)
+			goto next;
 		newspi = htonl(spi);
 
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
@@ -2517,6 +2519,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 		xfrm_state_put(x0);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
+next:
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			goto unlock;
-- 
2.51.0



