Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7353279356;
	Tue,  8 Apr 2025 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116918; cv=none; b=bmJmCuP6XaFf4XZVAiGCzpcx7T/118BvbxeUp8PIT1H9D0LcT6TYWJ2mUBA7I7FozvMQc+ByeKuB3DIcAYE+MYPVH6ehYu7WQFQVWUI6ykTa8wAMNgOIo7mxVQ2OeHovDb7L6W9lA7shlsk5msS6wj+aX2WGU6rhFXGh5hd4pws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116918; c=relaxed/simple;
	bh=M4CacRGIuS0Sail1FwZMbdzvi+qYy80DoKVmZX8bT3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOfbjXgwN8pc7ou+3FkE8C6qOh5d5JsmM0BobXMqerifAh8XSecFz88p5mteQpKlW6U6EdXWJ4ugLgbeoyHnvTaf4mm+5QzDaddVB6oHxdFc+wyMGkcFL1oW3CRZ3am5gQ9N3ggTOKQNblrt5asFYUx1sohxe/p0ss3jmaLUvr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBfLDw7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBfLDw7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD102C4CEE5;
	Tue,  8 Apr 2025 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116918;
	bh=M4CacRGIuS0Sail1FwZMbdzvi+qYy80DoKVmZX8bT3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBfLDw7ijVI4lf590DLs4b+BzqbjQrlbo9NiXBuFOkYGLj3aFYgbPOt48Dr5nmeEJ
	 eji2v8hJJvEVz5IS5jvtpPnDCAn7Ea5DQB886EdorFYODlUnG+iFo6vn1yIwf/0Z0S
	 tQSsCT42iq/AAqT62V/27kLDTh686v62df9WdAIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/423] riscv/purgatory: 4B align purgatory_start
Date: Tue,  8 Apr 2025 12:50:44 +0200
Message-ID: <20250408104853.220882145@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



