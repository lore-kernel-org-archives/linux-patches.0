Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C366A147C96;
	Tue, 25 Jun 2024 09:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308927; cv=none; b=RF/1zQJPvdFe5FMVcOu/1ooVPcFwb7boCBYsDvSL7MqgyKOmnmI9i5V3O2AD5AFrVyt4PfTlKanGawJ88adPT36Ij2tJVYBovVlH95wQGS2geriYvyfdOEK6uYztKJt96QoeGScHKVc4Wfuer1DAfYmzfewcQyNySkbkXr8ja/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308927; c=relaxed/simple;
	bh=nqseI3AkVV/wMbAy/61UhAMDRn0BPb1Z+SpB+jVz7qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItmNvpRxHQCqb27eKx8d7I1/8GtHFJfSUu1Uqcklsl1uMB/51IVTczRjuBGWcy3YvXCkPl0kPunxbJyFgGM5TYYvU5XTkCAaCJv+BUXM0BH2KAIp0M4rrCWBDeQaiV8/Z8la6Gd1fAWl8k7xg7rPXvtBUPSyKWauRZFC1+CFEq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwNKh0Cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwNKh0Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FB9C32781;
	Tue, 25 Jun 2024 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308927;
	bh=nqseI3AkVV/wMbAy/61UhAMDRn0BPb1Z+SpB+jVz7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwNKh0CsbQ9wU8pI7PN51Cc7leMQXSFyVJkvEH+fWP16whZlIsjRoo4hPSJ9xAGs+
	 V+MxTSfbD8u7rh3qrBeWRFnn4yknbnpDTC/FfEc4mpJgvB8Gsj1ZLrLWRczhZgrbtQ
	 qZHeiwaO5og0/iOqqHlQ5WxyTWOYDLYFH/UfV+ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/192] powerpc/pseries: Enforce hcall result buffer validity and size
Date: Tue, 25 Jun 2024 11:31:48 +0200
Message-ID: <20240625085538.548592823@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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
index 92ea0fa17ff41..218488407ac00 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -494,7 +494,7 @@ long plpar_hcall_norets_notrace(unsigned long opcode, ...);
  * Used for all but the craziest of phyp interfaces (see plpar_hcall9)
  */
 #define PLPAR_HCALL_BUFSIZE 4
-long plpar_hcall(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall(unsigned long opcode, unsigned long retbuf[static PLPAR_HCALL_BUFSIZE], ...);
 
 /**
  * plpar_hcall_raw: - Make a hypervisor call without calculating hcall stats
@@ -508,7 +508,7 @@ long plpar_hcall(unsigned long opcode, unsigned long *retbuf, ...);
  * plpar_hcall, but plpar_hcall_raw works in real mode and does not
  * calculate hypervisor call statistics.
  */
-long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall_raw(unsigned long opcode, unsigned long retbuf[static PLPAR_HCALL_BUFSIZE], ...);
 
 /**
  * plpar_hcall9: - Make a pseries hypervisor call with up to 9 return arguments
@@ -519,8 +519,8 @@ long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
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



