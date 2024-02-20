Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCEE14A4E6;
	Tue, 20 Feb 2024 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464330; cv=none; b=sNs7APXynOf+Czig2NLPMaZst7OsbADgCsCAzY1jaG6pQSYem2gmiLLl17jZHjWwLqgzCi897BWx26TQ8H0Qjdz/JrQZYu+9zEjCmhWSiEcMLmnB8oLBlT3UND1QP/+QUMBtDo8oSsGtW7tMazuqQA2bUM7h+4GNr9CV5mQdrbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464330; c=relaxed/simple;
	bh=nWc1q1HAfz6Mw4lIHfOM8N28czq3n+2FxUkEuYVv0Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLsdmDk8Nhn0imNu5NIapPI+9v44iDrRRGFsTb00RzBMZFeM8UIoIJVs3hAe/7S0NK+ZwyUx3BackkIs2fZ85CrTRe/aFM0VgObAz/ES5SZccuwpQB27SID5m1W4k5xcABQLURh1mxnjuhVcAiKaSS6iOS/aMBSvfqZzHjumpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCqGIume; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCqGIume"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836E7C433F1;
	Tue, 20 Feb 2024 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464330;
	bh=nWc1q1HAfz6Mw4lIHfOM8N28czq3n+2FxUkEuYVv0Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCqGIumeAz6RFwNAW+GSgkYJu7DWP88pv/SbB9I8A5YoW0kb3g1CoOUyw6zxp+OWT
	 TZB8xsnHqAUEvuRliQH0yEQs5rXBYHcdSThhkrROtDr6WZwYr3a9GkdfGSq8GK5zfv
	 KvKh+l4fyog5U9fZfzOwRd//onGQWt7r7kiAG1c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 323/331] x86/boot: Grab kernel_info offset from zoffset header directly
Date: Tue, 20 Feb 2024 21:57:19 +0100
Message-ID: <20240220205648.371352251@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

commit 2e765c02dcbfc2a8a4527c621a84b9502f6b9bd2 upstream.

Instead of parsing zoffset.h and poking the kernel_info offset value
into the header from the build tool, just grab the value directly in the
asm file that describes this header.

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-11-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |    2 +-
 arch/x86/boot/tools/build.c |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -526,7 +526,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
 
 init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0			# Filled in by build.c
-kernel_info_offset:	.long 0			# Filled in by build.c
+kernel_info_offset:	.long ZO_kernel_info
 
 # End of setup header #####################################################
 
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -59,7 +59,6 @@ static unsigned long efi32_stub_entry;
 static unsigned long efi64_stub_entry;
 static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
-static unsigned long kernel_info;
 static unsigned long _end;
 
 /*----------------------------------------------------------------------*/
@@ -337,7 +336,6 @@ static void parse_zoffset(char *fname)
 		PARSE_ZOFS(p, efi64_stub_entry);
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, efi32_pe_entry);
-		PARSE_ZOFS(p, kernel_info);
 		PARSE_ZOFS(p, _end);
 
 		p = strchr(p, '\n');
@@ -419,8 +417,6 @@ int main(int argc, char ** argv)
 	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
 
 	efi_stub_entry_update();
-	/* Update kernel_info offset. */
-	put_unaligned_le32(kernel_info, &buf[0x268]);
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, dest) != i)


