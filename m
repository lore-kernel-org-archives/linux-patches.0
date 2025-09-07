Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426FD528;
	Sun,  7 Sep 2025 20:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276677; cv=none; b=VhHcKvmY0yieZ/OEysrPKArsdDJSC9NKEu7UMafUEIJOtcH5ScaIhHW4j2Na6pgHZXJVCx5i4Mps6G0qPQ4nEZhLa8roz41ZcuJ1oJHVEpYTGEjHvi6+dtABpNB9Ua8X26iK+/vWlhVT9lpdgxYVJ85lDjLGUq6WDNAEFsmbNBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276677; c=relaxed/simple;
	bh=nI3J0IfCdnm8eF4TyofpQioqee/GYR/gJPLWb9A4alU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3BcnNRJ6/NyMpKJYo2MWVQO+7CWKekvW4h627ALX+uoCeM7DuK4uvoSS1gSiyPcqAnY/xaqm5hegxhXxxHZBgnJzK2JOL7YvCh1MxxNerEk1AkO2v6MoSLomGxYFR4yXcqovYIMpqR2gnow2nuRls8I2qTachK1txhkxlS54Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeUJIsKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeUJIsKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0BDC4CEF0;
	Sun,  7 Sep 2025 20:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276676;
	bh=nI3J0IfCdnm8eF4TyofpQioqee/GYR/gJPLWb9A4alU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeUJIsKiwBHwjX8ueQtBt5CPsOF+cwjG5ROz62URl0HCT9hd2J2Z79xiUr7UtXMv1
	 nOfMxIR+pE9FONYag6qeHFxtm1vkcFeT9zYf7L1y3Nb72UKXI6qM4lh97XhmuUMY38
	 SlwrR5UgDF13NUjkVVvppZb7BEZUFdeh+rXhOSmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/121] cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode
Date: Sun,  7 Sep 2025 21:58:31 +0200
Message-ID: <20250907195611.760814741@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit ac4e04d9e378f5aa826c2406ad7871ae1b6a6fb9 ]

When turbo mode is unavailable on a Skylake-X system, executing the
command:

 # echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

results in an unchecked MSR access error:

 WRMSR to 0x199 (attempted to write 0x0000000100001300).

This issue was reproduced on an OEM (Original Equipment Manufacturer)
system and is not a common problem across all Skylake-X systems.

This error occurs because the MSR 0x199 Turbo Engage Bit (bit 32) is set
when turbo mode is disabled. The issue arises when intel_pstate fails to
detect that turbo mode is disabled. Here intel_pstate relies on
MSR_IA32_MISC_ENABLE bit 38 to determine the status of turbo mode.
However, on this system, bit 38 is not set even when turbo mode is
disabled.

According to the Intel Software Developer's Manual (SDM), the BIOS sets
this bit during platform initialization to enable or disable
opportunistic processor performance operations. Logically, this bit
should be set in such cases. However, the SDM also specifies that "OS
and applications must use CPUID leaf 06H to detect processors with
opportunistic processor performance operations enabled."

Therefore, in addition to checking MSR_IA32_MISC_ENABLE bit 38, verify
that CPUID.06H:EAX[1] is 0 to accurately determine if turbo mode is
disabled.

Fixes: 4521e1a0ce17 ("cpufreq: intel_pstate: Reflect current no_turbo state correctly")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -594,6 +594,9 @@ static bool turbo_is_disabled(void)
 {
 	u64 misc_en;
 
+	if (!cpu_feature_enabled(X86_FEATURE_IDA))
+		return true;
+
 	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
 
 	return !!(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);


