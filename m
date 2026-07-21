Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B694269D18;
	Tue, 21 Jul 2026 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660083; cv=none; b=nvhLAcKHPqUPlGAxulB/q1IfVyPoIf3fb2sP+c/siLt2mBOFQyDkuu664qsS6Bvxv+Q5UtcbaSwxW+/8Y41+7HqpAvswRaQXiAATh9SCOpfOD+EC0w997sWyidG+45p1zmUKPXyX9hPzZ1ZQvwTFGqBx07mOPuLLjvDm7Z22fQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660083; c=relaxed/simple;
	bh=9V66dMarWmmmk3CXUmbzMsZfnZs14IYoJ3k7CrFdY7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCtn057ljn6qmKXV38PVNj+T06k+gqb1gyFI+1dTJuxKuFrytfYqK1lxBourZc9ppETQ8HpncFOLhty/F0Z0Bb8K4kRsdYdT8VZRR0iavv3fL+HI9X75VACBheB39BEEeruKIshBFzXaETMVjcRWPuCZTOf9rDB3q+lFc7e667A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocCdLj4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocCdLj4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B2A1F00A3A;
	Tue, 21 Jul 2026 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660082;
	bh=KEP7ydDu/dhglAn012KGHIQOKcdgukxSNHaW5DgI9QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocCdLj4/UjpFcaEPFRVbm8lRHHir45p+/cMEksv5RKik/Y0CB7b3RpPIZKDEHZdw1
	 qaUGEr1vLhoc42yxtjPv1q34fyXkmR1RaLgVrqjTsOKDSaWWHXBwbFD8ncDcRQG3EX
	 GK2ELLkzeAgEDrbYzysOOydyJAFYAHfq0nMrqSxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michiel van Tol <michiel.vantol@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0845/2077] coresight: tmc: Fix overflow when calculating is bigger than 2GiB
Date: Tue, 21 Jul 2026 17:08:38 +0200
Message-ID: <20260721152612.722389328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit f195d54deef1bc6dd3326394975baff02c7ae487 ]

When specifying a 2GB AUX buffer, the ETR driver ends up allocating only
a 1MB buffer instead:

  # echo 'file coresight-tmc-etr.c +p' > \
	/sys/kernel/debug/dynamic_debug/control
  # perf record -e cs_etm/@tmc_etr0,timestamp=0/u -C 0 -m ,2G -- test
  coresight tmc_etr0: allocated buffer of size 1024KB in mode 0

The page index is an 'int' type, and shifting it by PAGE_SHIFT overflows
when the resulting value exceeds 2GB.  This produces a negative value,
causing the driver to fall back to the minimum buffer size (1MB).

Cast the page index to a wider type to accommodate large buffer sizes.
Also fix a similar issue in the buffer offset calculation.

Reported-by: Michiel van Tol <michiel.vantol@arm.com>
Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
Fixes: eebe8dbd8630 ("coresight: tmc: Decouple the perf buffer allocation from sysfs mode")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260217-arm_coresight_fix_big_buffer_size-v1-1-774e893d8e3f@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 4dc1defe27a5f7..361a433e6f0c55 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -154,7 +154,7 @@ tmc_pages_get_offset(struct tmc_pages *tmc_pages, dma_addr_t addr)
 	for (i = 0; i < tmc_pages->nr_pages; i++) {
 		page_start = tmc_pages->daddrs[i];
 		if (addr >= page_start && addr < (page_start + PAGE_SIZE))
-			return i * PAGE_SIZE + (addr - page_start);
+			return (long)i * PAGE_SIZE + (addr - page_start);
 	}
 
 	return -EINVAL;
@@ -1379,7 +1379,7 @@ alloc_etr_buf(struct tmc_drvdata *drvdata, struct perf_event *event,
 	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);
 
 	/* Use the minimum limit if the required size is smaller */
-	size = nr_pages << PAGE_SHIFT;
+	size = (ssize_t)nr_pages << PAGE_SHIFT;
 	size = max_t(ssize_t, size, TMC_ETR_PERF_MIN_BUF_SIZE);
 
 	/*
-- 
2.53.0



