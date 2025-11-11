Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718BF25C818;
	Tue, 11 Nov 2025 01:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823061; cv=none; b=s3ZWpoKrSFYWP4L/WR+LJKzMo+5i37egpLdZoIxk9vl54O6JzR6vWnHy0buFhII1oRexsmQLz/LcBLDf2kuzyGBNAm70oBUUk4wpErvin64LsOnrbQE/z8K52bLbMKbSNp2+EKyQRv1fI4Jf/W0sXiQfFfg3cqc2pYqDpD8uR8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823061; c=relaxed/simple;
	bh=9lI61FsqKRXAdvcCiF6dJyd2mOdgNC+RPi2wIkFLRcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvfrUO7PmbfVJIRaVZv5qZCMYFhoPeTDuJXYlkpvGw7Azw+yslLpGWLP8ZzAtqnNvC8Dh9gbbHQn+m/K9FFim/fXRwdA78aH1Vo5X9mdGSFIf8lUUYAJ6kxfPc/2FTuU/ntKq5aPBevuC8j+9P97Bgl1pp2tB+HfaDH9O1EFwyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtLu2Lsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtLu2Lsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0B3C113D0;
	Tue, 11 Nov 2025 01:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823061;
	bh=9lI61FsqKRXAdvcCiF6dJyd2mOdgNC+RPi2wIkFLRcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtLu2LsdzPf403UAtJ0qjsyeU0MvSE15RFmqU0MURNTV5Tp0K+4qnlf9g18znVVXT
	 xolAStNxcKfdo/nb91EXFTHxOUhybvS9e8Zrcq7G+3rgFg5rHgu7W8k1MOgBEXkmf0
	 E8xMl4Q4Rx6phwrKgTdx+TikDPhu7w7ZhbMvSHi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/565] tools/power x86_energy_perf_policy: Enhance HWP enable
Date: Tue, 11 Nov 2025 09:40:20 +0900
Message-ID: <20251111004530.627270720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit c97c057d357c4b39b153e9e430bbf8976e05bd4e ]

On enabling HWP, preserve the reserved bits in MSR_PM_ENABLE.

Also, skip writing the MSR_PM_ENABLE if HWP is already enabled.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86_energy_perf_policy/x86_energy_perf_policy.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index c883f211dbcc9..0bda8e3ae7f77 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1166,13 +1166,18 @@ int update_hwp_request_pkg(int pkg)
 
 int enable_hwp_on_cpu(int cpu)
 {
-	unsigned long long msr;
+	unsigned long long old_msr, new_msr;
+
+	get_msr(cpu, MSR_PM_ENABLE, &old_msr);
+
+	if (old_msr & 1)
+		return 0;	/* already enabled */
 
-	get_msr(cpu, MSR_PM_ENABLE, &msr);
-	put_msr(cpu, MSR_PM_ENABLE, 1);
+	new_msr = old_msr | 1;
+	put_msr(cpu, MSR_PM_ENABLE, new_msr);
 
 	if (verbose)
-		printf("cpu%d: MSR_PM_ENABLE old: %d new: %d\n", cpu, (unsigned int) msr, 1);
+		printf("cpu%d: MSR_PM_ENABLE old: %llX new: %llX\n", cpu, old_msr, new_msr);
 
 	return 0;
 }
-- 
2.51.0



