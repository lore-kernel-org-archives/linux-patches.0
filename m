Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4600257448;
	Thu, 17 Apr 2025 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916001; cv=none; b=I+2Ij0vork7MZoLCCNRwQGO/QLdY0kVJfIeRPfCBryyS6ElPsgcb39Xvof1E0AH1827JYq3bCa04nriEgXXpIi4zEwg+g5EGLOZpOkOpt98uupr/+AVYBER7czAQX4g1fPSFf+V0gLEzTM0tsEs6oXliGnYet7Hz7R4LdbRntDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916001; c=relaxed/simple;
	bh=bbHRV3vb/c5es4r1GyW2u/TYeJ6+4MyMMlRIWn0pR8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT+bsNJvH6dMFgkJZuT1P3tGoxWrVSSZp8fZFeeOC+vQx+HOkjaQSooYZmabv58qXH2mXUg+UDiio/yZHu5/4aLfJ2hsNWxBmscJkkYNAxXQBHdVe4ghX4r8cPJmiZqiWU01ixV1HC7qgU55jbHZZFHFezUpgaSpJouj4bhefGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2cfF1aF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2cfF1aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9558C4CEE4;
	Thu, 17 Apr 2025 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916001;
	bh=bbHRV3vb/c5es4r1GyW2u/TYeJ6+4MyMMlRIWn0pR8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2cfF1aFWIk/gqIWXoCE+BdPfecSUzZNZs6NbhHUOO+GKhEhEcoo9B3FfmNg3+TQr
	 s/8LsoEEZ0N8WmqQreeVOTCgHW2QMvLrjwFTj4Q8rcLo6p0K/SVhk7181DIvA6N8LT
	 +tHwBtg//bFXaOz8lidKUgAEQnDV1PrX+WlOL5aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Tony Luck <tony.luck@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Betkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jane Chu <jane.chu@oracle.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 310/393] mm/hwpoison: do not send SIGBUS to processes with recovered clean pages
Date: Thu, 17 Apr 2025 19:51:59 +0200
Message-ID: <20250417175120.081534408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit aaf99ac2ceb7c974f758a635723eeaf48596388e upstream.

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

- Background: why *UN*corrected errors tied to *C*MCI in Intel platform [1]

Prior to Icelake memory controllers reported patrol scrub events that
detected a previously unseen uncorrected error in memory by signaling a
broadcast machine check with an SRAO (Software Recoverable Action
Optional) signature in the machine check bank.  This was overkill because
it's not an urgent problem that no core is on the verge of consuming that
bad data.  It's also found that multi SRAO UCE may cause nested MCE
interrupts and finally become an IERR.

Hence, Intel downgrades the machine check bank signature of patrol scrub
from SRAO to UCNA (Uncorrected, No Action required), and signal changed to
#CMCI.  Just to add to the confusion, Linux does take an action (in
uc_decode_notifier()) to try to offline the page despite the UC*NA*
signature name.

- Background: why #CMCI and #MCE race when poison is consuming in Intel platform [1]

Having decided that CMCI/UCNA is the best action for patrol scrub errors,
the memory controller uses it for reads too.  But the memory controller is
executing asynchronously from the core, and can't tell the difference
between a "real" read and a speculative read.  So it will do CMCI/UCNA if
an error is found in any read.

Thus:

1) Core is clever and thinks address A is needed soon, issues a speculative read.
2) Core finds it is going to use address A soon after sending the read request
3) The CMCI from the memory controller is in a race with MCE from the core
   that will soon try to retire the load from address A.

Quite often (because speculation has got better) the CMCI from the memory
controller is delivered before the core is committed to the instruction
reading address A, so the interrupt is taken, and Linux offlines the page
(marking it as poison).

- Why user process is killed for instr case

Commit 046545a661af ("mm/hwpoison: fix error page recovered but reported
"not recovered"") tries to fix noise message "Memory error not recovered"
and skips duplicate SIGBUSs due to the race.  But it also introduced a bug
that kill_accessing_process() return -EHWPOISON for instr case, as result,
kill_me_maybe() send a SIGBUS to user process.

If the CMCI wins that race, the page is marked poisoned when
uc_decode_notifier() calls memory_failure().  For dirty pages,
memory_failure() invokes try_to_unmap() with the TTU_HWPOISON flag,
converting the PTE to a hwpoison entry.  As a result,
kill_accessing_process():

- call walk_page_range() and return 1 regardless of whether
  try_to_unmap() succeeds or fails,
- call kill_proc() to make sure a SIGBUS is sent
- return -EHWPOISON to indicate that SIGBUS is already sent to the
  process and kill_me_maybe() doesn't have to send it again.

However, for clean pages, the TTU_HWPOISON flag is cleared, leaving the
PTE unchanged and not converted to a hwpoison entry.  Conversely, for
clean pages where PTE entries are not marked as hwpoison,
kill_accessing_process() returns -EFAULT, causing kill_me_maybe() to send
a SIGBUS.

Console log looks like this:

    Memory failure: 0x827ca68: corrupted page was clean: dropped without side effects
    Memory failure: 0x827ca68: recovery action for clean LRU page: Recovered
    Memory failure: 0x827ca68: already hardware poisoned
    mce: Memory error not recovered

To fix it, return 0 for "corrupted page was clean", preventing an
unnecessary SIGBUS to user process.

[1] https://lore.kernel.org/lkml/20250217063335.22257-1-xueshuai@linux.alibaba.com/T/#mba94f1305b3009dd340ce4114d3221fe810d1871
Link: https://lkml.kernel.org/r/20250312112852.82415-3-xueshuai@linux.alibaba.com
Fixes: 046545a661af ("mm/hwpoison: fix error page recovered but reported "not recovered"")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -879,12 +879,17 @@ static int kill_accessing_process(struct
 	mmap_read_lock(p->mm);
 	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwpoison_walk_ops,
 			      (void *)&priv);
+	/*
+	 * ret = 1 when CMCI wins, regardless of whether try_to_unmap()
+	 * succeeds or fails, then kill the process with SIGBUS.
+	 * ret = 0 when poison page is a clean page and it's dropped, no
+	 * SIGBUS is needed.
+	 */
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
-	else
-		ret = 0;
 	mmap_read_unlock(p->mm);
-	return ret > 0 ? -EHWPOISON : -EFAULT;
+
+	return ret > 0 ? -EHWPOISON : 0;
 }
 
 /*


