Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037267;
	b=KiMAidL0DbY7roJmx6TkMkjyM2KNpgTalp3MHMGPTqMnZudQPAWirAQGgdEwbi80Ohh6
	 0UC4Yg9O9+lhCAdcPCzxAjc7y9t+/gdyacW5tXr7xDCJnpYo6Bf7nIZyG46AATxe1bzs5
	 dBAxbie5HL86dOYUIAajnHjbe+hAy64nVqlG51bm13L/fbr8uXFOZq5xIBw4qi2wrxNrH
	 rxBzGRYmLavpX0yILYE09ZuOMpDrsSdneAQJx49Lp3aMdAenOsJ3fQsQo+dPf9s4woWoJ
	 oEwJkORpREvlBulCrVMvje16XPe36j3jVLDIPWEDen8dzAn+wL9Ig3UOYXbMEk8lkBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gflbHAfbjNVyb5jMmONh+ZD7d74AoNSPyML7HiuEKfE=;
	b=cQTte4Xt/Ba9LSPyBwVqEq1NSMokh/P9IYAPPXJetH/h+o/uuAqBC+2I4uWHI9r0Ze5v
	 SmPja/NsiKPg9orQHxfcjTaHPVLzbkOnRQWousH/d5pINAWGgEQT3j0lkg2M+JDzH9yMS
	 lzdYgIwWHoVk3RP3YkG5L+Lfs6CzSQmxhfz6z9evUXc8kUeb78pZBlM092ImhYcjWNBAc
	 dw78j5ZStLcQox4q6oAfWNXRidYj5v+WBMUoHyMUxeIC6DsIwsuiYwObI5H6mCgyfhKKL
	 FEN8P8zYO6Nugm14xIexRYUyO9flBRj59mN6iQwnvfeujZAH/1pW99qo5fIZnyHTscg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNW+mDj5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388C606A31C;
	Wed, 18 Nov 2026 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNW+mDj5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0707D1F000C4;
	Wed, 18 Nov 2026 21:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037267;
	bh=gflbHAfbjNVyb5jMmONh+ZD7d74AoNSPyML7HiuEKfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNW+mDj5E2BOHBBOs4+mFFp5aUGklgQoBhxlfRLuKi7+OIZNdcMjbEt6CQIdHOJwf
	 8SGlbfev/1pO+Oe0Il3Ta8zmnERnxTqlRkEoioCEghie1n7SHaqUXWvu5zPIjd8N79
	 2nLeUhyvJZrsbKPHlIbaoS53XKhmjVIYYVsGMYuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1349/3318] ACPI: CPPC: Propagate errors from cross-CPU FFH calls
Date: Wed, 18 Nov 2026 15:32:51 +0100
Message-ID: <20261118150400.871395703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 36e96b469da24868f727b4cd168d7cf01cbd163d upstream.

The arm64 and RISC-V CPPC FFH accessors ignore the return value of
smp_call_function_single(). If the target CPU is offline, the call can
return -ENXIO without running the callback. The accessors then consume
callback output which was never initialized and may report success.

CPU offlining leaves the CPU's CPPC sysfs attributes present. On arm64,
the AMU feature mask does not exclude an offline CPU, so a paired counter
read can expose uninitialized stack values through feedback_ctrs. RISC-V
has the same problem in both SBI and CSR reads, and its write paths also
inspect an uninitialized callback status after a failed cross-CPU call.

Return the SMP call error before using callback output. The arm64 single
and paired counter readers already check the helper's return value. For
RISC-V, also check the callback status before copying a read value: an
unsupported CSR sets the error but does not initialize the value.

Fixes: 68c5debcc06d ("arm64: implement CPPC FFH support using AMUs")
Fixes: 30f3ffbee86b ("ACPI: RISC-V: Add CPPC driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-18-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 16d99723982a7..42618823e198a 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -291,9 +291,7 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
 
-	smp_call_function_single(cpu, func, val, 1);
-
-	return 0;
+	return smp_call_function_single(cpu, func, val, 1);
 }
 
 /*
-- 
2.53.0



