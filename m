Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37431F5F6;
	Tue, 11 Nov 2025 01:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823023; cv=none; b=F7vD0KYh0FrFaiMYnSkU9vVkhLWHI22k+//4TNqWHmeELZ7AD0bm8FhKotUyGqK36+hk7X+s3T/LQc8HkrFYmaIDbvg/p6Ci7iz5ZRGZRgxiMl24xcPxGnpTZXLuCepakL4ptvJnf61nKd+8Zpr+zkx4BsYRedlnOMah2iSN2EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823023; c=relaxed/simple;
	bh=PtLJsz1B1xw8G3UbUi+sV6BD3qIlV3N4cvwKdjWdU/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUIP52satCBdzs2ggSDhMyqAqFgcjJgB1mBr3CqtFHVpLMWvpNFSgWSbSrNwpgEFV3imK/WQ1h1zIA0AhXHFYU5Sj/kEJf6MZ+hKMsYm/a8VxPiN5fXpNyAc0m9aQBQqMIMrVAofgJMf5sBEayJjTnSTZeYYhYdqy987pKvvKcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpdOsyj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpdOsyj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45453C4CEFB;
	Tue, 11 Nov 2025 01:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823023;
	bh=PtLJsz1B1xw8G3UbUi+sV6BD3qIlV3N4cvwKdjWdU/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpdOsyj85AnBxaBvu4RcMXI7kZj9FxxgJQtAGWwqL1VZiaSTW1M92GZMjdzALJPrH
	 c0H9d9HDlwfyoGbGsHrAQhs50TwiOKhkO42+dUSwpzLec37unKLfsiaw12L3Ns1MV3
	 cw+q0RH32wKjPj5FABPsTxsSQ+lPqoBmKEuGDFK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 216/849] tools/power x86_energy_perf_policy: Enhance HWP enable
Date: Tue, 11 Nov 2025 09:36:26 +0900
Message-ID: <20251111004541.661779263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



