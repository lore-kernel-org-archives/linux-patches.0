Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3958233DF;
	Tue, 25 Mar 2025 12:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905819; cv=none; b=BqsgcSqqEv+lz0soiBVEYZOFq0+eqPSxibTii9yl6qqa1t+ybPpt1F7+LYMl7clIleYLXpG1cDrVYmRMHlEoDuRaq0q8si6RugjhASdUVMkT/F4NQDy7iOVp+OfMJlebiw2iiFL3S5L7TNvZrxgWIabqzl9XKrGJ+YAoq8fwhCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905819; c=relaxed/simple;
	bh=akUwQ5q4vYJmLRygt3JfEh/D3HNNWERDkUUYRPrxY/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn2Rm1PoeIuu+XzV4lz3ptz9ULD4dUrzAJMvV+3uC/ZIM3VIbvqqytL+c5NYTdzCuxVrmGA52Tlxg3yub+mgXPop/Nr1IPptm67OqVj2kAyrq64pR+wC4MUTN4D41i1S8ACiB8y2VUMh8psudih+eCSE/tK5iDgHDFCFIafE70Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrxvzvSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrxvzvSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76025C4CEE4;
	Tue, 25 Mar 2025 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905818;
	bh=akUwQ5q4vYJmLRygt3JfEh/D3HNNWERDkUUYRPrxY/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrxvzvSfTDZdFLJowHvDeg3Lj1x8t+0lwM+Bual+WkYKoYm5olys0scmZVaFkor5e
	 459QNroQrWXgwLVZNUsBa6mjJ1DmKyX7/5zb3yFR3U42OvHZVgwYANn+DZJZZOQrCI
	 hI6UEHH9Sfvte/LJSmwmGJh6hkMjux1gRu4xVLL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Schneider <ben@bens.haus>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 181/198] efi/libstub: Avoid physical address 0x0 when doing random allocation
Date: Tue, 25 Mar 2025 08:22:23 -0400
Message-ID: <20250325122201.396787634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit cb16dfed0093217a68c0faa9394fa5823927e04c upstream.

Ben reports spurious EFI zboot failures on a system where physical RAM
starts at 0x0. When doing random memory allocation from the EFI stub on
such a platform, a random seed of 0x0 (which means no entropy source is
available) will result in the allocation to be placed at address 0x0 if
sufficient space is available.

When this allocation is subsequently passed on to the decompression
code, the 0x0 address is mistaken for NULL and the code complains and
gives up.

So avoid address 0x0 when doing random allocation, and set the minimum
address to the minimum alignment.

Cc: <stable@vger.kernel.org>
Reported-by: Ben Schneider <ben@bens.haus>
Tested-by: Ben Schneider <ben@bens.haus>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/randomalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -75,6 +75,10 @@ efi_status_t efi_random_alloc(unsigned l
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
+	/* Avoid address 0x0, as it can be mistaken for NULL */
+	if (alloc_min == 0)
+		alloc_min = align;
+
 	size = round_up(size, EFI_ALLOC_ALIGN);
 
 	/* count the suitable slots in each memory map entry */


