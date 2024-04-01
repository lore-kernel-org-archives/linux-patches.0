Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CC7BA3F;
	Mon,  1 Apr 2024 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990312; cv=none; b=kAoN5wCyCbUTufXEpL3w0rZOdQfMiwp79zT8D1ugQHdG3hStG7GfTixkITkUkLZ7Wm68ellW6vcFvRKgttZ48YyTUNL/3Ua2jI/KxPELchT/kNZaxK4h9lpObLFH65iLrOEIl3HbORpN5l5S58QtNg1+J3uOKNxlfhACkPf11/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990312; c=relaxed/simple;
	bh=1QqeqdUEGyMz0PIgoOEiKADH2M3WelzxBycWF7D1upk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK+GmKV7yq6wpO0JQT/js+IhJ9mi8/mq6iBKpuja5Eljnhf41NZZlt9wf+t2Owmt+8IxOo3oaPQVIOZAiLYSAhUfqyrfSFhay7gplDdDk/Ruez63jc4QS7jY+E+iPtiP+22wh8Q/QjTdoUuSkV/1XyMn0sYJBjs0yjluDc1vRTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJjnEE7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJjnEE7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAAEC433F1;
	Mon,  1 Apr 2024 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990312;
	bh=1QqeqdUEGyMz0PIgoOEiKADH2M3WelzxBycWF7D1upk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJjnEE7OXrAt0yrhiC7VSShfJKf49aa5gzaBnGNqx72W0lhlC6utIHyieoaEA6z49
	 kMMFBXGymUQ7OHwAHzXqMXD65aOc2WT0abAXZpeNbkRzd3hDmuuKHDyDtASl+22r1t
	 ll2AwROA4eZbisv3/xUaw/eencPJHMKVySGzNUOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 313/396] x86/efistub: Reinstate soft limit for initrd loading
Date: Mon,  1 Apr 2024 17:46:02 +0200
Message-ID: <20240401152557.244411386@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

commit decd347c2a75d32984beb8807d470b763a53b542 upstream.

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
@@ -487,6 +487,7 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 	hdr->vid_mode	= 0xffff;
 
 	hdr->type_of_loader = 0x21;
+	hdr->initrd_addr_max = INT_MAX;
 
 	/* Convert unicode cmdline to ascii */
 	cmdline_ptr = efi_convert_cmdline(image, &options_size);


