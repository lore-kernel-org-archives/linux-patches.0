Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAA53074B2;
	Mon,  1 Dec 2025 11:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588427; cv=none; b=XTGYCX1gxDOJj0h1k6WP1PR3vOYCL+UCGZaSUXSH9jdd3pTPU+zMU+6fWcl/Bx4/uJmPE2e7n6+lylUogfsl+bJfFYa/6aesQQweHZJ+2L3uFD5TX/wFkunV1etlS6xre1QK/plusEAueFRIPmbw5BfKh6qkW3OChQvcyWfVWtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588427; c=relaxed/simple;
	bh=idbaHqkRFdeSoATpMNVbdqVDU0e90qbzHi4i0J1FmLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLrb6IFY4Nd9T2K3+IY3NfaIuKRc24BFyPT0HnhKZWmoJSqikzsJPgLarQB+8SOUhYWB+P0oaCok1Fe9FASuSP3UnQ4CfJ1VbFWpCrXOs19nSEsjfg3zBwcdwbQwuLfO+mFYkOWI3SIoZXOBcnqgzB4YUDK/WQwbaxxbe4JMUak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y27aXKG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y27aXKG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B141C4CEF1;
	Mon,  1 Dec 2025 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588427;
	bh=idbaHqkRFdeSoATpMNVbdqVDU0e90qbzHi4i0J1FmLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y27aXKG4TbENA9ifHb8vXfHVYVrlXCT/5Yy97zEir3UcXx/4LL7tX1v3LUQcZfDgf
	 5qZCxov/0e9zNV4mSryVnDl16UmEYUgJcB9LbKAA1uhKe+Rn0y8OGeP+ChzVMrRAZF
	 tvAnr3QsHeBY5+7rScu8EsvpQ9MWZJrHLdXBnh3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/187] tools/power x86_energy_perf_policy: Enhance HWP enable
Date: Mon,  1 Dec 2025 12:22:31 +0100
Message-ID: <20251201112242.805162081@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 165eb4da8a644..0cb17e13c002b 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1024,13 +1024,18 @@ int update_hwp_request_pkg(int pkg)
 
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



