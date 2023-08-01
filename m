Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71710200A7
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87BAC433C7;
	Tue,  1 Aug 2023 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883463;
	bh=uJxlDFOPK3w/8qVVhFZBlAYqHTuYbFOEP4+eMFD0+0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVOIwOsKGI9mHL1oZmj9yQN18coVs6Di/qlTzwgAJG/98LJ12o4zLMJmRmYHyrnVg
	 YHgYhiqG9o9raUgH+cqGOKxVkogjr2PJmFsafuOiW2kPXnfcPvIeQmA3hCK/fJcABM
	 qHXMagsSSIpKJ+sYC/P5SEg6Fmb4sC68nEGj426o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.4 225/239] arm64/sme: Set new vector length before reallocating
Date: Tue,  1 Aug 2023 11:21:29 +0200
Message-ID: <20230801091934.058482096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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

commit 05d881b85b48c7ac6a7c92ce00aa916c4a84d052 upstream.

As part of fixing the allocation of the buffer for SVE state when changing
SME vector length we introduced an immediate reallocation of the SVE state,
this is also done when changing the SVE vector length for consistency.
Unfortunately this reallocation is done prior to writing the new vector
length to the task struct, meaning the allocation is done with the old
vector length and can lead to memory corruption due to an undersized buffer
being used.

Move the update of the vector length before the allocation to ensure that
the new vector length is taken into account.

For some reason this isn't triggering any problems when running tests on
the arm64 fixes branch (even after repeated tries) but is triggering
issues very often after merge into mainline.

Fixes: d4d5be94a878 ("arm64/fpsimd: Ensure SME storage is allocated after SVE VL changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230726-arm64-fix-sme-fix-v1-1-7752ec58af27@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -917,6 +917,8 @@ int vec_set_vector_length(struct task_st
 	if (task == current)
 		put_cpu_fpsimd_context();
 
+	task_set_vl(task, type, vl);
+
 	/*
 	 * Free the changed states if they are not in use, SME will be
 	 * reallocated to the correct size on next use and we just
@@ -931,8 +933,6 @@ int vec_set_vector_length(struct task_st
 	if (free_sme)
 		sme_free(task);
 
-	task_set_vl(task, type, vl);
-
 out:
 	update_tsk_thread_flag(task, vec_vl_inherit_flag(type),
 			       flags & PR_SVE_VL_INHERIT);


