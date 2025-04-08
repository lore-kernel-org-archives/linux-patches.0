Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691A264FA0;
	Tue,  8 Apr 2025 11:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113497; cv=none; b=DCm/ACzLZjvIJ6dyxHQHE8lgPpGM4QCHOzYt5Ru9LzhPcFlm2a4C0HznxCAcltAIT01qCS5hYPLZNnRTR7hv0VxJjBM3fO8bQvETo3foTIfs6A4LiS/ByJ+7N/uWac4ZTxx9hsaqI0JlJDhp4WNpN64ESsLkDpzy5M3VTkGIwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113497; c=relaxed/simple;
	bh=mtApRLkF+PDdsSWlDBY0V5AuWOzKlNBegEr+XbIt2Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqeSPDB8f5sik5lV4O3RJN1DBs+8pZhapksGa+hVkZhSTDCA9dEyd6bza4h3vAAiUV5KsZX28Dk5fTPfSge+VRg6aTCno/HRFN5xwe8C/oA2YDnoedg4YYF4048FmJVucjYknre3orlL62GsXaEeoE7cGvBvUEiqXrLjqp36BUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSmA9wJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSmA9wJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E389FC4CEE5;
	Tue,  8 Apr 2025 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113497;
	bh=mtApRLkF+PDdsSWlDBY0V5AuWOzKlNBegEr+XbIt2Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSmA9wJUxk08BE8uNTy1nfTxc29NVPmX80O0AnSXyOg2Yzp6IEyxtriC0TAsTv4w3
	 mUR2dc3JEywAqcvx8Lae2cBPie5O1pC1eog73DNdz0PouMNAZoO4UtZihq2QRcSvpy
	 vuTC/stefAXfbZqDcz4nXus3zkWXHuleilNQHrxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Roman Kisel <romank@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/268] x86/hyperv/vtl: Stop kernel from probing VTL0 low memory
Date: Tue,  8 Apr 2025 12:49:51 +0200
Message-ID: <20250408104833.398261262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index c2f78fabc865b..b12bef0ff7bb6 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -30,6 +30,7 @@ void __init hv_vtl_init_platform(void)
 	x86_platform.realmode_init = x86_init_noop;
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 	x86_init.timers.timer_init = x86_init_noop;
+	x86_init.resources.probe_roms = x86_init_noop;
 
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
-- 
2.39.5



