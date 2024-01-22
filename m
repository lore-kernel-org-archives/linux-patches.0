Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B39377636;
	Tue, 23 Jan 2024 02:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975533; cv=none; b=OWEzTi9G9hVdTlm2L52OLhnRCsWvrCtmXl+czlehMU8lsZRppBVnyM/fxXlJD2wCizvK4xuObuOLMuIH58opKe67QO0VemijlAjkHbijXpCnywX955PuwsTrVvBQDsB3flxyd7A84PcLswpxm7F5Uc/QLgzaES/u+apDwQAaQDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975533; c=relaxed/simple;
	bh=LlMxxlXdPbAT2WUKUPWYDzVw9xjoihs9RvYjp393tRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+Pc8+8SrwbhvvE4wUcyUjxu2AkLvFRbMk4XSu41ZUXaLT3qDqI804jP4Z0KmLVB6tyqdONsHOltyH5TJR755wIm/SMrrAqo4IfHfi1CV/D67A6TOoCMQulStW9xmytTzcOOzaeudqqeRvbpvGxVNwbhqUGCs+z1PyMAY28YP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCrc/nM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCrc/nM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F187AC43390;
	Tue, 23 Jan 2024 02:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975533;
	bh=LlMxxlXdPbAT2WUKUPWYDzVw9xjoihs9RvYjp393tRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCrc/nM0TNgfuXW997jueuFLyVUMoluRNzi1417uhlVPaAVq15cM6bMHneu/hulGV
	 zRsImYqqXnkHarDaXXgb7OShcnT4c3rEWxVMC2tUb1GHTDwqHXwL/jU77ePM8F5j0Z
	 JuVMxpINcMoQzqfCO6Ig940KkubIYjduTIJvgQRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	James Clark <james.clark@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 466/583] perf test record user-regs: Fix mask for vg register
Date: Mon, 22 Jan 2024 15:58:37 -0800
Message-ID: <20240122235826.252874630@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Veronika Molnarova <vmolnaro@redhat.com>

[ Upstream commit 28b01743ca752cea5ab182297d8b912b22f2a2d1 ]

The 'vg' register for arm64 shows up in --user_regs as available when
masking the variable AT_HWCAP with 1 << 22 returns '1' as done in
perf_regs.c.

However, in subtests for support of SVE, the check for the 'vg' register
is done by masking the variable AT_HWCAP with the value 0x200000 which
is equals to 1 << 21 instead of 1 << 22.

This results in inconsistencies on certain systems where the test
expects that the 'vg' register is not operational when it is, and
vice-versa.

During the testing on a machine that the test expected not to have the
'vg' register available, 'perf record' with the option --user-regs
showed records for the 'vg' register together with all of the others,
which means that the mask for the subtest of perf_event_attr is off by
one.

Change the value of the mask from 0x200000 to 0x400000 to correct it.

Fixes: 9440ebdc333dd12e ("perf test arm64: Add attr tests for new VG register")
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Link: https://lore.kernel.org/r/20231201194617.13012-1-vmolnaro@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/attr/test-record-user-regs-no-sve-aarch64 | 2 +-
 tools/perf/tests/attr/test-record-user-regs-sve-aarch64    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-user-regs-no-sve-aarch64 b/tools/perf/tests/attr/test-record-user-regs-no-sve-aarch64
index fbb065842880..bed765450ca9 100644
--- a/tools/perf/tests/attr/test-record-user-regs-no-sve-aarch64
+++ b/tools/perf/tests/attr/test-record-user-regs-no-sve-aarch64
@@ -6,4 +6,4 @@ args    = --no-bpf-event --user-regs=vg kill >/dev/null 2>&1
 ret     = 129
 test_ret = true
 arch    = aarch64
-auxv    = auxv["AT_HWCAP"] & 0x200000 == 0
+auxv    = auxv["AT_HWCAP"] & 0x400000 == 0
diff --git a/tools/perf/tests/attr/test-record-user-regs-sve-aarch64 b/tools/perf/tests/attr/test-record-user-regs-sve-aarch64
index c598c803221d..a65113cd7311 100644
--- a/tools/perf/tests/attr/test-record-user-regs-sve-aarch64
+++ b/tools/perf/tests/attr/test-record-user-regs-sve-aarch64
@@ -6,7 +6,7 @@ args    = --no-bpf-event --user-regs=vg kill >/dev/null 2>&1
 ret     = 1
 test_ret = true
 arch    = aarch64
-auxv    = auxv["AT_HWCAP"] & 0x200000 == 0x200000
+auxv    = auxv["AT_HWCAP"] & 0x400000 == 0x400000
 kernel_since = 6.1
 
 [event:base-record]
-- 
2.43.0



