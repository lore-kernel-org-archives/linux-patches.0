Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4136A352;
	Mon,  8 Apr 2024 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583660; cv=none; b=hddUjGERq9XIohVkfKDTII93qgszqOg7vuwPI7KSgtQQEX5fIqWwJM2/JvwQ3QXr5e7czunWodl5ll9ao5kXOaYRBhdU3E0sr+Kqci5LNU3Op2DZCtFMNYPTPRBCB2nTQSCYiluuiYGCpoL/Y+vqycnHKDTB4ivafKpLlYt7Sb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583660; c=relaxed/simple;
	bh=43L5rZTcPNyLXxpSAaoi0xD6uZIFcnXCEIKRVli1Qmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnFCUsHILGEinNM+qKOUWhnijZP7y/rWyd+fa02M03pCVatW+tMm/Ozdj1hKWxz/s5th55d7BP/IAfgAp3WC8ei4EfjHGyVKZdnXmsYmqef7Llr7lFGvi2nUs+lX+DKTjIlL+aU14V7fqA7iFQtfW6ZsjNDJis7MlU1VjD1IgbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2xaAI7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2xaAI7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47932C433F1;
	Mon,  8 Apr 2024 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583660;
	bh=43L5rZTcPNyLXxpSAaoi0xD6uZIFcnXCEIKRVli1Qmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2xaAI7J2eLV5MpvhwMpwul0u0CrbEyvRiofS0+dCiu8T9ziV87xfMV+b8qPpFxxT
	 CLqJKq/3WSXvw49QVH+IbmD0REdUXV0JjEve02IU//APhehb8/JyOgGKMgOFpOEiG2
	 EgRY6TAiNdnLjWtB1BpOqyAJjN6o8gJeUh121T9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 220/252] arm64/ptrace: Use saved floating point state type to determine SVE layout
Date: Mon,  8 Apr 2024 14:58:39 +0200
Message-ID: <20240408125313.485326128@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit b017a0cea627fcbe158fc2c214fe893e18c4d0c4 upstream.

The SVE register sets have two different formats, one of which is a wrapped
version of the standard FPSIMD register set and another with actual SVE
register data. At present we check TIF_SVE to see if full SVE register
state should be provided when reading the SVE regset but if we were in a
syscall we may have saved only floating point registers even though that is
set.

Fix this and simplify the logic by checking and using the format which we
recorded when deciding if we should use FPSIMD or SVE format.

Fixes: 8c845e273104 ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240325-arm64-ptrace-fp-type-v1-1-8dc846caf11f@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -728,7 +728,6 @@ static void sve_init_header_from_task(st
 {
 	unsigned int vq;
 	bool active;
-	bool fpsimd_only;
 	enum vec_type task_type;
 
 	memset(header, 0, sizeof(*header));
@@ -744,12 +743,10 @@ static void sve_init_header_from_task(st
 	case ARM64_VEC_SVE:
 		if (test_tsk_thread_flag(target, TIF_SVE_VL_INHERIT))
 			header->flags |= SVE_PT_VL_INHERIT;
-		fpsimd_only = !test_tsk_thread_flag(target, TIF_SVE);
 		break;
 	case ARM64_VEC_SME:
 		if (test_tsk_thread_flag(target, TIF_SME_VL_INHERIT))
 			header->flags |= SVE_PT_VL_INHERIT;
-		fpsimd_only = false;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -757,7 +754,7 @@ static void sve_init_header_from_task(st
 	}
 
 	if (active) {
-		if (fpsimd_only) {
+		if (target->thread.fp_type == FP_STATE_FPSIMD) {
 			header->flags |= SVE_PT_REGS_FPSIMD;
 		} else {
 			header->flags |= SVE_PT_REGS_SVE;


