Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8C313BC38;
	Thu, 23 May 2024 13:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470231; cv=none; b=bZO2kKXHA7p75KX6cmBSgpwAJJpf0AE9wo4wTR5AwRldyoVgktzLZMrXyPbmHy48MLf+CYKzuZcNXbwGfug2Q4Vmm1r0/57D8PykmI9+ZFMdw517IICIetrQ/cmggG6Mz23YU8qEA/oB6mKOYDTItSZlvpmcHzGVNT8vcDNt3/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470231; c=relaxed/simple;
	bh=N68t6Q28fL4ZLR7uloRmSlS+7gxIIFUSn3yflux95mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYqu226CwaqLkXNGfabsomCKH0x7rcNkxg445W+0PT6MCSv0OgaE9qyxSeYp3Z4trntr3uFA6thVGYKy3EXW4YvTJHIlEzPePM9R4bPwqRv1dHDo7yPSxQFufvAR23yzfyM4aMCJraoFmEswfES+qnNFxuBvdVEEnJb7jx3s9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5T89LsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5T89LsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC59C2BD10;
	Thu, 23 May 2024 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470231;
	bh=N68t6Q28fL4ZLR7uloRmSlS+7gxIIFUSn3yflux95mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5T89LsY4LtmigW8Xf/tNErCmgVrVZRIrhu8yxLUAU4uuPt+EM44CbsWWfPBIbfvS
	 OYPw0vRk1F12Ok58HCPJurizR/EdqI1hnldK/GT96NhPkcbVnnmbHDmB0/BqifOxC+
	 HOGTnDJu4HHN8IBsgLGe0Zrzru1ynvijs7h/+hU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Gaha Bana <gahabana@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 03/25] cpufreq: amd-pstate: fix the highest frequency issue which limits performance
Date: Thu, 23 May 2024 15:12:48 +0200
Message-ID: <20240523130330.517274967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

commit bf202e654bfa57fb8cf9d93d4c6855890b70b9c4 upstream.

To address the performance drop issue, an optimization has been
implemented. The incorrect highest performance value previously set by the
low-level power firmware for AMD CPUs with Family ID 0x19 and Model ID
ranging from 0x70 to 0x7F series has been identified as the cause.

To resolve this, a check has been implemented to accurately determine the
CPU family and model ID. The correct highest performance value is now set
and the performance drop caused by the incorrect highest performance value
are eliminated.

Before the fix, the highest frequency was set to 4200MHz, now it is set
to 4971MHz which is correct.

CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE    MAXMHZ   MINMHZ       MHZ
  0    0      0    0 0:0:0:0          yes 4971.0000 400.0000  400.0000
  1    0      0    0 0:0:0:0          yes 4971.0000 400.0000  400.0000
  2    0      0    1 1:1:1:0          yes 4971.0000 400.0000 4865.8140
  3    0      0    1 1:1:1:0          yes 4971.0000 400.0000  400.0000

Fixes: f3a052391822 ("cpufreq: amd-pstate: Enable amd-pstate preferred core support")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218759
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Gaha Bana <gahabana@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -50,7 +50,8 @@
 
 #define AMD_PSTATE_TRANSITION_LATENCY	20000
 #define AMD_PSTATE_TRANSITION_DELAY	1000
-#define AMD_PSTATE_PREFCORE_THRESHOLD	166
+#define CPPC_HIGHEST_PERF_PERFORMANCE	196
+#define CPPC_HIGHEST_PERF_DEFAULT	166
 
 /*
  * TODO: We need more time to fine tune processors with shared memory solution
@@ -290,6 +291,21 @@ static inline int amd_pstate_enable(bool
 	return static_call(amd_pstate_enable)(enable);
 }
 
+static u32 amd_pstate_highest_perf_set(struct amd_cpudata *cpudata)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	/*
+	 * For AMD CPUs with Family ID 19H and Model ID range 0x70 to 0x7f,
+	 * the highest performance level is set to 196.
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=218759
+	 */
+	if (c->x86 == 0x19 && (c->x86_model >= 0x70 && c->x86_model <= 0x7f))
+		return CPPC_HIGHEST_PERF_PERFORMANCE;
+
+	return CPPC_HIGHEST_PERF_DEFAULT;
+}
+
 static int pstate_init_perf(struct amd_cpudata *cpudata)
 {
 	u64 cap1;
@@ -306,7 +322,7 @@ static int pstate_init_perf(struct amd_c
 	 * the default max perf.
 	 */
 	if (cpudata->hw_prefcore)
-		highest_perf = AMD_PSTATE_PREFCORE_THRESHOLD;
+		highest_perf = amd_pstate_highest_perf_set(cpudata);
 	else
 		highest_perf = AMD_CPPC_HIGHEST_PERF(cap1);
 
@@ -330,7 +346,7 @@ static int cppc_init_perf(struct amd_cpu
 		return ret;
 
 	if (cpudata->hw_prefcore)
-		highest_perf = AMD_PSTATE_PREFCORE_THRESHOLD;
+		highest_perf = amd_pstate_highest_perf_set(cpudata);
 	else
 		highest_perf = cppc_perf.highest_perf;
 


