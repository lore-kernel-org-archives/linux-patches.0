Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A70126A0A7;
	Tue,  8 Apr 2025 12:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115054; cv=none; b=PdW/bc74eTpaekJtBsPbtpzd5rYyFgzClBGtEiPmpet50bnwbIZTA8HV535iI80/0C+hAp8+wyL+0aEuq95CoVNwwiomJ2ZEZFLpdDrxiU/RpU+k5oupPICVZXKwPrO77mkX8xVTic1AJXfteieJz9+tYTt4cu5kWRLFeidp88U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115054; c=relaxed/simple;
	bh=g+fiB9nnpM1Xl0QJJ7Q/eoLvhCRStzWTgbxqGl0Sj2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfTqChV97eZ7zHU4O2QyBeRh5zl3Zmdz/CMS8VcBtuwJ17P2LTjjr6pVo9MnHSUtokyTtB2a+LoKwspFXAQVKwWoOOM0j4oF/B1BcOooEs2eBcW42E9l30Un4HKoAoSy656x/eBBMUR7NcCk3aWE2ZmLv4t0vz/vdj+7lhQHP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLT8eVr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLT8eVr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E09C4CEE5;
	Tue,  8 Apr 2025 12:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115054;
	bh=g+fiB9nnpM1Xl0QJJ7Q/eoLvhCRStzWTgbxqGl0Sj2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLT8eVr98Sxl99mUwLYlB0IlhabCU/WK4r6oxjo4Wxa6oq5SeENj0cqdNVklz2YsE
	 Icb6imc28GCm1uYI3hRsWM+rPDNDycpPxFYbJ7fr+062BniYfwSPckVbzGlhALL3p3
	 28O6DIx6NWjEA9EEMAG3oKpWGLlGBTGXTu4PnhOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Roman Kisel <romank@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 331/499] x86/hyperv/vtl: Stop kernel from probing VTL0 low memory
Date: Tue,  8 Apr 2025 12:49:03 +0200
Message-ID: <20250408104859.481244546@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

[ Upstream commit 59115e2e25f42924181055ed7cc1d123af7598b7 ]

For Linux, running in Hyper-V VTL (Virtual Trust Level), kernel in VTL2
tries to access VTL0 low memory in probe_roms. This memory is not
described in the e820 map. Initialize probe_roms call to no-ops
during boot for VTL2 kernel to avoid this. The issue got identified
in OpenVMM which detects invalid accesses initiated from kernel running
in VTL2.

Co-developed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Tested-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Roman Kisel <romank@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250116061224.1701-1-namjain@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250116061224.1701-1-namjain@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_vtl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 04775346369c5..d04ccd4b3b4af 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -30,6 +30,7 @@ void __init hv_vtl_init_platform(void)
 	x86_platform.realmode_init = x86_init_noop;
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 	x86_init.timers.timer_init = x86_init_noop;
+	x86_init.resources.probe_roms = x86_init_noop;
 
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_mptable = x86_init_noop;
-- 
2.39.5



