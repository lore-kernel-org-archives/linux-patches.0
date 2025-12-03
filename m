Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A99935BDC2;
	Wed,  3 Dec 2025 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779009; cv=none; b=mcrI5+f24qq9eAXCKtUD8aQc6XWBxAIlYO98zjmUFwy106scYHxlz3X2AJHv0q8b8tc4VeRaqj5n7paDNR3mCVyVQexUBcOb6Gq2B03ne7WUYnK8SdMpN+OxaTuyiVRAaif5/UXfGNx2O6ouEQe1CfF815Fg+8Oqzi/Qm/B/Jjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779009; c=relaxed/simple;
	bh=bDorHpYYb86eYqvv/ehxL77wprdbFb8dBoRbs3tNWgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHlMJDqPl1+JbiDzRrszaTJ4Rs7tqgH42/RNOBxvI8DQyoI5adJF5MJ3CizDj6C0r1l6YQvZoYx03tR+4UAO9j6ecXvZWmNuQA9h547wTxo7EMxBYgLr0BQ9BhGLexao/wlIRvi1xUwuHisRKvlku+PcoLNJUkIwbod5Cp7Sa1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pa4OJvqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa4OJvqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6437BC4CEF5;
	Wed,  3 Dec 2025 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779008;
	bh=bDorHpYYb86eYqvv/ehxL77wprdbFb8dBoRbs3tNWgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa4OJvqw0XdjNcxwPNRLT/aAPeB6lUm1fPnBWqv1UKEhDxmMvBzLHh0Uw8IOO8Uji
	 fSSl4EwbYdY2TrmC/W7iA/AO7ja2bMPcdyu3gMW+tD67tRJwm4FMjG4gLcHVCC+DH9
	 UodmVn1XN5ta5seIJCTLp1i+r8W6KvwaJPlQpKak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/568] tools/power x86_energy_perf_policy: Enhance HWP enable
Date: Wed,  3 Dec 2025 16:22:09 +0100
Message-ID: <20251203152445.380933972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



