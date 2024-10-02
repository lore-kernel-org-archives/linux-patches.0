Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E301A08A4;
	Wed,  2 Oct 2024 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880161; cv=none; b=XO4U56GCvQAUqUS9uRVHamNlLzoMlJHyUIGKOfOczfcBRs4as/eRtxrQb7ABYd3fmOKbX+19YY/Vn2JGxbZ1fxdO7kBMYXoU2YL0osbTsd7V70JA1xqwFvIr8b01xCKMk7U3xB0TLwjXr3AZWhn0M0Wev5hJTt6nWJNh+yh1/r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880161; c=relaxed/simple;
	bh=+32ao5fuwwFVzb4B+DGvu67ccmSQrX9IootC+0RRX5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSckHWKxjOM5qaPnCc4ZCbr586gzsKMfUMNncJlZzFdqjMQg3hmZqTT+LodD/Mf5uAlrQWESaTAlzO/3f9453H6H5Ds5GZLhpY2I3Kez3igiFCac61bZAnC0gViT8uhaeaGnPtTaYgTkPQ8QMcBdRMd/M7RbSaAQNnb0VyMXecE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0ndeXDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0ndeXDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0836C4CEC2;
	Wed,  2 Oct 2024 14:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880161;
	bh=+32ao5fuwwFVzb4B+DGvu67ccmSQrX9IootC+0RRX5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0ndeXDFVVbzTczbsMJzbnGdCssJU/3NsDLYuss5Jz0/vMbsSfzUjXG8ogYkbtlzw
	 GFzu4uk4gtbDx7upFXurjOz+v3v93DC8WJ8thOXgVB+KKlfom0FpPB7ZFRYTzczZfK
	 TxHOgIza6Y2lHuufoyVhLrrFtC6aK4vTKIbkQnPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 363/538] coresight: tmc: sg: Do not leak sg_table
Date: Wed,  2 Oct 2024 15:00:02 +0200
Message-ID: <20241002125806.754758750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8311e1028ddb0..f3312fbcdc0f8 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -255,6 +255,7 @@ void tmc_free_sg_table(struct tmc_sg_table *sg_table)
 {
 	tmc_free_table_pages(sg_table);
 	tmc_free_data_pages(sg_table);
+	kfree(sg_table);
 }
 EXPORT_SYMBOL_GPL(tmc_free_sg_table);
 
@@ -336,7 +337,6 @@ struct tmc_sg_table *tmc_alloc_sg_table(struct device *dev,
 		rc = tmc_alloc_table_pages(sg_table);
 	if (rc) {
 		tmc_free_sg_table(sg_table);
-		kfree(sg_table);
 		return ERR_PTR(rc);
 	}
 
-- 
2.43.0



