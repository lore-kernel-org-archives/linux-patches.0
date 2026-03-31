Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4A140710B;
	Tue, 31 Mar 2026 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975195; cv=none; b=Qix50Gb/HCcr+r5u6os8DkfclCXwY2qs/Xfjz3w+/NtT6nKPDj+Js/CMLpuERZc4Zyrd8oXQ5+rn9ASbQrUb2oN1nNspnk+gvycmkkTVcBwcNuPdRIMH0EJE1Wbw3BifJ0sukzytTE4mBX7bjXUWO7zJjlA1iy3+bMQE7mR8UGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975195; c=relaxed/simple;
	bh=kfxII0cZhz4kO1bndNlS7Dpg7Dv2ufEqb6lOdOdRTeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBnnXQ+k5Rqi3EYYvDp/9OzxxKxRZoCKWSwvyfbYC4wUDIxFXcvRDPjaVSP0a4cYk3iWgwr0tMz7cUrxB/GJ9HKMf2sDZf6PXktnvp3hreJRvg7wYWj868METKy1if+ShA4BTVnw0R/I+BClgog1F6aiiE0jM2olWiY7TI1Tktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOlH/quT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOlH/quT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D593AC19423;
	Tue, 31 Mar 2026 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975195;
	bh=kfxII0cZhz4kO1bndNlS7Dpg7Dv2ufEqb6lOdOdRTeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOlH/quT3BrzgbLay3bsDXOdH/BJoj9QKXoAjbe56LH0891NmByAnEwDMB3fyEvMi
	 d1P4SffxApF0jPXm5yN9EgKMa+MJc1NkxvyyAPgSS7y+tY5FMHE/MR/9uMxRK+9Qxk
	 95FoswSSk8E38OD1dEHD2z2l7q74P6o2W9SaYXk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 167/342] x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size
Date: Tue, 31 Mar 2026 18:20:00 +0200
Message-ID: <20260331161805.155526091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 35caa5746115d..79f0818131e83 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
-- 
2.53.0



