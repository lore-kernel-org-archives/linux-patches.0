Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D95F1C07FF;
	Tue, 15 Oct 2024 13:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997676; cv=none; b=b83ajEtQCTvx2htv+x9LjFvGWAqhYUPSHZMG0p1GjmVhsfq0Dhbzk2aF9kIsqzxGSCv+FuMW8psFZ6qK6/XKBnzPzCOrhTwvPLk5LuIP8FdA2CKMrVTObj5X0e03JbjfS+aqcqkg6imiE4kvlUh58gwXEn/5ZFOyR6tPc4LCfbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997676; c=relaxed/simple;
	bh=PpPZTqiOC8EdXlVomEfOuXedlfAERmUwdyOOq3iKVIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtruO6Qtva41Xoe74/8efHHwps7hQede1ujK0YqEZjQAeMH6pVtIRHleKcMtL94gwxyzci8el1/iOd9j4qvROzz5ysk1qoTRneboZKfjY6oSnpnzGQA3veKwTPnVf23Rmz4+Nvew5ikmnOHWFiqiyMjClLirO5wliq7oWL3rpHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9hdFXfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9hdFXfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3EAC4CEC6;
	Tue, 15 Oct 2024 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997676;
	bh=PpPZTqiOC8EdXlVomEfOuXedlfAERmUwdyOOq3iKVIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9hdFXfkAx3Cx3IH2FUoyAh4MComftZMsOXvo3tLRTqvOVX8bxJ9EX+0vm6cJ28iT
	 036CAmWAisQPjKanml/dIvPJ/9oXuqfxzDjztCfJrjQIw+zBpgPOpZls73Arup06hP
	 KAWtH/jIdTtaSrP009LX5UAJNEXbuRSQqbA6jgLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 235/518] efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption
Date: Tue, 15 Oct 2024 14:42:19 +0200
Message-ID: <20241015123926.063814025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


