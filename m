Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5668837;
	Mon, 28 Oct 2024 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098379; cv=none; b=NfTur7M94R6wzt/8P41AXgTWcs4yhI/hYlAjnxRQ5uRB3Nd5CgExS5S0Qo0tQ1kAZ86BNiF4v6QEDEW9Z22SLXfgeMTGOH91RDdxAfvukHLdVGQUNq12IzqkhhkAxweWPkJqhc8VUzfFZVKviKtxZBDlcE3nDLHmZfadZ4t2gJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098379; c=relaxed/simple;
	bh=R5RNW7JZoxAIrVvyiweZaq4448vKRxAtGIOgT+TnRj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrDDm8egG2tAs0hp8UESQtOYNzzHoVHeYjgFqBFwizp8sbgHEf86xuC9A0S9N8UbpS5jmHWwU+IU+ZhjoQYJFCaVunZ9+PrETAf5zjCxmbCYhvAEKXues3Tl8zA1w0GBXze6kNx3K39f/9XxmlL8+iz2b2c9v8JsNa2krnxSEbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khpLoq/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khpLoq/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B641FC4CEC3;
	Mon, 28 Oct 2024 06:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098379;
	bh=R5RNW7JZoxAIrVvyiweZaq4448vKRxAtGIOgT+TnRj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khpLoq/yNCXNX1QUtg8fcMODD8gHWiJGsHTgjIKODScUJyAUw0kYIhQlp5LS783+R
	 j18zlHyCS30YibzNCTV83e7zGnsDDeShm03qAouUNBJqAkU9ir1ACM1M/nKacvLH4m
	 aOT1pnlyPp+swnNilJ0Hm97kzL2vnSMyp2cabd2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liwei <liwei728@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 200/261] cpufreq: CPPC: fix perf_to_khz/khz_to_perf conversion exception
Date: Mon, 28 Oct 2024 07:25:42 +0100
Message-ID: <20241028062317.063213821@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5b06e236aabef..ed91dfd4fdca7 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1916,9 +1916,15 @@ unsigned int cppc_perf_to_khz(struct cppc_perf_caps *caps, unsigned int perf)
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
@@ -1939,11 +1945,17 @@ unsigned int cppc_khz_to_perf(struct cppc_perf_caps *caps, unsigned int freq)
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



