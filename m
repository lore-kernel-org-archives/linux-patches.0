Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1C91D0B8C;
	Wed,  2 Oct 2024 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880410; cv=none; b=BJrXXsp8HTl1P+s+eX7I3wsoNHv4W5tvhofk2RboqgYNDIH019ZkMcQZkgjyWbmLyBXnqXxyrdnyLkKiAHR3+lQ7IcpfPPblxk8XhLE54RLMD5PqsF8N0RCDdppBcoQN9f5MBkF6J7SVoBh7yGNTFozYuuXNSXYAEEGfR212NOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880410; c=relaxed/simple;
	bh=wN61Zv6wNqkHEe/xZiDUNPcybQigv2OHVLQko/VquJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foAiSZkNWGutVCzo+52d4U4PY90Q+V6eRF0yPxJFOvNmckFhMXNFFaClcGQtIqOdkFRtjgZlHeKQ7h2YBsC2puv0lGBTJYNJufyUdCOqp6GQbbxXQn/RquFNnkQzIw3I2lmU0mr+ExOl9uuoTgPdVU3C3ikGOJzQTpXS4NS8P2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O2VdDpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O2VdDpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DF8C4CEC2;
	Wed,  2 Oct 2024 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880410;
	bh=wN61Zv6wNqkHEe/xZiDUNPcybQigv2OHVLQko/VquJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O2VdDpB7PNoL9gptW4gk/pZI5Dq9t43B5+OywAmjniGTJj1DN+UZrc3JaidvNuuE
	 ufgGJoQYxJJofh+aZLpxfXePKwUTsO5mWicgLSe6GMJd+xNwz7MUe8xkHFmrnF0otv
	 dYAgr/AKAPhbuzhdV/8Z4z2T7D4BefQQ6XRv7W/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 450/538] efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption
Date: Wed,  2 Oct 2024 15:01:29 +0200
Message-ID: <20241002125810.204256876@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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


