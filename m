Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A713491F3;
	Fri, 21 Nov 2025 14:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733607; cv=none; b=km0ZP2Io5kr58JK0emQm1ShtuTSe2EwffT1Jl19DtxYRooJGDf4HARxeVIR58TRF79TAGtty8Ram9vHwucOsfQYdTdCSYOvHGfDWXzKu/6hHAfZacZ5IPABLiVsuy+VIY1r9uCctULpGkqg4qmEyZY8BvzkASwEZt9iMVciX8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733607; c=relaxed/simple;
	bh=V+VaxAIcuKEj58mLY/t0ZzNZZEX5mYYeykpcYmZiXd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V52nWBrtw4YmScAsqfenAXMX1G/rrAZCoZDbVRVZImS8YblkAv88G88LGXM1Ccl7ILiSOQuprxcQoLU5iP6ZJlonys8gCeNbbPeSbxCRe5q9TVpw3IOtMEDWOQIJFHR9WaPXsiSP+OjYgCWyjghxq3aOY54c5qCDriULVK2qc1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZjIH7CZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZjIH7CZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B03C4CEF1;
	Fri, 21 Nov 2025 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733607;
	bh=V+VaxAIcuKEj58mLY/t0ZzNZZEX5mYYeykpcYmZiXd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZjIH7CZWTvg1y4KN2t7IJBqfrAugJZa6L++uM4vjbMR3q0FTy4rpCXxW6xoTX0gn
	 iGeRzzuVQVtFTnioYqSRFWpmtUwghY/S7ouw5E7tgKwT73rTMo5961Os0MWPLAC3yH
	 jMrIaVRuL4OtVm6g8lYGr1LYqFT/YEMPelS2pktw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Waiman Long <longman@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 525/529] memory tiers: use default_dram_perf_ref_source in log message
Date: Fri, 21 Nov 2025 14:13:44 +0100
Message-ID: <20251121130249.726357469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Huang <ying.huang@intel.com>

commit a530bbc53826c607f64e8ee466c3351efaf6aea5 upstream.

Commit 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
added a default_dram_perf_ref_source variable that was initialized but
never used.  This causes kmemleak to report the following memory leak:

unreferenced object 0xff11000225a47b60 (size 16):
  comm "swapper/0", pid 1, jiffies 4294761654
  hex dump (first 16 bytes):
    41 43 50 49 20 48 4d 41 54 00 c1 4b 7d b7 75 7c  ACPI HMAT..K}.u|
  backtrace (crc e6d0e7b2):
    [<ffffffff95d5afdb>] __kmalloc_node_track_caller_noprof+0x36b/0x440
    [<ffffffff95c276d6>] kstrdup+0x36/0x60
    [<ffffffff95dfabfa>] mt_set_default_dram_perf+0x23a/0x2c0
    [<ffffffff9ad64733>] hmat_init+0x2b3/0x660
    [<ffffffff95203cec>] do_one_initcall+0x11c/0x5c0
    [<ffffffff9ac9cfc4>] do_initcalls+0x1b4/0x1f0
    [<ffffffff9ac9d52e>] kernel_init_freeable+0x4ae/0x520
    [<ffffffff97c789cc>] kernel_init+0x1c/0x150
    [<ffffffff952aecd1>] ret_from_fork+0x31/0x70
    [<ffffffff9520b18a>] ret_from_fork_asm+0x1a/0x30

This reminds us that we forget to use the performance data source
information.  So, use the variable in the error log message to help
identify the root cause of inconsistent performance number.

Link: https://lkml.kernel.org/r/87y13mvo0n.fsf@yhuang6-desk2.ccr.corp.intel.com
Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Waiman Long <longman@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-tiers.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -649,10 +649,10 @@ int mt_set_default_dram_perf(int nid, st
 		pr_info(
 "memory-tiers: the performance of DRAM node %d mismatches that of the reference\n"
 "DRAM node %d.\n", nid, default_dram_perf_ref_nid);
-		pr_info("  performance of reference DRAM node %d:\n",
-			default_dram_perf_ref_nid);
+		pr_info("  performance of reference DRAM node %d from %s:\n",
+			default_dram_perf_ref_nid, default_dram_perf_ref_source);
 		dump_hmem_attrs(&default_dram_perf, "    ");
-		pr_info("  performance of DRAM node %d:\n", nid);
+		pr_info("  performance of DRAM node %d from %s:\n", nid, source);
 		dump_hmem_attrs(perf, "    ");
 		pr_info(
 "  disable default DRAM node performance based abstract distance algorithm.\n");


