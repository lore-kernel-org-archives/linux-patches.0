Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687CA1D5AD7;
	Wed,  6 Nov 2024 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895080; cv=none; b=oqNHUYbj6gizTDBuDe8hK4nePijJTJfgPI9Ukc2IwB69wnZvGjNPN33ALMc5KCNwQVXuhcQr0FE38rv5mgg3NzlEEpJjFKzf6v5MZLHg2fjyhFP3pzpIJk6csMnntbZgHOZXQdTQKPPNsxz1B6JBoJTkqYjoWfMTkDHMjiTN/wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895080; c=relaxed/simple;
	bh=Yb6ncp7+FsL1ysVudR8RLHX5FISMZiSLW6gxgo4AqoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+BqsTjPyNVsirH9x5hFMts0GeGkB/8kkSa3IjawmMpGC7lOJeCY1E7t3i3QznwaEm4EmU0ZZZFBQO4SY+CJF+fkA2XTmsjMsq0mY1zALPOjPmWT+4PPeC3/8rLFi8RmOxx7Sc2Yz9PCe3Sqt8gYND80L1MgyKIE56ZzxZXeL/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itrpvckz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itrpvckz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D04C4CECD;
	Wed,  6 Nov 2024 12:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895080;
	bh=Yb6ncp7+FsL1ysVudR8RLHX5FISMZiSLW6gxgo4AqoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itrpvckz5rkHwIzMpG/wYSL9N/lpqELsvVPQ6obp81iRZ4wAfCNsHyuC3N3sRs9Xe
	 JEp2sXHO3IZwKyGX+mhw2pgms8lTkXSSGqz6Ak/aJfAvc8tQhUUAKX3oeqLltYUf+4
	 Oad7Vc4+VRtnFqgdhay/y4OHntzx3Vqrx/vF9iyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/350] coresight: tmc: sg: Do not leak sg_table
Date: Wed,  6 Nov 2024 13:00:27 +0100
Message-ID: <20241106120323.349055109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit c58dc5a1f886f2fcc1133746d0cbaa1fe7fd44ff ]

Running perf with cs_etm on Juno triggers the following kmemleak warning !

:~# cat /sys/kernel/debug/kmemleak
 unreferenced object 0xffffff8806b6d720 (size 96):
 comm "perf", pid 562, jiffies 4297810960
 hex dump (first 32 bytes):
 38 d8 13 07 88 ff ff ff 00 d0 9e 85 c0 ff ff ff  8...............
 00 10 00 88 c0 ff ff ff 00 f0 ff f7 ff 00 00 00  ................
 backtrace (crc 1dbf6e00):
 [<ffffffc08107381c>] kmemleak_alloc+0xbc/0xd8
 [<ffffffc0802f9798>] kmalloc_trace_noprof+0x220/0x2e8
 [<ffffffc07bb71948>] tmc_alloc_sg_table+0x48/0x208 [coresight_tmc]
 [<ffffffc07bb71cbc>] tmc_etr_alloc_sg_buf+0xac/0x240 [coresight_tmc]
 [<ffffffc07bb72538>] tmc_alloc_etr_buf.constprop.0+0x1f0/0x260 [coresight_tmc]
 [<ffffffc07bb7280c>] alloc_etr_buf.constprop.0.isra.0+0x74/0xa8 [coresight_tmc]
 [<ffffffc07bb72950>] tmc_alloc_etr_buffer+0x110/0x260 [coresight_tmc]
 [<ffffffc07bb38afc>] etm_setup_aux+0x204/0x3b0 [coresight]
 [<ffffffc08025837c>] rb_alloc_aux+0x20c/0x318
 [<ffffffc08024dd84>] perf_mmap+0x2e4/0x7a0
 [<ffffffc0802cceb0>] mmap_region+0x3b0/0xa08
 [<ffffffc0802cd8a8>] do_mmap+0x3a0/0x500
 [<ffffffc080295328>] vm_mmap_pgoff+0x100/0x1d0
 [<ffffffc0802cadf8>] ksys_mmap_pgoff+0xb8/0x110
 [<ffffffc080020688>] __arm64_sys_mmap+0x38/0x58
 [<ffffffc080028fc0>] invoke_syscall.constprop.0+0x58/0x100

This due to the fact that we do not free the "sg_table" itself while
freeing up  the SG table and data pages. Fix this by freeing the sg_table
in tmc_free_sg_table().

Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
Cc: Mike Leach <mike.leach@linaro.org>
Cc: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20240702132846.1677261-1-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 8f850c22be418..99344e9daf5db 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -222,6 +222,7 @@ void tmc_free_sg_table(struct tmc_sg_table *sg_table)
 {
 	tmc_free_table_pages(sg_table);
 	tmc_free_data_pages(sg_table);
+	kfree(sg_table);
 }
 
 /*
@@ -302,7 +303,6 @@ struct tmc_sg_table *tmc_alloc_sg_table(struct device *dev,
 		rc = tmc_alloc_table_pages(sg_table);
 	if (rc) {
 		tmc_free_sg_table(sg_table);
-		kfree(sg_table);
 		return ERR_PTR(rc);
 	}
 
-- 
2.43.0



