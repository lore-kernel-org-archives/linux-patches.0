Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD453B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD238C433C7;
	Wed,  9 Aug 2023 10:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578530;
	bh=VuwI9w1OwwQmh7q/FoCkV/Wy/gKyNzdpNprREe6yMzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKN2mgFXRYapn0tqLv9y5x5qWbZ3eQAQTH1HKVupJhU0W23As90xF23jscVpUlwq3
	 73j0Sx4MfYvXaFIX3ARH07LJKZhH4f8llwMrLjr9VIN3Mz8CCgUjxVPwhrAXoQAUM6
	 5nja9QWbToSBpxUXJDLir7LQ6wAMfvsPfVML8Yo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 092/127] arm64/fpsimd: Sync FPSIMD state with SVE for SME only systems
Date: Wed,  9 Aug 2023 12:41:19 +0200
Message-ID: <20230809103639.686518142@linuxfoundation.org>
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

commit 507ea5dd92d23fcf10e4d1a68a443c86a49753ed upstream.

Currently we guard FPSIMD/SVE state conversions with a check for the system
supporting SVE but SME only systems may need to sync streaming mode SVE
state so add a check for SME support too.  These functions are only used
by the ptrace code.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230803-arm64-fix-ptrace-ssve-no-sve-v1-2-49df214bfb3e@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -634,7 +634,7 @@ static void fpsimd_to_sve(struct task_st
 	void *sst = task->thread.sve_state;
 	struct user_fpsimd_state const *fst = &task->thread.uw.fpsimd_state;
 
-	if (!system_supports_sve())
+	if (!system_supports_sve() && !system_supports_sme())
 		return;
 
 	vq = sve_vq_from_vl(thread_get_cur_vl(&task->thread));
@@ -660,7 +660,7 @@ static void sve_to_fpsimd(struct task_st
 	unsigned int i;
 	__uint128_t const *p;
 
-	if (!system_supports_sve())
+	if (!system_supports_sve() && !system_supports_sme())
 		return;
 
 	vl = thread_get_cur_vl(&task->thread);


