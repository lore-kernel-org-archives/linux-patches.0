Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB341465A8;
	Tue, 25 Jun 2024 09:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309479; cv=none; b=OGKyUWEM2j4fkhmSFjOfIpCHTC5cAzzlY6dCdhGavQigLdEgPZ0CXkLjg768htVATcOG3x8HgHaoYsyVZIYxoGMnWRh/sL9ZU/EKGKPOne0WBiGlUHPvrX1joO+PP7OS6DMsQe4rGeim9Fh/U6cI5HgCG7DDPApD1kQyUPbmUgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309479; c=relaxed/simple;
	bh=TWt1NBK8veNTa5sKXwjeSGl/R30/xzFShdXk7OBUBiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tx3q13D87plsQ3LKoQNSyQZaY1kWOtaH845dVxmB362byI0DQbng0FfS4nBpu6DLsk1r1nhMA0MsGnRbs3J3vn4jEMRgpSWAso/0tT4KCgl5B90FRl4/+h5LFLPXxrbEcxXccdjFHcgWD4NlwU9Mi/jv7xv2rZ1k9vPel/TEyDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9M2UhxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9M2UhxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062D5C32781;
	Tue, 25 Jun 2024 09:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309479;
	bh=TWt1NBK8veNTa5sKXwjeSGl/R30/xzFShdXk7OBUBiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9M2UhxTEuW4nwOLo2ZBbYaFAzxBSDe38+K4u1SpvdlFZBsfOuHXeF6PTNiNYLGU7
	 8NbJ9acD9SKASLw0YIakV6YpgL+8qdBekxnCcuxegccFNVmOMmOl3IVG5o9kQLapR1
	 I3IznFSrK2b07t1Ree+YEIbJ6DY6jDVSVgwoNLbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/131] powerpc/pseries: Enforce hcall result buffer validity and size
Date: Tue, 25 Jun 2024 11:33:04 +0200
Message-ID: <20240625085527.057915450@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit ff2e185cf73df480ec69675936c4ee75a445c3e4 ]

plpar_hcall(), plpar_hcall9(), and related functions expect callers to
provide valid result buffers of certain minimum size. Currently this
is communicated only through comments in the code and the compiler has
no idea.

For example, if I write a bug like this:

  long retbuf[PLPAR_HCALL_BUFSIZE]; // should be PLPAR_HCALL9_BUFSIZE
  plpar_hcall9(H_ALLOCATE_VAS_WINDOW, retbuf, ...);

This compiles with no diagnostics emitted, but likely results in stack
corruption at runtime when plpar_hcall9() stores results past the end
of the array. (To be clear this is a contrived example and I have not
found a real instance yet.)

To make this class of error less likely, we can use explicitly-sized
array parameters instead of pointers in the declarations for the hcall
APIs. When compiled with -Warray-bounds[1], the code above now
provokes a diagnostic like this:

error: array argument is too small;
is of size 32, callee requires at least 72 [-Werror,-Warray-bounds]
   60 |                 plpar_hcall9(H_ALLOCATE_VAS_WINDOW, retbuf,
      |                 ^                                   ~~~~~~

[1] Enabled for LLVM builds but not GCC for now. See commit
    0da6e5fd6c37 ("gcc: disable '-Warray-bounds' for gcc-13 too") and
    related changes.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240408-pseries-hvcall-retbuf-v1-1-ebc73d7253cf@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hvcall.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 47bc10cdb70b5..a56ec2f124eae 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -493,7 +493,7 @@ long plpar_hcall_norets_notrace(unsigned long opcode, ...);
  * Used for all but the craziest of phyp interfaces (see plpar_hcall9)
  */
 #define PLPAR_HCALL_BUFSIZE 4
-long plpar_hcall(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall(unsigned long opcode, unsigned long retbuf[static PLPAR_HCALL_BUFSIZE], ...);
 
 /**
  * plpar_hcall_raw: - Make a hypervisor call without calculating hcall stats
@@ -507,7 +507,7 @@ long plpar_hcall(unsigned long opcode, unsigned long *retbuf, ...);
  * plpar_hcall, but plpar_hcall_raw works in real mode and does not
  * calculate hypervisor call statistics.
  */
-long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall_raw(unsigned long opcode, unsigned long retbuf[static PLPAR_HCALL_BUFSIZE], ...);
 
 /**
  * plpar_hcall9: - Make a pseries hypervisor call with up to 9 return arguments
@@ -518,8 +518,8 @@ long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
  * PLPAR_HCALL9_BUFSIZE to size the return argument buffer.
  */
 #define PLPAR_HCALL9_BUFSIZE 9
-long plpar_hcall9(unsigned long opcode, unsigned long *retbuf, ...);
-long plpar_hcall9_raw(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall9(unsigned long opcode, unsigned long retbuf[static PLPAR_HCALL9_BUFSIZE], ...);
+long plpar_hcall9_raw(unsigned long opcode, unsigned long retbuf[static PLPAR_HCALL9_BUFSIZE], ...);
 
 /* pseries hcall tracing */
 extern struct static_key hcall_tracepoint_key;
-- 
2.43.0



