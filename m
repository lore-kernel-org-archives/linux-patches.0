Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6902726B080;
	Thu, 13 Feb 2025 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459366; cv=none; b=o0Fp0EVdJCA071eH8V9vM7VyngUJvBZ6hSMF9dQeP1sxXgaenCEfPVcNVvWBbSDdInbOBYrfPoSvhSuWXN+o82Fn9bM/56CCATcc7R5LsUsNRUGQc3daim+pEqGWsQHbGSEpniWWkygVFsASB+NXkq90i1jiS/rVyR95/bz+Pus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459366; c=relaxed/simple;
	bh=2Qz6DPh1Lk+luCAbCYxcEqwVTvZedn+9OiVVWpRrvcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GryNUY90M80NqG94+jtkqADweFE1wZGuBLSaW+B4tJpTuSq38W7fSxjXEh54ieqtvL7yfpwIYUhqhV/+al7jdqvOeajnoz/Mv4ruqrellf134erL+y6SyHmAY94LFFeQPdGGO/zbkDPP3/cEUCuPir7mJ8DNLGaNeASd5Ap+tpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxtvnMxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxtvnMxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2929C4CED1;
	Thu, 13 Feb 2025 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459366;
	bh=2Qz6DPh1Lk+luCAbCYxcEqwVTvZedn+9OiVVWpRrvcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxtvnMxQW1JCIqlC+jyveilXQk8T3anGb1GQ9awybYbdhMxWbUx7/4hCXFx6wvg7P
	 le+YN2vA8K2CtOdVRdD+MGVy+44gzN/21UP8JZlaAGQ7Zpgyd60GuNNFiGcYFfYS8B
	 QuLAC1waVHcjMLCvW9p/0bYDnJ1q9qTlaGLktqiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dave Young <dyoung@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH 6.13 212/443] x86/efi: skip memattr table on kexec boot
Date: Thu, 13 Feb 2025 15:26:17 +0100
Message-ID: <20250213142448.797679896@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Young <dyoung@redhat.com>

commit 64b45dd46e154ee7641d7e0457f3fa266e57179f upstream.

efi_memattr_init() added a sanity check to avoid firmware caused corruption.
The check is based on efi memmap entry numbers, but kexec only takes the
runtime related memmap entries thus this caused many false warnings, see
below thread for details:

https://lore.kernel.org/all/20250108215957.3437660-2-usamaarif642@gmail.com/

Ard suggests to skip the efi memattr table in kexec, this makes sense because
those memattr fixups are not critical.

Fixes: 8fbe4c49c0cc ("efi/memattr: Ignore table if the size is clearly bogus")
Cc: <stable@vger.kernel.org> # v6.13+
Reported-by: Breno Leitao <leitao@debian.org>
Reported-and-tested-by: Usama Arif <usamaarif642@gmail.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/efi/quirks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 846bf49f2508..553f330198f2 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -561,6 +561,11 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 
 		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
 			((efi_config_table_64_t *)p)->table = data->smbios;
+
+		/* Do not bother to play with mem attr table across kexec */
+		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
+			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
+
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);
-- 
2.48.1



