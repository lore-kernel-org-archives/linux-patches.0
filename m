Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE0B143C45;
	Tue, 23 Apr 2024 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908673; cv=none; b=t5n7xWDxA769XNJ2LremIlusZqJSGG2xH/eTX2BPAOybev+lPcB0upy+BPWlP356GWrmj7+4QBgXHmjStxeRaIMcNoZRjtGGVK0EKwe6fLlA/vKrs6C4jJFXKrMzJALRiZC0m91iHd6ZxWApPm34+3IUz3SnEE4hSPbZVziy4t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908673; c=relaxed/simple;
	bh=+PppuDcipJEgWLibt0U0o299CoYqGOh6oJYq7gKhKM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvoi+Mr3zL6tVupz7rykyXKk8W1/SI6BibnaE7YZxTqkhGtqdS7ytchB0lvr9h3T1UhkjsI+UZpQ4hemHK9Ta9fPiMgmKUthza2bNEyblCmpQamH7ZQA3dw+IYgwxT+guaaORTIpa7aPfm6STb8QIOcqFm/kFNo/chk0znqzdUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5ZCmqdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5ZCmqdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301BCC32781;
	Tue, 23 Apr 2024 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908673;
	bh=+PppuDcipJEgWLibt0U0o299CoYqGOh6oJYq7gKhKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5ZCmqdlsKwEuYUdUF1/Hh4qnCmSoZd4vzcScYisp/93AUUuK2IV0CyJ7SGCwt0rk
	 X83a/CFAwQARcT5Hb3ygYou4LLHCZcGKCyRrtOd9GcgkejJGYnH08Z5cq8FBZ3BV3B
	 Ir3Xwxk8+wHaesiGF0FEnxjeXULwZija2DUvtsS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 013/141] x86/efistub: Reinstate soft limit for initrd loading
Date: Tue, 23 Apr 2024 14:38:01 -0700
Message-ID: <20240423213853.779168760@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit decd347c2a75d32984beb8807d470b763a53b542 upstream ]

Commit

  8117961d98fb2 ("x86/efi: Disregard setup header of loaded image")

dropped the memcopy of the image's setup header into the boot_params
struct provided to the core kernel, on the basis that EFI boot does not
need it and should rely only on a single protocol to interface with the
boot chain. It is also a prerequisite for being able to increase the
section alignment to 4k, which is needed to enable memory protections
when running in the boot services.

So only the setup_header fields that matter to the core kernel are
populated explicitly, and everything else is ignored. One thing was
overlooked, though: the initrd_addr_max field in the setup_header is not
used by the core kernel, but it is used by the EFI stub itself when it
loads the initrd, where its default value of INT_MAX is used as the soft
limit for memory allocation.

This means that, in the old situation, the initrd was virtually always
loaded in the lower 2G of memory, but now, due to initrd_addr_max being
0x0, the initrd may end up anywhere in memory. This should not be an
issue principle, as most systems can deal with this fine. However, it
does appear to tickle some problems in older UEFI implementations, where
the memory ends up being corrupted, resulting in errors when unpacking
the initramfs.

So set the initrd_addr_max field to INT_MAX like it was before.

Fixes: 8117961d98fb2 ("x86/efi: Disregard setup header of loaded image")
Reported-by: Radek Podgorny <radek@podgorny.cz>
Closes: https://lore.kernel.org/all/a99a831a-8ad5-4cb0-bff9-be637311f771@podgorny.cz
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -453,6 +453,7 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 	hdr->vid_mode	= 0xffff;
 
 	hdr->type_of_loader = 0x21;
+	hdr->initrd_addr_max = INT_MAX;
 
 	/* Convert unicode cmdline to ascii */
 	cmdline_ptr = efi_convert_cmdline(image, &options_size);


