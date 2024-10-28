Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9654818E03A;
	Mon, 28 Oct 2024 06:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097855; cv=none; b=YCiOIK7XO4uINQ6M5VXh9KLZcUMVjz83C7CK3QcfajQFPEpaLtg6fZ80oUgfFJT+sKxcNk10mDX+83vSRnEKzEzAyTpQeFvl/bo+dag24T6GeCGl38MVBfo2rzbCfQJgHS+kpaCdSzzRYLuyNlhNR2lkQfnYvLR6VzCWdWseQZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097855; c=relaxed/simple;
	bh=iaTF0Gksot4A5oxl+EBoWJSHrVokcmtC5a0PY3YDogY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwCztvoHg/+yJHzpmh1FYkwyjefbK+aOThIrqZL1D2dEoMrDEXRqYsfiuqIjE0nCah3VNqW5L21OjKjlJuKf6YeD16a2fDkw+0BpUuhwG5Ox8nixsSICwM/pSaeP8Q7kDbpENZ2RhB4UrJUsGPQIHWYcOuM08dfRolQhTwl/sZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UunN3UfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UunN3UfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347F2C4CEC3;
	Mon, 28 Oct 2024 06:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097855;
	bh=iaTF0Gksot4A5oxl+EBoWJSHrVokcmtC5a0PY3YDogY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UunN3UfD+z0WYfJN+qaJj1g77WmJX62jWyzINgcdFWRGliJ/WGznhQ3ZZIEOKsPh4
	 DhZiNJMGVtbd1X68ig75S5Ne5URr/cc9IJuCHxFWSV/X0SlZgHz6twDXJLZUa3lCem
	 2XIfBTd0aPecT/LlHfCqjetQgIN0cpQDQwSv0ORE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liwei <liwei728@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/208] cpufreq: CPPC: fix perf_to_khz/khz_to_perf conversion exception
Date: Mon, 28 Oct 2024 07:25:56 +0100
Message-ID: <20241028062310.965192304@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: liwei <liwei728@huawei.com>

[ Upstream commit d93df29bdab133b85e94b3c328e7fe26a0ebd56c ]

When the nominal_freq recorded by the kernel is equal to the lowest_freq,
and the frequency adjustment operation is triggered externally, there is
a logic error in cppc_perf_to_khz()/cppc_khz_to_perf(), resulting in perf
and khz conversion errors.

Fix this by adding a branch processing logic when nominal_freq is equal
to lowest_freq.

Fixes: ec1c7ad47664 ("cpufreq: CPPC: Fix performance/frequency conversion")
Signed-off-by: liwei <liwei728@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20241024022952.2627694-1-liwei728@huawei.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 2297404fe4714..5df417626fd10 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1912,9 +1912,15 @@ unsigned int cppc_perf_to_khz(struct cppc_perf_caps *caps, unsigned int perf)
 	u64 mul, div;
 
 	if (caps->lowest_freq && caps->nominal_freq) {
-		mul = caps->nominal_freq - caps->lowest_freq;
+		/* Avoid special case when nominal_freq is equal to lowest_freq */
+		if (caps->lowest_freq == caps->nominal_freq) {
+			mul = caps->nominal_freq;
+			div = caps->nominal_perf;
+		} else {
+			mul = caps->nominal_freq - caps->lowest_freq;
+			div = caps->nominal_perf - caps->lowest_perf;
+		}
 		mul *= KHZ_PER_MHZ;
-		div = caps->nominal_perf - caps->lowest_perf;
 		offset = caps->nominal_freq * KHZ_PER_MHZ -
 			 div64_u64(caps->nominal_perf * mul, div);
 	} else {
@@ -1935,11 +1941,17 @@ unsigned int cppc_khz_to_perf(struct cppc_perf_caps *caps, unsigned int freq)
 {
 	s64 retval, offset = 0;
 	static u64 max_khz;
-	u64  mul, div;
+	u64 mul, div;
 
 	if (caps->lowest_freq && caps->nominal_freq) {
-		mul = caps->nominal_perf - caps->lowest_perf;
-		div = caps->nominal_freq - caps->lowest_freq;
+		/* Avoid special case when nominal_freq is equal to lowest_freq */
+		if (caps->lowest_freq == caps->nominal_freq) {
+			mul = caps->nominal_perf;
+			div = caps->nominal_freq;
+		} else {
+			mul = caps->nominal_perf - caps->lowest_perf;
+			div = caps->nominal_freq - caps->lowest_freq;
+		}
 		/*
 		 * We don't need to convert to kHz for computing offset and can
 		 * directly use nominal_freq and lowest_freq as the div64_u64
-- 
2.43.0



