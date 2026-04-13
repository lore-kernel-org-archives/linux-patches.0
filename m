Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AA71A275;
	Mon, 13 Apr 2026 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097999; cv=none; b=f2tMbmgXIlLyOPp+m9kp0gjuRNUofDLWURKOsdsNZY+6iBH5GK2pgs7LE0ZNT/v8oHOrReOaECh6U5U+GJh982GjKWTiIMRzD3zv8dwLiX5KWbsVA68R894ovR7EiAz1p+HfAyV84WpU11JmnPXwfJxLzCKG2DLoqSckW+l/e1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097999; c=relaxed/simple;
	bh=6Cp4EvXGtgeILz/9p+6QqNAxQdrCcna4R6mdzkM7/NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKAue4c1dytW73LM2SrFYnyGTxTk3z1F+pwf9tw8OGpf40c6n4kkZXNvQYz7UhMcL1kybrJi8fXpGTTPloMnxZNSKFkznBgtAS6s94fuD7lJmoIztvewt/g6YtF/f/bSvH0vk7MYqWZbVBHe+7yKHIVgiGKyCnu7Hp0LOnUiPvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZ/CraOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZ/CraOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C5DC2BCAF;
	Mon, 13 Apr 2026 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097999;
	bh=6Cp4EvXGtgeILz/9p+6QqNAxQdrCcna4R6mdzkM7/NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZ/CraOUMw3LSPuPs1WMISefWUu2H7rh1Id0ISgPp7/thKD6CrfsVC3QOywXPHf0+
	 wt4q3tgywJe19uuqNCa14FNGVAY0QR4yOxesvsnkhPJkNfLMyAWGHnYI9Rc0j8+MRa
	 Ca3UVeVVpb1Rnpf19Hp3VVNHzoP/p5eKck6gHMi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/570] x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size
Date: Mon, 13 Apr 2026 17:58:05 +0200
Message-ID: <20260413155843.746693588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb ]

ranges_to_free array should have enough room to store the entire EFI
memmap plus an extra element for NULL entry.
The calculation of this array size wrongly adds 1 to the overall size
instead of adding 1 to the number of elements.

Add parentheses to properly size the array.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index e3b00f05a2532..b0d0376940ba8 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -416,7 +416,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
-- 
2.53.0



