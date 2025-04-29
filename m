Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5090F21772B;
	Tue, 29 Apr 2025 16:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945418; cv=none; b=FSBzhF4RKpiDUF5zrhsv+/wVoFvLn+2wh4U9kxjjz+hOfw27TCDxv7WfPBaCwl179iK1M+csPWSOzEeoHeAfEMCI+KJIxc7ctgxf/jMe7y3Fwo8QsfeAP+4gSzIkgiSgdqddxqQAcJ65wPpGrQakxg7MRpO0cUKh38XLqD422o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945418; c=relaxed/simple;
	bh=hLuUVwAzJPyATFPL8gZb7a9ojFjMxVhsD0rQA+59GiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uR5LqhYroI9bGui6iP4LjVLshMvDxjQGuWy8aRSCCx8ixg6HJS/VH+QSBaebHSrw6pydfwzzMPr2fN+IhaMQStW3wMLZFsfw8zDnMSYaGZEznH79KW2TTEEByo/xYR/PSZH/AxmxYs/xg6kt7ZgASOXCuXsJTNemXj06KHNeivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umL8MGvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umL8MGvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFCEC4CEEA;
	Tue, 29 Apr 2025 16:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945418;
	bh=hLuUVwAzJPyATFPL8gZb7a9ojFjMxVhsD0rQA+59GiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umL8MGvzI4r7uUpKfOi3VtBh8UaVbIaDkfx31EyX59fH+lQ9SjmKPv/ChRj6MIr3g
	 3GtjqUu+ofX7Yuj3tS8seuE0ppUEnoo1yYhBwIIZsrgOEb8oMgivCgZU+8bU4ZHgfp
	 tpejuTdJs29gszz6CcLiy+GdSA3ugWUdrHSQe/ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 105/179] perf/x86/intel: Allow to update user space GPRs from PEBS records
Date: Tue, 29 Apr 2025 18:40:46 +0200
Message-ID: <20250429161053.652247106@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -985,8 +985,10 @@ static u64 pebs_update_adaptive_cfg(stru
 	 * + precise_ip < 2 for the non event IP
 	 * + For RTM TSX weight we need GPRs for the abort code.
 	 */
-	gprs = (sample_type & PERF_SAMPLE_REGS_INTR) &&
-	       (attr->sample_regs_intr & PEBS_GP_REGS);
+	gprs = ((sample_type & PERF_SAMPLE_REGS_INTR) &&
+		(attr->sample_regs_intr & PEBS_GP_REGS)) ||
+	       ((sample_type & PERF_SAMPLE_REGS_USER) &&
+		(attr->sample_regs_user & PEBS_GP_REGS));
 
 	tsx_weight = (sample_type & PERF_SAMPLE_WEIGHT) &&
 		     ((attr->config & INTEL_ARCH_EVENT_MASK) ==
@@ -1569,7 +1571,7 @@ static void setup_pebs_adaptive_sample_d
 			regs->flags &= ~PERF_EFLAGS_EXACT;
 		}
 
-		if (sample_type & PERF_SAMPLE_REGS_INTR)
+		if (sample_type & (PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_REGS_USER))
 			adaptive_pebs_save_regs(regs, gprs);
 	}
 


