Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B3C61675;
	Mon,  4 Mar 2024 21:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589090; cv=none; b=tuBHxFG/QmHMoHgDT8Zz0H6lnLNgsfYHyP0H0M9I5Sm9MhyN/QAQJWylkn67pJSie9fkMQg5VEo9zNydb9NLnGqXZwM2svzN9vvZ2AwCHBY5kWFYrng/EUhp0T6RaDEKr+fbr+WAAu1o0mcCP7lFa0Wc+Nd4s12vL4O5PTQ6fHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589090; c=relaxed/simple;
	bh=sep1mjrHE4VYo88KVSKq6gK6NYpgEKsKO6GMYRvQBus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWi+WzeRHOHlYYR3z9HUXrpe2srPFMq7rLfKPvJl4jmCXyRZToZhvSGjCd2ZcUstZaXJtmZQeritetn8Nmm9YqlbF+y65Tt8ea7cj3yQbJ9EqQKa5fnDTxuhQuCdutBFZ6NN7CDIVHCtrtB8279yiccTiMFhbTQYohR4jxeH7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzHl0I8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzHl0I8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8385FC433F1;
	Mon,  4 Mar 2024 21:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589089;
	bh=sep1mjrHE4VYo88KVSKq6gK6NYpgEKsKO6GMYRvQBus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzHl0I8gP9tX8qKc9/vCP695Zc5wpxbE3Uq0x03mZSs/vilAmjgMUxXn6beoG29Xi
	 E2+6N2kFmu5d595Wem3BBO9FJ+fw57QpXs8pyGVJJsm+VfPcO+GhVsq+5AGqiOzDRF
	 wOXsD8mk5ZnZ34xSCxuP8eo2sopBNjTpa5Pcy5Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 196/215] efi/x86: Fix the missing KASLR_FLAG bit in boot_params->hdr.loadflags
Date: Mon,  4 Mar 2024 21:24:19 +0000
Message-ID: <20240304211603.187843163@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb+git@google.com>

From: Yuntao Wang <ytcoode@gmail.com>

[ Commit 01638431c465741e071ab34acf3bef3c2570f878 upstream ]

When KASLR is enabled, the KASLR_FLAG bit in boot_params->hdr.loadflags
should be set to 1 to propagate KASLR status from compressed kernel to
kernel, just as the choose_random_location() function does.

Currently, when the kernel is booted via the EFI stub, the KASLR_FLAG
bit in boot_params->hdr.loadflags is not set, even though it should be.
This causes some functions, such as kernel_randomize_memory(), not to
execute as expected. Fix it.

Fixes: a1b87d54f4e4 ("x86/efistub: Avoid legacy decompressor when doing EFI boot")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
[ardb: drop 'else' branch clearing KASLR_FLAG]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -781,6 +781,8 @@ static efi_status_t efi_decompress_kerne
 			efi_debug("AMI firmware v2.0 or older detected - disabling physical KASLR\n");
 			seed[0] = 0;
 		}
+
+		boot_params_ptr->hdr.loadflags |= KASLR_FLAG;
 	}
 
 	status = efi_random_alloc(alloc_size, CONFIG_PHYSICAL_ALIGN, &addr,


