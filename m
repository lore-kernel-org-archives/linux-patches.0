Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8843D26A1B1;
	Tue,  8 Apr 2025 12:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115177; cv=none; b=YcunbWLWbWFcbvmoW1rPl6SMKV2JQrkFtSZ9icdKBNEir2q7Xox0OXftn69uN4jIJd1FwkyPNW4hrdKRD/+T+J8xs/2YAqJkHdzC2jZq5v39EuVrW6wETDJlkJqA8G2MMPQ4DHykUmy38z9xPc/iiPWsMR4nLTwE8Vlx8yGD4lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115177; c=relaxed/simple;
	bh=2gmhhuACRX1szOUT4+RpLbNPHYHl3PYWwT66Y63JCW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYASXktDJ/qzG5gR1zWIlCHsgRjFqgjle83UNCUUINOdRPRPJNMqwkl11wOhK8cmF9QW/vkoBPWrzQFifTha/RI4/wd734jWInQUgDhLwPPxgHOpadHUKsITRQGmaWYD3HgF+sLn8JETr8ZjuF3JMwHCD66POC6YgTbJ3xbdtuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER4qU9h8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER4qU9h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E85C4CEE5;
	Tue,  8 Apr 2025 12:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115177;
	bh=2gmhhuACRX1szOUT4+RpLbNPHYHl3PYWwT66Y63JCW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER4qU9h8R3ha2FtK4iRPl9DfcuHqYZzLM24+92uQcPBzRTwV3D2LZb1Dv9Uq+OT5z
	 fIFTlSCKJN7Qtq5TanhpmgpOK7+WT20eE+zDdeP7Zm6M6ULVV1HauSf9l0MIgFcAl5
	 ORhVXA5epsPShxdrAlsFo7PWKn5FnmG6BBIANrNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 376/499] riscv/purgatory: 4B align purgatory_start
Date: Tue,  8 Apr 2025 12:49:48 +0200
Message-ID: <20250408104900.607716625@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 3f7023171df43641a8a8a1c9a12124501e589010 ]

When a crashkernel is launched on RISC-V, the entry to purgatory is
done by trapping via the stvec CSR. From riscv_kexec_norelocate():

  |  ...
  |  /*
  |   * Switch to physical addressing
  |   * This will also trigger a jump to CSR_STVEC
  |   * which in this case is the address of the new
  |   * kernel.
  |   */
  |  csrw    CSR_STVEC, a2
  |  csrw    CSR_SATP, zero

stvec requires that the address is 4B aligned, which was not the case,
e.g.:

  | Loaded purgatory at 0xffffc000
  | kexec_file: kexec_file_load: type:1, start:0xffffd232 head:0x4 flags:0x6

The address 0xffffd232 not 4B aligned.

Correct by adding proper function alignment.

With this change, crashkernels loaded with kexec-file will be able to
properly enter the purgatory.

Fixes: 736e30af583fb ("RISC-V: Add purgatory")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250328085313.1193815-1-bjorn@kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/purgatory/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/purgatory/entry.S b/arch/riscv/purgatory/entry.S
index 0e6ca6d5ae4b4..c5db2f072c341 100644
--- a/arch/riscv/purgatory/entry.S
+++ b/arch/riscv/purgatory/entry.S
@@ -12,6 +12,7 @@
 
 .text
 
+.align	2
 SYM_CODE_START(purgatory_start)
 
 	lla	sp, .Lstack
-- 
2.39.5



