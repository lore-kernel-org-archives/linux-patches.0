Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA67328255;
	Mon, 13 Apr 2026 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099373; cv=none; b=uZgXuTqsW7ypkyTeGEAHJPSofMGfAvkaudanJXFUQK8PP2fbrkFhpU5d7K3Y1X/b2+ouTW1ulGAJk3tbcRHE5jXqZx+32I0TdKqF3/V7XnMdOK3ZqvJ6ooG7aaNYBNqUynhChmbO8nz0NaEW0eEknZzyrZyFhJ4+aSX5kIlV6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099373; c=relaxed/simple;
	bh=/JlQH7SJp2XJ7pADkqx5KoevZBFZyqPOAjWRE8xNRyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q09t3dnDG6BtjO5y/TGyllVDcT++xic7qfRZWuZ7/ZnsE+pdBETx3uzlQxb2dPoPpp7LTv8MMyIsuZXCuhC2mfC70dUDe/pCl54WPAt/ckHq1VLTSuSifb53mM0AYr97BpMHTyWQyV1NMHWDWTvQVjsazzvPFMSKW75cAgGYsks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXgu2iSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXgu2iSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98053C2BCAF;
	Mon, 13 Apr 2026 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099372;
	bh=/JlQH7SJp2XJ7pADkqx5KoevZBFZyqPOAjWRE8xNRyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXgu2iSmGDsyhER+7rxRp05U2C0072vRJ9toU+yokLslng8p7ZYYWKrHyPNyUr08Z
	 EF6HseZsxcRgYi4lPr4Yiv9NhrHDTbd6NiIOoVIuO99TQnXAZvvFc2Azd45Ycd2XPm
	 0333asfm5y5i3KdXaXjommFQHOAyWUnztUinhCLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/491] x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size
Date: Mon, 13 Apr 2026 17:58:48 +0200
Message-ID: <20260413155829.640615643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a152d57624004..99b282d6c1302 100644
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



