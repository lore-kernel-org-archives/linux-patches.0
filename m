Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3534A47A66;
	Mon,  1 Apr 2024 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987804; cv=none; b=FeFMsBmFIKYoNUZs+FQPoqjAwujPypi1nDy78ORzLf23K+OgrIpeJduJbxewkqGyr9KLg/xuEMY4jM5lbv4paPXHc8Xgt0CHFXjKAVYJyr0xr9I4BA2mleXwzdwEi1+3vcDGIweNWXqwdT/2jv3D748r/EOgWP6KGDo6tGpByH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987804; c=relaxed/simple;
	bh=5kbZiIGYpQxlzQebjf/9TdVCXLcE+DL4waaVK5sNIYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqW2YWhwiQtgrTssadRIiOudUOzOXIyxxTVDs3jpSL6Klo7x5lM0G9vV8pfVUTRI72xTxjXIFouVGu4ZTpbUCiweWnT1bFcGzIAAm9s/PL/PnFeVEO58RBjJA1k1ZAqXWq67jkZYqgGJ/exvn/RsnpvpWeOi4zMe7COkZvnfBAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDjqQQhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDjqQQhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5A5C433F1;
	Mon,  1 Apr 2024 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987803;
	bh=5kbZiIGYpQxlzQebjf/9TdVCXLcE+DL4waaVK5sNIYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDjqQQhMvKyvbEraSOOgHFu1/2FMSrGGpVmXZkz8TWbRAleGBHJsqny30JFhOXzhI
	 fCqsehxUJ4OYQXKodic3zgJwV7dbi0m2FAaxrm633Ay+X/7FNZR0dt/t1lvn6w/Q8W
	 UBrqLno6z4tb4QMx7dni2z29Ge8MZ6JX6NrRz4lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>
Subject: [PATCH 6.8 397/399] perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later
Date: Mon,  1 Apr 2024 17:46:03 +0200
Message-ID: <20240401152601.032616293@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

commit c7b2edd8377be983442c1344cb940cd2ac21b601 upstream.

AMD processors based on Zen 2 and later microarchitectures do not
support PMCx087 (instruction pipe stalls) which is used as the backing
event for "stalled-cycles-frontend" and "stalled-cycles-backend".

Use PMCx0A9 (cycles where micro-op queue is empty) instead to count
frontend stalls and remove the entry for backend stalls since there
is no direct replacement.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h")
Link: https://lore.kernel.org/r/03d7fc8fa2a28f9be732116009025bdec1b3ec97.1711352180.git.sandipan.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/core.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -250,7 +250,7 @@ static const u64 amd_perfmon_event_map[P
 /*
  * AMD Performance Monitor Family 17h and later:
  */
-static const u64 amd_f17h_perfmon_event_map[PERF_COUNT_HW_MAX] =
+static const u64 amd_zen1_perfmon_event_map[PERF_COUNT_HW_MAX] =
 {
 	[PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
 	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
@@ -262,10 +262,24 @@ static const u64 amd_f17h_perfmon_event_
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= 0x0187,
 };
 
+static const u64 amd_zen2_perfmon_event_map[PERF_COUNT_HW_MAX] =
+{
+	[PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
+	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0xff60,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x0964,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
+	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x00a9,
+};
+
 static u64 amd_pmu_event_map(int hw_event)
 {
-	if (boot_cpu_data.x86 >= 0x17)
-		return amd_f17h_perfmon_event_map[hw_event];
+	if (cpu_feature_enabled(X86_FEATURE_ZEN2) || boot_cpu_data.x86 >= 0x19)
+		return amd_zen2_perfmon_event_map[hw_event];
+
+	if (cpu_feature_enabled(X86_FEATURE_ZEN1))
+		return amd_zen1_perfmon_event_map[hw_event];
 
 	return amd_perfmon_event_map[hw_event];
 }


