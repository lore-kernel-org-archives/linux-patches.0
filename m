Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295742048E;
	Sat, 12 Sep 2026 08:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202411; cv=none; b=rItLMqKrfEDodZWseKzi6XG/89KfdwaZzsn6E13uLuYxSWDI89xa9awDaizZZf1i4dc+OXP0WFruRWqI3QxCRfVsO8sTGqet9f4X/tAGvrpWmkJHnYBN5EfxOyg6lzXVVyrKIjwD8w3aMemDf6A6gTMF+mDMhmHK0+jpMZJ6fh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202411; c=relaxed/simple;
	bh=Xrmpum9/mubTS7aBAhXbMWPWYXPvC2Hvu4kbKE0PEUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+Z6mv89RWTwaZcVuesaH1TOQW1U4M9o8IdQF4pkPrOWbRNxd+EVcvMcgHSaUDVxTyeg4NxLk5hOSwE9kH0uDK3qcE0EGu8AGj8+z/dTE+cvahtUvnyYas37wHAloqPrYh1jzC1j1P6HJJT34MkaIHT52BUsodJrDEHe5Qjoquk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+EzWVvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+EzWVvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CA11F00893;
	Sat, 12 Sep 2026 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202409;
	bh=XjUHayFXnFWW2pW2mQOw8cGK5tGtroybwvjHU/fik3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+EzWVvRU0DCdhDhhnOIKQuN7xwyJ9VnW4YKFJwAIgIO3nSBW6o8d3QgVTlW9fL5Q
	 tPdQGKLzfv0dYyT0h8ABvFcoet2Ej26qxRDlwXy5aPfxCdLg7Geux0l988qpqoASb0
	 5t1f2a0Xi4DxHxRO/P+LgvMVCZ1BHJ46jJXWLMT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1198/1815] perf: arm_pmuv3: Zero initialize hw_id branch stack field
Date: Sat, 12 Sep 2026 08:49:08 +0200
Message-ID: <20260912065717.136682799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 7c3b63386c27bed8d59a4b4c283d02860420eb0a ]

PERF_SAMPLE_BRANCH_HW_INDEX is supported by BRBE so hw_id is passed to
userspace, but it's never set by the BRBE driver. Zero initialize it as
it should be according to the docs:

   * For the architectures whose raw branch records are
   * already stored in age order, the hw_idx should be 0.

It's probably too risky to remove PERF_SAMPLE_BRANCH_HW_INDEX from BRBE
now in case anyone is setting it and reading the value, but zero
initializing the whole struct also protects against the same issue with
new fields that are added in the future.

Fixes: 58074a0fce66 ("perf: arm_pmuv3: Add support for the Branch Record Buffer Extension (BRBE)")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmuv3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 8014ff766cff5..b9a8592bf1128 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -1361,7 +1361,7 @@ static int branch_records_alloc(struct arm_pmu *armpmu)
 		struct pmu_hw_events *events_cpu;
 
 		events_cpu = per_cpu_ptr(armpmu->hw_events, cpu);
-		events_cpu->branch_stack = kmalloc(size, GFP_KERNEL);
+		events_cpu->branch_stack = kzalloc(size, GFP_KERNEL);
 		if (!events_cpu->branch_stack)
 			return -ENOMEM;
 	}
-- 
2.53.0



