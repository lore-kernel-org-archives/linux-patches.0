Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3966E252917;
	Tue, 11 Nov 2025 01:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823821; cv=none; b=nBRY94ThT61FJ7akeNI5G4Vn4b1iY9F6K8jQi85Ps3ZEfLjXtlJzWc1StfrOTYNnU132d843aoHoxTZ6tSNIlPPr6qQVyRxNnk4tgr62uBPhSzo4g69DN3auQu/XaIiiLJ86T6ZtHfDTDS4EE1zK4j2RYTt6igC9RUVYUjU7ITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823821; c=relaxed/simple;
	bh=YPQyTY7hcstB1BfyU1HefkTzYiXs5cysOxAJ0FwxC5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3CrQYIDLF3mwa0zSbHJKAxF2tnL0ylzxzNffMlJWB+E7aG3X/atGJZvi6cfNRS6nFRlIgECnKCxyN33u4NT6shn4MpVc+0pI0sA2gOpb5HL2PiJZVLISqp5g2rwHoX65mPfvogv1OXIracwebS8Qgm9yUOzLbXR6kfxjrIJKzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8H3QyLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8H3QyLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E05C116B1;
	Tue, 11 Nov 2025 01:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823821;
	bh=YPQyTY7hcstB1BfyU1HefkTzYiXs5cysOxAJ0FwxC5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8H3QyLquFP8ikX91OrPLKM5qHoNSikDHpxf/yc3EjxhGfaslx06sXgzHG9HhxYKM
	 zuU9FjeFcwOHtTPvd9adonnq7ZcFA0lCLDttqGj+331p/zsAxe4g6luiSqL0NcIviJ
	 +pmtSaz/5EoIWLU99lTxOxA6eicxzH6UHakh1vb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	kernel test robot <lkp@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/565] Fix access to video_is_primary_device() when compiled without CONFIG_VIDEO
Date: Tue, 11 Nov 2025 09:43:07 +0900
Message-ID: <20251111004534.330864499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 6e490dea61b88aac9762c9f79a54aad4ea2e6cd1 ]

When compiled without CONFIG_VIDEO the architecture specific
implementations of video_is_primary_device() include prototypes and
assume that video-common.c will be linked. Guard against this so that the
fallback inline implementation that returns false will be used when
compiled without CONFIG_VIDEO.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506221312.49Fy1aNA-lkp@intel.com/
Link: https://lore.kernel.org/r/20250811162606.587759-2-superm1@kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/video.h | 2 +-
 arch/sparc/include/asm/video.h  | 2 ++
 arch/x86/include/asm/video.h    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/video.h b/arch/parisc/include/asm/video.h
index c5dff3223194a..a9d50ebd6e769 100644
--- a/arch/parisc/include/asm/video.h
+++ b/arch/parisc/include/asm/video.h
@@ -6,7 +6,7 @@
 
 struct device;
 
-#if defined(CONFIG_STI_CORE)
+#if defined(CONFIG_STI_CORE) && defined(CONFIG_VIDEO)
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
 #endif
diff --git a/arch/sparc/include/asm/video.h b/arch/sparc/include/asm/video.h
index a6f48f52db584..773717b6d4914 100644
--- a/arch/sparc/include/asm/video.h
+++ b/arch/sparc/include/asm/video.h
@@ -19,8 +19,10 @@ static inline pgprot_t pgprot_framebuffer(pgprot_t prot,
 #define pgprot_framebuffer pgprot_framebuffer
 #endif
 
+#ifdef CONFIG_VIDEO
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
+#endif
 
 static inline void fb_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
diff --git a/arch/x86/include/asm/video.h b/arch/x86/include/asm/video.h
index 0950c9535fae9..08ec328203ef8 100644
--- a/arch/x86/include/asm/video.h
+++ b/arch/x86/include/asm/video.h
@@ -13,8 +13,10 @@ pgprot_t pgprot_framebuffer(pgprot_t prot,
 			    unsigned long offset);
 #define pgprot_framebuffer pgprot_framebuffer
 
+#ifdef CONFIG_VIDEO
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
+#endif
 
 #include <asm-generic/video.h>
 
-- 
2.51.0



