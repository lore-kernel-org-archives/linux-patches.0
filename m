Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4232C14A60D;
	Tue,  8 Jul 2025 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993484; cv=none; b=r/XQkWcBPAKX+/6ZCglkrIZdB+CklNfNVaedwbn1wN2vKFebYbaS09kX3mMEGJwiG8EYG2JEL6gR7vzTrp8+/u7fAbyLc8ZMiW5z+j0mE6lafMuPBg9KfA8qWlucAqLumBiHk51a2lnipP7I8dtY+8MJi7/IrIyPB5QI5wPhHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993484; c=relaxed/simple;
	bh=Xlshf4eh0oyeLBG7AF06sAzwceONPKp9PoD1423Vfqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2Az2MzxMDm6e7yjvxQElcS36muMDr/Jyka8a/bvQaVEa/bT9KeKP1E42prqUHUhLhVwQI41gJmKfrlIGWdb3YgGf8MVXxCJzK+WOIq7e63facLp+mUGfKhi6EwrQRs+jLBLthVF1HBAyuOei36cXnZz+xriY7OddXhNfdJ/5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzDuLg8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzDuLg8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF55C4CEED;
	Tue,  8 Jul 2025 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993484;
	bh=Xlshf4eh0oyeLBG7AF06sAzwceONPKp9PoD1423Vfqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzDuLg8CqSwInGO91+TGnAnk9NzuSH5BPtq4mxEUaaJf6C/vGQMS2Lq5RQaGXIg6m
	 0WQliyh28h+82e4DCrdIFAPmoVB/8pViHzvMQx40dmtsSqfhTTsuj0WP4zD5vIlp/d
	 HIVKA6dL8+5aH7lu7XYEc5U0Meb/NuGhumWWhQAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marko Kiiskila <marko.kiiskila@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 089/178] drm/vmwgfx: Fix guests running with TDX/SEV
Date: Tue,  8 Jul 2025 18:22:06 +0200
Message-ID: <20250708162238.995085588@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marko Kiiskila <marko.kiiskila@broadcom.com>

[ Upstream commit 7dfede7d7edd18c0c91ca854cde8eaaf4ccf97ea ]

Commit 81256a50aa0f ("x86/mm: Make memremap(MEMREMAP_WB) map memory as
encrypted by default") changed the default behavior of
memremap(MEMREMAP_WB) and started mapping memory as encrypted.
The driver requires the fifo memory to be decrypted to communicate with
the host but was relaying on the old default behavior of
memremap(MEMREMAP_WB) and thus broke.

Fix it by explicitly specifying the desired behavior and passing
MEMREMAP_DEC to memremap.

Fixes: 81256a50aa0f ("x86/mm: Make memremap(MEMREMAP_WB) map memory as encrypted by default")
Signed-off-by: Marko Kiiskila <marko.kiiskila@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20250618192926.1092450-1-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 0f32471c85332..55c822a61b9ad 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -769,7 +769,7 @@ static int vmw_setup_pci_resources(struct vmw_private *dev,
 		dev->fifo_mem = devm_memremap(dev->drm.dev,
 					      fifo_start,
 					      fifo_size,
-					      MEMREMAP_WB);
+					      MEMREMAP_WB | MEMREMAP_DEC);
 
 		if (IS_ERR(dev->fifo_mem)) {
 			drm_err(&dev->drm,
-- 
2.39.5



