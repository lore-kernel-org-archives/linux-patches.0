Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0142CCC5;
	Tue, 17 Jun 2025 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175956; cv=none; b=Q3CXVpyfHSvE7FpNBMJ1r/KNjKYSY2PG0TWXIHTW18dpXLu8VCtqzoMm29cOJkdeSpbfV8abT4Oc5K4/Dnd91gJLgbHE4yWp2bRKEs2Xy2crn0a3AXceMNqb/HwiBINjnqcbLt2r4/Ww/h2sIDIlX1TbBZoSzxGY0ijgruzt+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175956; c=relaxed/simple;
	bh=eLBaqaIcrVvkaQ7JgM6I/LpoFBfnZJYpk3WdNXAPtdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de1SbWSeXpK1hrrWoYytVLyb4HXVvfQZ8mSHrMJD9ehSZG8K8Q1corvPBdPeXs57HTdELoBipoywE0BpDjR3kde9Iggb/fIfYJi9CSjnHT6aK8dT71ef6E7d3zq+onESSRovEwMGvu8AOhx8gwbV+wfGGCAjzKlCBtVllssLj2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzXIdJD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzXIdJD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8AAC4CEE7;
	Tue, 17 Jun 2025 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175956;
	bh=eLBaqaIcrVvkaQ7JgM6I/LpoFBfnZJYpk3WdNXAPtdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzXIdJD5Xd/IbUiN65pCHIosbdboEr7z2UQwS1tLd7SbVrCDGUpp7edmCEHB0Jdes
	 /3Sr5CSS/rxfC4VKdK+wQiHrHmNakjsGTu0VdIkDvk+asFMqHxgJ587nNpoKsoflMq
	 WGTl2Gtu5SIdLub8kKa3bqi86mcSpfhUpYriF/cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Spickett <david.spickett@arm.com>,
	Luis Machado <luis.machado@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 138/780] kselftest/arm64: fp-ptrace: Fix expected FPMR value when PSTATE.SM is changed
Date: Tue, 17 Jun 2025 17:17:26 +0200
Message-ID: <20250617152457.119196842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 78b23877dbba7dbcda2b89383d17bed82ce8f663 ]

The fp-ptrace test suite expects that FPMR is set to zero when PSTATE.SM
is changed via ptrace, but ptrace has never altered FPMR in this way,
and the test logic erroneously relies upon (and has concealed) a bug
where task_fpsimd_load() would unexpectedly and non-deterministically
clobber FPMR.

Using ptrace, FPMR can only be altered by writing to the NT_ARM_FPMR
regset. The value of PSTATE.SM can be altered by writing to the
NT_ARM_SVE or NT_ARM_SSVE regsets, and/or by changing the SME vector
length (when writing to the NT_ARM_SVE, NT_ARM_SSVE, or NT_ARM_ZA
regsets), but none of these writes will change the value of FPMR.

The task_fpsimd_load() bug was introduced with the initial FPMR support
in commit:

  203f2b95a882 ("arm64/fpsimd: Support FEAT_FPMR")

The incorrect FPMR test code was introduced in commit:

  7dbd26d0b22d ("kselftest/arm64: Add FPMR coverage to fp-ptrace")

Subsequently, the task_fpsimd_load() bug was fixed in commit:

  e5fa85fce08b ("arm64/fpsimd: Don't corrupt FPMR when streaming mode changes")

... whereupon the fp-ptrace FPMR tests started failing reliably, e.g.

| # # Mismatch in saved FPMR: 915058000 != 0
| # not ok 25 SVE write, SVE 64->64, SME 64/0->64/1

Fix this by changing the test to expect that FPMR is *NOT* changed when
PSTATE.SM is changed via ptrace, matching the extant behaviour.

I've chosen to update the test code rather than modifying ptrace to zero
FPMR when PSTATE.SM changes. Not zeroing FPMR is simpler overall, and
allows the NT_ARM_FPMR regset to be handled independently from other
regsets, leaving less scope for error.

Fixes: 7dbd26d0b22d ("kselftest/arm64: Add FPMR coverage to fp-ptrace")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Spickett <david.spickett@arm.com>
Cc: Luis Machado <luis.machado@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250508132644.1395904-22-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/fp-ptrace.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/fp-ptrace.c b/tools/testing/selftests/arm64/fp/fp-ptrace.c
index 4930e03a7b990..762048eb354ff 100644
--- a/tools/testing/selftests/arm64/fp/fp-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/fp-ptrace.c
@@ -891,18 +891,11 @@ static void set_initial_values(struct test_config *config)
 {
 	int vq = __sve_vq_from_vl(vl_in(config));
 	int sme_vq = __sve_vq_from_vl(config->sme_vl_in);
-	bool sm_change;
 
 	svcr_in = config->svcr_in;
 	svcr_expected = config->svcr_expected;
 	svcr_out = 0;
 
-	if (sme_supported() &&
-	    (svcr_in & SVCR_SM) != (svcr_expected & SVCR_SM))
-		sm_change = true;
-	else
-		sm_change = false;
-
 	fill_random(&v_in, sizeof(v_in));
 	memcpy(v_expected, v_in, sizeof(v_in));
 	memset(v_out, 0, sizeof(v_out));
@@ -953,12 +946,7 @@ static void set_initial_values(struct test_config *config)
 	if (fpmr_supported()) {
 		fill_random(&fpmr_in, sizeof(fpmr_in));
 		fpmr_in &= FPMR_SAFE_BITS;
-
-		/* Entering or exiting streaming mode clears FPMR */
-		if (sm_change)
-			fpmr_expected = 0;
-		else
-			fpmr_expected = fpmr_in;
+		fpmr_expected = fpmr_in;
 	} else {
 		fpmr_in = 0;
 		fpmr_expected = 0;
-- 
2.39.5



