Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B5A12C462;
	Tue, 30 Apr 2024 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474469; cv=none; b=J5OiEYzPC3ZSDrS622B5aN4nnIBt4MZ1gM/SPQqVfzJwMsPupOmDYYNftuX8KjibnxhQBEdOSuWksAr/Mhpsbmwh6JqbDRtxjpbKKmJstZfYjbRiX4h9Diu162bObygX/Vdx+ubE+wV0ptBj15hGkkevV1D0v/7UeeS6YmyyyxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474469; c=relaxed/simple;
	bh=kFzlQpMsLXhFL8X6mNVXRgO12VKmN/NqbipaGqnkn9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2p8CAsL/jOVeiR3zrJjukkQaN6VFxWBEdTpFAVstW7TTtwitPC2XSt2E2lf2sTg7PUlH3TAfu46NcO10SgqkKPj96RhmHG2gJGuM/EfnkwSNpzWjH3huYpT9M3Bx57IN7VhSU5KV80JRvC+sHNFmcIuKL7flZmRsq+SfdDTx+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo0l1OTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo0l1OTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76BAC4AF18;
	Tue, 30 Apr 2024 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474469;
	bh=kFzlQpMsLXhFL8X6mNVXRgO12VKmN/NqbipaGqnkn9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zo0l1OTKG6H2oHVY+af9WWNwxMtwQvyOfARyxf5wpYp3QCpij6EuDlXO09dPesFo9
	 tEO46xNXkJQUQO926PWWhVxZd7+mcw6fionpgmk/YTgVgyeheH/ll0SCe+v51Yvxxy
	 9WwXYT5EtTOv76JDvymvf4Txvz46AHbLxP0EsBMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiantao Shan <shanjiantao@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.8 166/228] LoongArch: Fix access error when read fault on a write-only VMA
Date: Tue, 30 Apr 2024 12:39:04 +0200
Message-ID: <20240430103108.595885017@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiantao Shan <shanjiantao@loongson.cn>

commit efb44ff64c95340b06331fc48634b99efc9dd77c upstream.

As with most architectures, allow handling of read faults in VMAs that
have VM_WRITE but without VM_READ (WRITE implies READ).

Otherwise, reading before writing a write-only memory will error while
reading after writing everything is fine.

BTW, move the VM_EXEC judgement before VM_READ/VM_WRITE to make logic a
little clearer.

Cc: stable@vger.kernel.org
Fixes: 09cfefb7fa70c3af01 ("LoongArch: Add memory management")
Signed-off-by: Jiantao Shan <shanjiantao@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -202,10 +202,10 @@ good_area:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 	} else {
-		if (!(vma->vm_flags & VM_READ) && address != exception_era(regs))
-			goto bad_area;
 		if (!(vma->vm_flags & VM_EXEC) && address == exception_era(regs))
 			goto bad_area;
+		if (!(vma->vm_flags & (VM_READ | VM_WRITE)) && address != exception_era(regs))
+			goto bad_area;
 	}
 
 	/*


