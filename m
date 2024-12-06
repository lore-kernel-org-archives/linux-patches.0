Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC04B53A7;
	Fri,  6 Dec 2024 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498696; cv=none; b=q3SxhEE2Z3817f6Ju2AFnwJ9U+t2BUSa4/vk/Z40BSODMACw3ZgK1fZqvDexJnBMg9XzVR5zfyIobgZZEqPrrBbOkfEVcWwkfiMovR6veuLHqb4SVCqsSC2SAKiCukpX5wmq6cXLXVhA+XGLPik5k6oyXn5WP7ubRmI2kr1r3l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498696; c=relaxed/simple;
	bh=wnkMSZRnFJlpNZMXIlJD5n/GD8y8yF5quRT8b4M8Tfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfMKmBpADchVrVzAdZQadMxSelnrA7KaaQdU8bFLNDf7h9qi2Riub+XAF5BQ8798V/zKro3IeEs6rbw0GZf0TZYQXKkr3efQRxOik/Kx1jKz5sQpTR3e3ttkal4X+qZRD8f+lTHGadidzhsw2aQKZrGDtLrLUY4pv2PT8pAbrA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oywI6H+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oywI6H+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56884C4CED1;
	Fri,  6 Dec 2024 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498695;
	bh=wnkMSZRnFJlpNZMXIlJD5n/GD8y8yF5quRT8b4M8Tfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oywI6H+sXI8XNkXt0U+tVtsr9BCNvEYkpJ5i2rSzdou1rL5rcmDcAak6bvRSvxq3U
	 i553atzktTrHMdwFKaBjxuyEATmKRdYXgkg+ApINbkXVYS2WSeOTnD+MGSsdPnnzA4
	 IMYDrdsXogCXChNRvSFZ+wwLWD6SdzJeE+2DBzTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 619/676] efi/libstub: Free correct pointer on failure
Date: Fri,  6 Dec 2024 15:37:18 +0100
Message-ID: <20241206143717.547887216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


