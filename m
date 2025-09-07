Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF53914BFA2;
	Sun,  7 Sep 2025 20:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276332; cv=none; b=J9QRIozdOGf08+tmKB1VmUW/qRVgmxrsBR7+NCWteJoJgyzeZ9rVFZCh1En6iyYww63/DP1mIvl7oigH002eD6sgbpnx2eHFwGS8cXrFm8NpmtRo7dLVN30SQeAASfiOD0F95EY1TkkG9jSgb0lgd6DRPqgiF3eKdc5FsE6X4DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276332; c=relaxed/simple;
	bh=X7YoYod6HqTF9kWC1LtHPtXIurCG9pIKDTnHUDe40CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us3nF90b8bmxhxig5UKuO7+8jLE0AfSSfyohvp4H05tU1xKQ/gTA+W3XiBnP0FA24FMg8TpptC4ftGkqRB8LO0dhZAf/lO5USbS7Ltq8eWbMn61DEtw6NWdlzFSXI59QZXqZjVPS5YvkPWJ9gNX0h7YlnPDvAKkN/oyhpOaxLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNaENlEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNaENlEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6300AC4CEF0;
	Sun,  7 Sep 2025 20:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276331;
	bh=X7YoYod6HqTF9kWC1LtHPtXIurCG9pIKDTnHUDe40CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNaENlEGKTZ6JAUWqv5aqmx8OyO8jwqevmCzC9IuPn/tuJYUcdXo9Tk0naPHxqUl2
	 n3flG2AhyyTMuZTOBQ0yDU+3ai2pPuY2/Mx2MMmLRvT5aSBelu3couBC6SSHhRjnC8
	 tvyJlorZX/gngCUGI5+G60iCvU8g9wGMbUikPt5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/104] cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode
Date: Sun,  7 Sep 2025 21:58:29 +0200
Message-ID: <20250907195609.548509911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -561,6 +561,9 @@ static bool turbo_is_disabled(void)
 {
 	u64 misc_en;
 
+	if (!cpu_feature_enabled(X86_FEATURE_IDA))
+		return true;
+
 	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
 
 	return !!(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);


