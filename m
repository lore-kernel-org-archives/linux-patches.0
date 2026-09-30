Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8930E3438A1;
	Wed, 30 Sep 2026 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791594; cv=none; b=OfIPHhgYTXC0eKZuDCIT9WCyGmw6cM8jN0VZ8yZ6Y0LuGtvGoonCM3wnZwuLHv91dTUzkX1IxAoDfE1SxhZ/vwclvAamvCKFd//EoB4dauY2CP6k6VVmlA8JuX5aEABcsg4Ctx7GVTk8Q97S/t3mO6OndysmL4WTFgOwLLivgwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791594; c=relaxed/simple;
	bh=mV/0FXnDlaYrVVC5ABybJdSsXP0ggMk82c97AYSJ29I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN5Inx8Zs21dU15kO4a9e5mLAMrQbEKgHxItXeX+udzJP22qGPWXYHL90O+E6sN6TprgJANdlcyeWZq+HSKINMqRaRLY3fBmZuIL2Tpem1y9AsbvTnaQtjHhA9JviEb/si/ZuV3bxYtliJ2xlQOsMmLoMNzFRO3yzO+J5ee1Nik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gg3Asw5G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gg3Asw5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66A41F000FF;
	Wed, 30 Sep 2026 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791593;
	bh=WQqmJOpksrJ4ExONfbThorIm9PleYUBdgJ3Wd78vS8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gg3Asw5GFm/1dCaT7hiqxPT1GDlHXGYQZedrdWiAI9j8KeMU+Z3dBgN3RFq43V5Fo
	 CUT4MogNcYgHxTWmyD8gYT5C3p0j2KxhlDPeiBk9YbqzX+oqHJJuOPlKy1Xf2KBCw+
	 4tNHji/J/826o6qLRMvZ47ex/3FcXaED8OHe4O4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	rds-devel@oss.oracle.com,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/752] net/rds: Pass a pointer to virt_to_page()
Date: Wed, 30 Sep 2026 17:23:46 +0200
Message-ID: <20260930152405.987505100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a60511cf15204e41f4edbcdc4ee80208d528917c ]

Functions that work on a pointer to virtual memory such as
virt_to_pfn() and users of that function such as
virt_to_page() are supposed to pass a pointer to virtual
memory, ideally a (void *) or other pointer. However since
many architectures implement virt_to_pfn() as a macro,
this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr)
function the following happens (occurred on arch/arm):

net/rds/message.c:357:56: warning: passing argument 1
  of 'virt_to_pfn' makes pointer from integer without a
  cast [-Wint-conversion]

Fix this with an explicit cast.

Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: rds-devel@oss.oracle.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220829132001.114858-1-linus.walleij@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2ac09b5353fe ("net/rds: fix tcp stream corruption with large pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 987ef9ca5a8fd..cd13f0c4de540 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -364,7 +364,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
-				virt_to_page(page_addrs[i]),
+				virt_to_page((void *)page_addrs[i]),
 				PAGE_SIZE, 0);
 	}
 
-- 
2.53.0



