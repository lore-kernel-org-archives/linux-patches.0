Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4541E7669;
	Tue, 15 Oct 2024 11:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992324; cv=none; b=RszUT5eC8QrNHanVsdQEsIOxt28EmMoEHM4SSrosJNYgf2armJlnMMXk494JRwYiypF73adrRAS7PCYkckcA3I7NlrJG419bsgPOdAO1coySy1w2/lSuIgjs2S4Uou0cs7FINMQyZFc1nEZ3z/x/TaPSXYjnEqJy2Ik75Oev0OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992324; c=relaxed/simple;
	bh=HM10kq5mm+L+xrxWNZHvfFzUS/xJSPAgekhlOs+yePg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caVhDqN6Nai7m+JTIHH4hcMDtkyzqFMXHHzssc8HaAAiVXmifFpaz+5hT/3STpxAOzTt6gI3iTksLpL8QISRTeQMIpjepf1lOFlj84sWo7RBRyen07hz1zqZwa8X1wMsu31LBNzvxoEqTpRe0EzeLVu3Oy2pr51PcusjOS/OSf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRACH1Z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRACH1Z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C063C4CEC6;
	Tue, 15 Oct 2024 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992324;
	bh=HM10kq5mm+L+xrxWNZHvfFzUS/xJSPAgekhlOs+yePg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRACH1Z1dfvRA0UMUKjnBWdAb8UmKc3pzlc94TFyymY41U8Pg6JNybdZPG4dIMwDd
	 5IXKbPEjOXKTb2KOOWY+E7eMIIFdiqs1adCj/0NtrH6pDcR2ZbXh10ecIb+hjBoIVU
	 7FqdfKjet/50HaXpHDRVxA+Yxt9JIRMmaIt+qjlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Roman Kisel <romank@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/691] x86/hyperv: Set X86_FEATURE_TSC_KNOWN_FREQ when Hyper-V provides frequency
Date: Tue, 15 Oct 2024 13:20:24 +0200
Message-ID: <20241015112443.374676641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 8fcc514809de41153b43ccbe1a0cdf7f72b78e7e ]

A Linux guest on Hyper-V gets the TSC frequency from a synthetic MSR, if
available. In this case, set X86_FEATURE_TSC_KNOWN_FREQ so that Linux
doesn't unnecessarily do refined TSC calibration when setting up the TSC
clocksource.

With this change, a message such as this is no longer output during boot
when the TSC is used as the clocksource:

[    1.115141] tsc: Refined TSC clocksource calibration: 2918.408 MHz

Furthermore, the guest and host will have exactly the same view of the
TSC frequency, which is important for features such as the TSC deadline
timer that are emulated by the Hyper-V host.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Roman Kisel <romank@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240606025559.1631-1-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240606025559.1631-1-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 8d3c649a1769b..3794b223fd69c 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -322,6 +322,7 @@ static void __init ms_hyperv_init_platform(void)
 	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {
 		x86_platform.calibrate_tsc = hv_get_tsc_khz;
 		x86_platform.calibrate_cpu = hv_get_tsc_khz;
+		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	}
 
 	if (ms_hyperv.priv_high & HV_ISOLATION) {
-- 
2.43.0



