Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA866131
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E7EC433C7;
	Wed,  9 Aug 2023 10:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578527;
	bh=V+Es6sw2et+jc5Mjmz9BIcuvmXJlzm/WGvxFMcOn2/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDY+DQjCb1leDLG3XrvKZAzA4228t56GSUutPqvKDk1W5bzhILu1m9HDJpPIo4lTa
	 oG8huQN12BV6xw0MBlFo84VRQQFs4wmpM/0//rrdk1/GCeuS2yJOIGdXhiIF3+42dm
	 PsiJScIQ4vyo77iVPcOwdlBasQFyccB4McZTdDV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Spickett <David.Spickett@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 091/127] arm64/fpsimd: Clear SME state in the target task when setting the VL
Date: Wed,  9 Aug 2023 12:41:18 +0200
Message-ID: <20230809103639.657173735@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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

commit c9bb40b7f786662e33d71afe236442b0b61f0446 upstream.

When setting SME vector lengths we clear TIF_SME to reenable SME traps,
doing a reallocation of the backing storage on next use. We do this using
clear_thread_flag() which operates on the current thread, meaning that when
setting the vector length via ptrace we may both not force traps for the
target task and force a spurious flush of any SME state that the tracing
task may have.

Clear the flag in the target task.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Reported-by: David Spickett <David.Spickett@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230803-arm64-fix-ptrace-tif-sme-v1-1-88312fd6fbfd@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -864,7 +864,7 @@ int vec_set_vector_length(struct task_st
 			 */
 			task->thread.svcr &= ~(SVCR_SM_MASK |
 					       SVCR_ZA_MASK);
-			clear_thread_flag(TIF_SME);
+			clear_tsk_thread_flag(task, TIF_SME);
 			free_sme = true;
 		}
 	}


