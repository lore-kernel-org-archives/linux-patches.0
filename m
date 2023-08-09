Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF214A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9196DC433C8;
	Wed,  9 Aug 2023 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578148;
	bh=KtYuMILzbaHTLhKV23lffYrWvWrkkairVdXZGEQVTds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYDfCWmtk+n7ipQZNBvtzs7CsWD8VfKsa1/pov/2oUfBsmgQvN4rp+tugRqrYGAUp
	 EdWrbQX9w5YsfvqishWTkPGpadmt29AVXrXeUx0W+Qb9eDDyLaTSjZ9uJdeXwuXKWK
	 M0KY9sH1mddDSzaBUO09EEDdL4UyTmgRhFWNFvsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.4 122/165] arm64/fpsimd: Sync and zero pad FPSIMD state for streaming SVE
Date: Wed,  9 Aug 2023 12:40:53 +0200
Message-ID: <20230809103646.792321856@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit 69af56ae56a48a2522aad906c4461c6c7c092737 upstream.

We have a function sve_sync_from_fpsimd_zeropad() which is used by the
ptrace code to update the SVE state when the user writes to the the
FPSIMD register set.  Currently this checks that the task has SVE
enabled but this will miss updates for tasks which have streaming SVE
enabled if SVE has not been enabled for the thread, also do the
conversion if the task has streaming SVE enabled.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230803-arm64-fix-ptrace-ssve-no-sve-v1-3-49df214bfb3e@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -835,7 +835,8 @@ void sve_sync_from_fpsimd_zeropad(struct
 	void *sst = task->thread.sve_state;
 	struct user_fpsimd_state const *fst = &task->thread.uw.fpsimd_state;
 
-	if (!test_tsk_thread_flag(task, TIF_SVE))
+	if (!test_tsk_thread_flag(task, TIF_SVE) &&
+	    !thread_sm_enabled(&task->thread))
 		return;
 
 	vq = sve_vq_from_vl(thread_get_cur_vl(&task->thread));


