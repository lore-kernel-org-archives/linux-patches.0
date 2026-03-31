Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2A3E3C5C;
	Tue, 31 Mar 2026 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974964; cv=none; b=pLiWJAnhCqG+Fs5mQZSzy7ctzgjS5QotL4CWSpVqa2c25yu21XEibeQoxp6aE53DEuiEvcyZHreLhSuPw/6OM7TeFEn5JG5nei3jg70FBDVGrT6s2J6wj69zrfWkec3jc/lruSL8f3MNnNeB6VKRXd/DrUEEr9rmLMIiDgopbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974964; c=relaxed/simple;
	bh=9FAenaRN4pmnAuwk01WWsuc0HiG4ox1M0c1uaRy4X7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIoM3ZfmdnQcW57wcklLEFz+T7eTOW0pTgK6D0sjW1DLoX1qfdxyaxA8/YWLO9RrjsuDl2oh3o2HxQklBengin0QeWE8TiZVCUEyvztNhR654Utrb0kxRza/hn0DVTOyH+9bau5QdiPae1d88RnHGmVqvClKQtiICsbgMvn/E9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rx+MFVnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rx+MFVnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A8BC19423;
	Tue, 31 Mar 2026 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974963;
	bh=9FAenaRN4pmnAuwk01WWsuc0HiG4ox1M0c1uaRy4X7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rx+MFVnKb0gpShx0qUxN6h0xHp5aBhJIjT2BlF+8yHkaabDq6fX1M85Ubw4uYWkr6
	 EbrQx8dtwT1mMYnv/YrPhMp8jWWEEP5J+S/9NVJT2Y3y0d3Scu6lRBeuIugH9j0rAT
	 xopbFo706uHGh82z7N9iYGAj4Fqehwj3hZizheTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 111/342] platform/x86: ISST: Check HWP support before MSR access
Date: Tue, 31 Mar 2026 18:19:04 +0200
Message-ID: <20260331161803.097551529@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9f11d9b15efb5f77e810b6dfbeb01b4650a79eae ]

On some systems, HWP can be explicitly disabled in the BIOS settings
When HWP is disabled by firmware, the HWP CPUID bit is not set, and
attempting to read MSR_PM_ENABLE will result in a General Protection
(GP) fault.

  unchecked MSR access error: RDMSR from 0x770 at rIP: 0xffffffffc33db92e (disable_dynamic_sst_features+0xe/0x50 [isst_tpmi_core])
  Call Trace:
   <TASK>
   ? ex_handler_msr+0xf6/0x150
   ? fixup_exception+0x1ad/0x340
   ? gp_try_fixup_and_notify+0x1e/0xb0
   ? exc_general_protection+0xc9/0x390
   ? terminate_walk+0x64/0x100
   ? asm_exc_general_protection+0x22/0x30
   ? disable_dynamic_sst_features+0xe/0x50 [isst_tpmi_core]
   isst_if_def_ioctl+0xece/0x1050 [isst_tpmi_core]
   ? ioctl_has_perm.constprop.42+0xe0/0x130
   isst_if_def_ioctl+0x10d/0x1a0 [isst_if_common]
   __se_sys_ioctl+0x86/0xc0
   do_syscall_64+0x8a/0x100
   entry_SYSCALL_64_after_hwframe+0x78/0xe2
  RIP: 0033:0x7f36eaef54a7

Add a check for X86_FEATURE_HWP before accessing the MSR. If HWP is
not available, return true safely.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260303074635.2218-1-lirongqing@baidu.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 13b11c3a2ec4e..e657b88bfd36e 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -558,6 +558,9 @@ static bool disable_dynamic_sst_features(void)
 {
 	u64 value;
 
+	if (!static_cpu_has(X86_FEATURE_HWP))
+		return true;
+
 	rdmsrq(MSR_PM_ENABLE, value);
 	return !(value & 0x1);
 }
-- 
2.51.0



