Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFBE46D55D;
	Sat, 12 Sep 2026 10:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210179; cv=none; b=NHDyHxkm0i/5FMa+nrttviLW7F1/pt7bDiZ7JoQmw7FvbDIZ4/tDyidNao/IQzINQASm7TyFGBp+85fxTs7D3/M2zzdGgC5gdZJG++1NfEVKEUBERqtYfUGqlrW68qZCcs9ImCy4etNa7cpZ4T4JdqmF8S3rHryey1cddjCs07g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210179; c=relaxed/simple;
	bh=RPJEAVr6TNQm+tuXf62KGAv7fBH1ZzuLeY61Yg8bpLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/T2TiJB6XHs+2sm1M3jZxl/EEAJYLVthurFXKcq4bdDuNHdaZLsh5vZTVe0vC4iigBIFQy12OtpATZ8Z22g6QShZBhQOkLCzGRa2j54JnBeiwPgvUYAqLI4nUo23LTGvddmqDPnOZBicjjDaw+rhSGc0pbYRPwOLisNCk6yAWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5LkYueS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5LkYueS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251231F00893;
	Sat, 12 Sep 2026 10:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210173;
	bh=tQUfgD0WBO6fJKno9hNHYgS3Ce5Yn3NxwAG+Mi2nkW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5LkYueS/n1t1aGFRPdAsyPG8GbKEOVBy0DPzq5iDFydWki5KgwgaGCahkRnkPQtC
	 S+cvUh/xrOrqemJCHVod6X0ChUrjxAItePGodIlaZNyC4GAtVQsL8IG6oCZ7uA2wJv
	 qTdXCxYC5OrmX6Knm5q3LSewPKMv15/j+1ACMbMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0973/1518] perf: arm_pmuv3: Zero initialize hw_id branch stack field
Date: Sat, 12 Sep 2026 08:52:22 +0200
Message-ID: <20260912065645.469193107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 69c5cc8f56067..265c10f2c8b07 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -1351,7 +1351,7 @@ static int branch_records_alloc(struct arm_pmu *armpmu)
 		struct pmu_hw_events *events_cpu;
 
 		events_cpu = per_cpu_ptr(armpmu->hw_events, cpu);
-		events_cpu->branch_stack = kmalloc(size, GFP_KERNEL);
+		events_cpu->branch_stack = kzalloc(size, GFP_KERNEL);
 		if (!events_cpu->branch_stack)
 			return -ENOMEM;
 	}
-- 
2.53.0



