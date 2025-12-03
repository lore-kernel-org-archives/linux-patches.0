Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EAB2FD678;
	Wed,  3 Dec 2025 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776064; cv=none; b=FiXP7uBESzEQh+1RHXQD9qCapLB22PQCdDv9TE9tUOpHeWbzxcJNjqpCMsruiyHXqqXn3Fg9TyXgPhDjw22ELWnWo8cMks91ypfCYRrENtk9Z0f1hS4sbiC7wpVKS8nbWKFucUmIssH/jJqvh8U+o25f4eF+LVoG5N5Q3dmXnJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776064; c=relaxed/simple;
	bh=llJWf7E52UaRuVBp8vMk5o7BrjMPo6L4nOTj/Sn3IHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWUTMip8lFAT7Ldas8J92XRJMi1GtMBZqXuyh7LugVohuzxz7XHEYrmLnXOOuYz0HG/th/epvHCLI7096+1Gl+or8yGGJy4Dvy0TlSQRVtRRwSDVC+f3fuiRyHsjxQHX4cVcNCcCFZoqds7MFzgun/V2BSSlBkEkWhm5kDgd0dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2byZoQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2byZoQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FF4C4CEF5;
	Wed,  3 Dec 2025 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776063;
	bh=llJWf7E52UaRuVBp8vMk5o7BrjMPo6L4nOTj/Sn3IHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2byZoQ7TDKoF3+bi21enWNHa1TMYz4xEAzlMpN99WrtSWFJPryVupBEX2Ex0Ys7/
	 9gdyqbf6Ce4AS0niGXm7dGXwChcYsQQA0lRMeed91wERDl+vQhM49prkMHkhbnnoWD
	 2APj9ApTSDgJjwQ8KoqekEMD+G2615drM8agU6wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/300] tools/power x86_energy_perf_policy: Enhance HWP enable
Date: Wed,  3 Dec 2025 16:24:26 +0100
Message-ID: <20251203152402.919279861@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 60917e32ec853..5c93546fc689b 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1077,13 +1077,18 @@ int update_hwp_request_pkg(int pkg)
 
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



