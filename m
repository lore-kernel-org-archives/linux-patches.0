Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE782361640;
	Thu, 20 Aug 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238271; cv=none; b=GKUtD8syKuTddG2ZFX5cc5qzeClm71u4CTiNJ7a52Mgt1hT1xdrKVdYV9udSJDZISJ0MA9qadAr1Ut8P6Tjr09/8v+dVXLNvEdc18qYEDlgECiUc0JsVtGH8hu94ffdiwItIT4NdQ/wyEiG/l1DEVyL31EwvsCpelq3ypiD33mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238271; c=relaxed/simple;
	bh=tkgRVmqVOZuoGeQz9hB43XpftlVB0q3zUTGSkOE1XCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWh/9AJa3GFGJYzWinUFyvasGKtJv5hL9BnU7ZC0fW+UtEyPofgVQ2rQdtCB4zBgYoW6pUQyFexchWbknM9QhbBXLCM73lhp/cZZvgIpR+DnHsbHznpTVXw8lPE4ezq8CYN65C5lZb/7aQ7Of2KJP9+QYMCRQaQwpU4W+VHR8Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8UhdF8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8UhdF8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3251F000E9;
	Thu, 20 Aug 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238270;
	bh=aKPtz4wmslM7QjIAj+pohGkdzsIVkGuYEMBHjpnpqaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8UhdF8Z3cwBsoRTe8PMd9LtGaaM5jG/pjIkMvwo36l4TnrAu8F3+DkRhGwm1q4s2
	 MKBFVBUnPDtekrhY/F7/ej7mHQayhRXP+l93nlVLKPuHryyAY08luUGwL8qOIN+7PD
	 z+08YBNROWW5yrxNCK+MM0qCGiRmwDOsyudzdse0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 088/228] riscv: hwprobe: Register unaligned probes before usermode
Date: Thu, 20 Aug 2026 16:53:50 +0200
Message-ID: <20260820145247.332852625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

commit 994dad686e755477e2b2700cca4e6e1a90a58bdc upstream.

The hwprobe vDSO data is populated by the first riscv_hwprobe syscall.
Some values, such as MISALIGNED_VECTOR_PERF, may depend on the async
vector unaligned access speed probe registered by
check_unaligned_access_all_cpus().

That initcall currently runs at late_initcall level. However,
rootfs_initcall enables usermode helpers before late initcalls run, so an
early helper can execute userspace and call riscv_hwprobe first.

In that case complete_hwprobe_vdso_data() consumes the initial
pending_boot_probes reference, populates the vDSO cache, and marks it
ready before the later async probe is registered. The eventual probe
result then cannot update the already-ready cache.

Move check_unaligned_access_all_cpus() to fs_initcall_sync. This still
runs after clocksource_done_booting(), so the ktime_get_mono_fast_ns()
benchmark uses a stable clocksource, but it runs before rootfs_initcall
enables usermode helpers.

Any async hwprobe probe is therefore registered before userspace can
trigger the one-time vDSO cache population.

Cc: stable@vger.kernel.org
Fixes: 6455c6c11827 ("riscv: Clean up & optimize unaligned scalar access probe")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20260721150511.1607105-1-qirui.001@bytedance.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/unaligned_access_speed.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -436,4 +436,10 @@ static int __init check_unaligned_access
 	return 0;
 }
 
-late_initcall(check_unaligned_access_all_cpus);
+/*
+ * Run after clocksource_done_booting() so measure_cycles() uses a stable
+ * clocksource, but before rootfs_initcall() enables usermode helpers. Those
+ * helpers can reach hwprobe and populate the vDSO cache, so async hwprobe
+ * probes must be registered first.
+ */
+fs_initcall_sync(check_unaligned_access_all_cpus);


