Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92C19754F;
	Thu,  6 Jun 2024 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683761; cv=none; b=FPEQTlEjQmf/ipxtK+/2xzFzsmYqsrW5n0KXAqLmCKjyrFbNJhXyZmsq7RY97f5lIJxWMfDCbyokfGZDZnSL3PXgndW74FnnP6WeS9fmw9P4fAiqG/gVWqLfhPTPnXTr1Lu6xRA2VLZi1yQUEqpyp71nlt+8ssiExK4QL7/JTlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683761; c=relaxed/simple;
	bh=aT/5XW+dU3bwFJ2HwIbQHBklHYJ3KRCtNO5KLBr7FRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlKy8NgCzdh9jxRZ9CQwSBl/n30NlIQI08Xh2+kh6QsIA+og26uaFXRarrLg6sqsM1w/9BeIaVtPLiS52jfobESGJPiLq2sZlL+Lcsvkn+HAvYAv01C6QW0DrxL5VmLWe6qKzAQ7e5p64d0HCEVGQA55be6++nYrlUEIFwKO4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HclHUOE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HclHUOE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA57C2BD10;
	Thu,  6 Jun 2024 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683761;
	bh=aT/5XW+dU3bwFJ2HwIbQHBklHYJ3KRCtNO5KLBr7FRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HclHUOE8lun8f2nnNKk2R6sEvXWB6OSuodu5hJGmZJjAcwYt9go1Oio5SVS9jf+Qd
	 LRzvaplGILmgGC2GFHsMaGvMhqUtgKCH2OZVzsQPRFqgU767Hcdvby2ziSz+8sAp1C
	 edtCatefaTjr6yEdrTWFJf9chbxZpjGI8uQNhuCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 739/744] efi: libstub: only free priv.runtime_map when allocated
Date: Thu,  6 Jun 2024 16:06:51 +0200
Message-ID: <20240606131756.172093402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Hagar Hemdan <hagarhem@amazon.com>

commit 4b2543f7e1e6b91cfc8dd1696e3cdf01c3ac8974 upstream.

priv.runtime_map is only allocated when efi_novamap is not set.
Otherwise, it is an uninitialized value.  In the error path, it is freed
unconditionally.  Avoid passing an uninitialized value to free_pool.
Free priv.runtime_map only when it was allocated.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: f80d26043af9 ("efi: libstub: avoid efi_get_memory_map() for allocating the virt map")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/fdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -335,8 +335,8 @@ fail_free_new_fdt:
 
 fail:
 	efi_free(fdt_size, fdt_addr);
-
-	efi_bs_call(free_pool, priv.runtime_map);
+	if (!efi_novamap)
+		efi_bs_call(free_pool, priv.runtime_map);
 
 	return EFI_LOAD_ERROR;
 }


