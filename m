Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDCD26E160;
	Tue,  8 Apr 2025 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116830; cv=none; b=EbRr/5731sz1Yv6O7qfL5JK7H/CSzW7fILzA2ac8DYQ5RgAJbD+hXki+4Luu8QxqXJRStd48ORSEFSd2cwQYDz+2DiAQqpxNjeSZhhQRrUh4otUVlMoVFahox1slBFE4+Rb/N/R7AGFKueNWa5Y7ugmweV/v3ln/XQ0B7OGZua0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116830; c=relaxed/simple;
	bh=NAliwBkWI5spjA9y5Aym/m/RkmpOF0EFi5Q3feHsxHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQkaBfqWpg0HCsGgw7MGzJZ/ikGaK2NPzf2Ep8IKYG77Fev3H/ziWnJ+jSe5fddUYm9a0/5VKk3J2NuzhaZ3d3e7aA7GnepLHmPKAOsrjNHfTbRKKhJq2CwwSy66a1sWNvW1O8Bbmqph4r7aP+efhsGx+O5rdiQk6HYlf0Mw4sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2Hc39Wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2Hc39Wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB11C4CEE5;
	Tue,  8 Apr 2025 12:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116830;
	bh=NAliwBkWI5spjA9y5Aym/m/RkmpOF0EFi5Q3feHsxHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2Hc39WjutLAUNdwF2aVqaloGlA6J9Vx4kkhKJLy4fAb0KPUukkXsv7oe9nFD/0j3
	 cUrrXw2+/kskR/ZfK2+jeIKssnMOr032ePNxhE0CgVf+NYzHuhx9pDWxa+vNvHIrdE
	 T4buO1LD1ockp5r6St4WTH62PLYU9TG+o6oh2ROQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Roman Kisel <romank@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/423] x86/hyperv/vtl: Stop kernel from probing VTL0 low memory
Date: Tue,  8 Apr 2025 12:50:10 +0200
Message-ID: <20250408104852.391381085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



