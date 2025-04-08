Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B87F268C79;
	Tue,  8 Apr 2025 11:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112088; cv=none; b=tfacUpRE5KvuYdjF2gjvLIKi8zwIxeGLGhHZtu6G6IyD67OtBrlOavQGZSOGVCpPYMetX2eHFSYYFhYG0SouWlGhGp2QO8uFPqxUfH/r/mUbJIIHEiVaHhMB2goKpbWAKgcSUzzmXol/ISzBOdDRkmYvX50iob+9FXWXEU+DoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112088; c=relaxed/simple;
	bh=YQ4KBjMYuEIHhNRHs5Vgt2zzn7eXwF2igHJZhsyhruU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXqcVEdVHmUlZnQ8vjjbcAiQXHJL6H05V0acJGM0w52+NcX0vw988Pcg0VFal4tzJKs+aYmPrpWm1u2TgmNM5whmEISamiWAEEvKssEmmXjDkJTn+WaYu7tLz99v7zPqpNH8h8W7WJTuWEgAsmEIWi0L08YvOlLWL0MP6AlYHjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj76h1FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj76h1FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B5C4CEE5;
	Tue,  8 Apr 2025 11:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112088;
	bh=YQ4KBjMYuEIHhNRHs5Vgt2zzn7eXwF2igHJZhsyhruU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kj76h1FMxq/YkwSkjxnwWwxjNwUC75uwHa+AHrEB0VmTz1TDXuuCWzNWjln/ZMzj7
	 HBZQKrEcAERHIWe2H55pOXGyQ6EdzEbMiY/JTYaNKUD3MHmEbZ5OpddAaI972rEpBD
	 712hSZjNOY+Ej8krTCPZOf4shpCmB14B9Ueop+X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.14 670/731] x86/microcode/AMD: Fix __apply_microcode_amd()s return value
Date: Tue,  8 Apr 2025 12:49:27 +0200
Message-ID: <20250408104929.851350688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 31ab12df723543047c3fc19cb8f8c4498ec6267f upstream.

When verify_sha256_digest() fails, __apply_microcode_amd() should propagate
the failure by returning false (and not -1 which is promoted to true).

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250327230503.1850368-2-boris.ostrovsky@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -600,7 +600,7 @@ static bool __apply_microcode_amd(struct
 	unsigned long p_addr = (unsigned long)&mc->hdr.data_code;
 
 	if (!verify_sha256_digest(mc->hdr.patch_id, *cur_rev, (const u8 *)p_addr, psize))
-		return -1;
+		return false;
 
 	native_wrmsrl(MSR_AMD64_PATCH_LOADER, p_addr);
 


