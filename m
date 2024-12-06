Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC6E14A4D1;
	Fri,  6 Dec 2024 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496029; cv=none; b=neZ/Qo+Bd1nsqM8jyybPLYiRYPrEApsBNdm/5obCorWjVHNSU4+NKpTzNMim6KHqGAef8eVWxreeY+UfgYXqk2kQvM9OwSejq7VNJw/5cGyPUcXQqcoON7ckJzHmIfYVR0059dmilrUoT+HHfhhkcadHY6YbL4Fp0J3c5WRmzRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496029; c=relaxed/simple;
	bh=UNho+dIgTbnh1EB/YaQay4umhd/AeSuFw+x1cqCItuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFBi50S09V9scVSMyfE5Ia4bIfggaqaEcr6Pi+hm0JcbfdUGkAJktkfu/cEt0V3y0fZwZFVW87D3IRSTPerBPiZXsI39SNwRBfD/npQcxD3vZjoBWyguPT2so39wraAJ9YszeHdteEGQyczmbYIIJbaRhVNOccRfuMP9rehPB5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkTrkDmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkTrkDmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49412C4CEDC;
	Fri,  6 Dec 2024 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496027;
	bh=UNho+dIgTbnh1EB/YaQay4umhd/AeSuFw+x1cqCItuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkTrkDmJMnLPdutwL6c8V0vQWEtSe05CPu97IJZq0Z6RIeBCjSV5TEEZUwg/ux96W
	 aAwEUj4aPcMRSEQk2etNMC+UH4qFs9L95lVG6Au13Dz79gfiLWTZL0BAWTfjlSvQA/
	 +xMjQ5idaltXS7j8MmfC0qNpKsRpinMt04+oOwFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12 031/146] efi/libstub: Free correct pointer on failure
Date: Fri,  6 Dec 2024 15:36:02 +0100
Message-ID: <20241206143528.863342002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 06d39d79cbd5a91a33707951ebf2512d0e759847 upstream.

cmdline_ptr is an out parameter, which is not allocated by the function
itself, and likely points into the caller's stack.

cmdline refers to the pool allocation that should be freed when cleaning
up after a failure, so pass this instead to free_pool().

Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint ...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/efi-stub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -149,7 +149,7 @@ efi_status_t efi_handle_cmdline(efi_load
 	return EFI_SUCCESS;
 
 fail_free_cmdline:
-	efi_bs_call(free_pool, cmdline_ptr);
+	efi_bs_call(free_pool, cmdline);
 	return status;
 }
 


