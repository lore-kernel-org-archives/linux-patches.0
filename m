Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00615239072;
	Tue, 29 Apr 2025 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948951; cv=none; b=BEqM8hDhMBxGFdUiPK2OqZHkdb/fH/TFXULZjSjUtiI8LR21yxg2TOAArej9+JxiIr1N/ZTm1sxLEzUVqkUAeHD64CX+vi0iHIg1XPr29M+DUSlYHQ7H7/SMh01ceoNjhR/18SIx5gt9zy8yFkqTkV8y9sp5iFLC2dC8kyslELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948951; c=relaxed/simple;
	bh=vyJOVtdHhzL4Cb4M3EVEqbGm+74TijtG///9Tb9KaRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXjVTupsxD/hurVgJNOrLfMcSrGJ1T8s/u3PNEofej2GoXG6DUaxdVRkzsvvqAJCnnQ9eByKZG32/0d2o3zFVUEGHsSdJ3ts+4I08EiYPN3IyhE8tY9L6E7cbuOc7S4XybHdyKEZgxnjbgFdauEE/g03gp7ImtFsq1dOsHo99HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1tMWjRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1tMWjRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AE7C4CEE3;
	Tue, 29 Apr 2025 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948950;
	bh=vyJOVtdHhzL4Cb4M3EVEqbGm+74TijtG///9Tb9KaRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1tMWjRLT1XH/cFWL02Z+qcIF+XxeLPRhFKbxngh33EXJiFrKKrtvz8rCP0/o8FQU
	 KMbWDP98sPzLurPQJYi9osgrD4SGtjnglxLPlBOw6xslgdSlUrVy8vM9d0Yh6AKXlX
	 Wd8Z+hxWSu6QfhXFCsnqkEBjV+DHIr2D5L0S+4lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.15 173/373] perf/x86/intel: Allow to update user space GPRs from PEBS records
Date: Tue, 29 Apr 2025 18:40:50 +0200
Message-ID: <20250429161130.291371273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit 71dcc11c2cd9e434c34a63154ecadca21c135ddd upstream.

Currently when a user samples user space GPRs (--user-regs option) with
PEBS, the user space GPRs actually always come from software PMI
instead of from PEBS hardware. This leads to the sampled GPRs to
possibly be inaccurate for single PEBS record case because of the
skid between counter overflow and GPRs sampling on PMI.

For the large PEBS case, it is even worse. If user sets the
exclude_kernel attribute, large PEBS would be used to sample user space
GPRs, but since PEBS GPRs group is not really enabled, it leads to all
samples in the large PEBS record to share the same piece of user space
GPRs, like this reproducer shows:

  $ perf record -e branches:pu --user-regs=ip,ax -c 100000 ./foo
  $ perf report -D | grep "AX"

  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead
  .... AX    0x000000003a0d4ead

So enable GPRs group for user space GPRs sampling and prioritize reading
GPRs from PEBS. If the PEBS sampled GPRs is not user space GPRs (single
PEBS record case), perf_sample_regs_user() modifies them to user space
GPRs.

[ mingo: Clarified the changelog. ]

Fixes: c22497f5838c ("perf/x86/intel: Support adaptive PEBS v4")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250415104135.318169-2-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1101,8 +1101,10 @@ static u64 pebs_update_adaptive_cfg(stru
 	 * + precise_ip < 2 for the non event IP
 	 * + For RTM TSX weight we need GPRs for the abort code.
 	 */
-	gprs = (sample_type & PERF_SAMPLE_REGS_INTR) &&
-	       (attr->sample_regs_intr & PEBS_GP_REGS);
+	gprs = ((sample_type & PERF_SAMPLE_REGS_INTR) &&
+		(attr->sample_regs_intr & PEBS_GP_REGS)) ||
+	       ((sample_type & PERF_SAMPLE_REGS_USER) &&
+		(attr->sample_regs_user & PEBS_GP_REGS));
 
 	tsx_weight = (sample_type & PERF_SAMPLE_WEIGHT_TYPE) &&
 		     ((attr->config & INTEL_ARCH_EVENT_MASK) ==
@@ -1701,7 +1703,7 @@ static void setup_pebs_adaptive_sample_d
 			regs->flags &= ~PERF_EFLAGS_EXACT;
 		}
 
-		if (sample_type & PERF_SAMPLE_REGS_INTR)
+		if (sample_type & (PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_REGS_USER))
 			adaptive_pebs_save_regs(regs, gprs);
 	}
 


