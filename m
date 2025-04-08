Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535EB1AAA0F;
	Tue,  8 Apr 2025 11:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112846; cv=none; b=NntA9tTfbEu+LW/QdkcdsuVxcExw5j8X/tQ5Srt1Ds5KQD+XpRwgEoVMRdjnz/XPFm9TB1B2T5IGJL9ip+QcEy9MLdCM599u+cBS8dKN4mp3yD3eNmRVpesjDA3r2bThSaMrlbdTNNiDCcbUsUCWJ1wrjTObLUhFMrKfPEtDV58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112846; c=relaxed/simple;
	bh=qpZtdYfYDogLnXtk7mfAh2KTAoeiPVQ4vypSYIx/Aw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI0SNJx+6v3GLhXE0Sz8tcooDCM+FBDLrVnStPtgE8DPfyQM5qchwmf4hJg4sSKfMF4hgL1Xh2z4BiV5NTNhkSM1Ydd9Wk5pD3DTxi8qWayHDVUuHoHnlZnavJJIOwgMZ4ru7YU/iK/PzT4NzR3aVY0yMJTJnuNeDcYEcyIMGLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T7U/cSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T7U/cSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A49C4CEE5;
	Tue,  8 Apr 2025 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112846;
	bh=qpZtdYfYDogLnXtk7mfAh2KTAoeiPVQ4vypSYIx/Aw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T7U/cSi23VAwFJYs2to2fugZciPSZJVw5hxvGhcx+ePhs4XjR4mmbZ1v33zph+ea
	 TvkMbO9axan9d9EqdgJWiX9NYlR63f/GJt1RknlI95CFqw+Pqa94ItVtazKb2RGu1U
	 JOc7ic4yGt/N8xRHdNb+3I+lRBC8UhI5Ll8Qkyco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/279] sched/smt: Always inline sched_smt_active()
Date: Tue,  8 Apr 2025 12:50:03 +0200
Message-ID: <20250408104832.302293595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 09f37f2d7b21ff35b8b533f9ab8cfad2fe8f72f6 ]

sched_smt_active() can be called from noinstr code, so it should always
be inlined.  The CONFIG_SCHED_SMT version already has __always_inline.
Do the same for its !CONFIG_SCHED_SMT counterpart.

Fixes the following warning:

  vmlinux.o: error: objtool: intel_idle_ibrs+0x13: call to sched_smt_active() leaves .noinstr.text section

Fixes: 321a874a7ef8 ("sched/smt: Expose sched_smt_present static key")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/1d03907b0a247cf7fb5c1d518de378864f603060.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/r/202503311434.lyw2Tveh-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/smt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/smt.h b/include/linux/sched/smt.h
index 59d3736c454cf..737b50f40137b 100644
--- a/include/linux/sched/smt.h
+++ b/include/linux/sched/smt.h
@@ -12,7 +12,7 @@ static __always_inline bool sched_smt_active(void)
 	return static_branch_likely(&sched_smt_present);
 }
 #else
-static inline bool sched_smt_active(void) { return false; }
+static __always_inline bool sched_smt_active(void) { return false; }
 #endif
 
 void arch_smt_update(void);
-- 
2.39.5



