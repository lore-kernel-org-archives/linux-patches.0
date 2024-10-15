Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785031D0492;
	Tue, 15 Oct 2024 11:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993175; cv=none; b=Ue/WhKEsG5pOurT/6FIEgOun5xpepRYM10ouI2HPHkW/1iRKsDXfCjJOfGNyExABBEQWeOovMz0p+JfgKGe77ihDl3ulvehU4zZmyqf51vcYdrCjCTrckPKNr69NUiI0TClLWbip312tk4B2JVH5D1nKMTg7pqbglz5SB0sSTk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993175; c=relaxed/simple;
	bh=LPGduGZvHwmd9gmaLjt240qdz2KGzdHhrF9BsIhx7+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHYyeV3BkSU1wSODfLEVFVVmNJlQQcMuafZKRK7LD03FTwVjD1eJHlD+ltWYJCOVr2nCJniB4WS5S/UkoB1GXT8BQP+c8hDLYo1IFnUYTt8H3UlzKRNRbJk3DSoanjBDaGOd1QOP/OYWIo3fKhOl7vR8sOkoNWjQR09mYMPvZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spCL5a30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spCL5a30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E673FC4CEC6;
	Tue, 15 Oct 2024 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993175;
	bh=LPGduGZvHwmd9gmaLjt240qdz2KGzdHhrF9BsIhx7+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spCL5a30EGvcB1p2b89+GM6gh5VfrfKhsvMlX9vRAdo373vfwHL0iK6k7w3pLwhN+
	 joam7erRVTCdGZUSnKV7W9hbrzoDynfkTpT4jUVTKt1zyRTdCEUex+stNqLZUrFN2F
	 g+TekV9WlWxRLjk/11ztdnLiJoVBRATbpLPD9ao0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 333/691] efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption
Date: Tue, 15 Oct 2024 13:24:41 +0200
Message-ID: <20241015112453.551185757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 77d48d39e99170b528e4f2e9fc5d1d64cdedd386 upstream.

The TPM event log table is a Linux specific construct, where the data
produced by the GetEventLog() boot service is cached in memory, and
passed on to the OS using an EFI configuration table.

The use of EFI_LOADER_DATA here results in the region being left
unreserved in the E820 memory map constructed by the EFI stub, and this
is the memory description that is passed on to the incoming kernel by
kexec, which is therefore unaware that the region should be reserved.

Even though the utility of the TPM2 event log after a kexec is
questionable, any corruption might send the parsing code off into the
weeds and crash the kernel. So let's use EFI_ACPI_RECLAIM_MEMORY
instead, which is always treated as reserved by the E820 conversion
logic.

Cc: <stable@vger.kernel.org>
Reported-by: Breno Leitao <leitao@debian.org>
Tested-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -115,7 +115,7 @@ void efi_retrieve_tpm2_eventlog(void)
 	}
 
 	/* Allocate space for the logs and copy them. */
-	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
 			     sizeof(*log_tbl) + log_size, (void **)&log_tbl);
 
 	if (status != EFI_SUCCESS) {


