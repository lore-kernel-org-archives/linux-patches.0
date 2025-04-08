Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30512686AD;
	Tue,  8 Apr 2025 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112785; cv=none; b=biOZadQgF2fHOIISIDscjkxO5oi1LVD3SeX6GdtWUsD0QWSzBYbo9UWWL3QV/dKmkVOqI2ltMi6wUpgvFhXD1qpAnkbk7/f/Cn29DgTWzPNCvRiG17wn3LPwbwCs/vSBU9I30gcbkV+9JXbVgVDQJtTBO5w/KnTBzgVMW3LzJs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112785; c=relaxed/simple;
	bh=ZGI62AZkgIc28PXjUJXFaTHs5lIDO/glesNoFXAdIUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLeBUzmr/gwidzrx0kHBWp+Agf7bNuxBXorxdric06ju3vFF87CywFoAUfHvn5PG4Cv+Sf0hJzhX3HEjJ/6RtT2gwuKKDBH7Ge4wQAF6PswAApsrgCTzeopouU3RHMQ43i6bNsMsU7sqGvdzY+m+fNsRbMc5kIhTDPOt1uA/iSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izkR72a5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izkR72a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3EFC4CEE5;
	Tue,  8 Apr 2025 11:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112785;
	bh=ZGI62AZkgIc28PXjUJXFaTHs5lIDO/glesNoFXAdIUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izkR72a5AkkP2CEIgqD7PHXAMes4bdNbod4PnWwY1lNVDWqYAT2rAnAT+GdadwjKl
	 +v9VHjqkT7PjI/NFeZ0zfPQ3Cl0gzw7P2Tn/qrmzLT9l0y7eulGVhi9UqS1X/y5M1C
	 fgsgASBpZnYvUubJ0ghmBDnovFGmRq7Lk+ae5rsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/279] coresight: catu: Fix number of pages while using 64k pages
Date: Tue,  8 Apr 2025 12:49:39 +0200
Message-ID: <20250408104831.628342550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 0e14e062f5ff98aa15264dfa87c5f5e924028561 ]

Trying to record a trace on kernel with 64k pages resulted in -ENOMEM.
This happens due to a bug in calculating the number of table pages, which
returns zero. Fix the issue by rounding up.

$ perf record --kcore -e cs_etm/@tmc_etr55,cycacc,branch_broadcast/k --per-thread taskset --cpu-list 1 dd if=/dev/zero of=/dev/null
failed to mmap with 12 (Cannot allocate memory)

Fixes: 8ed536b1e283 ("coresight: catu: Add support for scatter gather tables")
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250109215348.5483-1-ilkka@os.amperecomputing.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index e0740c6dbd542..29c74a4905366 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -267,7 +267,7 @@ catu_init_sg_table(struct device *catu_dev, int node,
 	 * Each table can address upto 1MB and we can have
 	 * CATU_PAGES_PER_SYSPAGE tables in a system page.
 	 */
-	nr_tpages = DIV_ROUND_UP(size, SZ_1M) / CATU_PAGES_PER_SYSPAGE;
+	nr_tpages = DIV_ROUND_UP(size, CATU_PAGES_PER_SYSPAGE * SZ_1M);
 	catu_table = tmc_alloc_sg_table(catu_dev, node, nr_tpages,
 					size >> PAGE_SHIFT, pages);
 	if (IS_ERR(catu_table))
-- 
2.39.5



