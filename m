Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F429337EB9;
	Wed, 17 Sep 2025 12:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112668; cv=none; b=tnUBUU/hBne/bCuPl2vcDrVdBN607/I0pdbA9XXl/cVfohOoHnv0eUza+9PqXBM2dse0pocLR3FH4geC+TdS/SOjwJvecf2TCcUSY09n/rbs+UE6D6iNoSsq2SKSltIcMksIvRXZ4Z1XbZNE604Dk27XspGZBPybJeYjZu4sEnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112668; c=relaxed/simple;
	bh=K/3qkVO67KLuDGVMJy2dgoveMGBQ1qC6bCbpVkK7tCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3Y5ywsFz92A9/4P6ebACQfkPP/GFxNzk8kVC2dXTSFfcjWRULSP98BlnUo4+Cj6E2OYoUITJq5OTSB372+SSqH0A/DrwUp8gdH7starrtnWUzX/oMgY7LKgvyEbD6TsUHfs68PJB++I++e9SJdkDjQsRl/wSFp4W88psoJDRH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhX7IJxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhX7IJxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8F4C4CEF0;
	Wed, 17 Sep 2025 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112667;
	bh=K/3qkVO67KLuDGVMJy2dgoveMGBQ1qC6bCbpVkK7tCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhX7IJxseQwdXQrKpBuro9Lfioie5ZlBHIXIGIrFwV/vSCX9ETsVgfCnDDH/XAiLS
	 gSLrzNfS4sYp1QmAc4Y7fRu/02quKzGRe1owc7iJysy7REBT2NqlSgmV1bO3gYQIfh
	 3JGKBbk2eRi0XzfJZAm+P72P8zHyKS+stA9IDlqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 039/189] s390/cpum_cf: Deny all sampling events by counter PMU
Date: Wed, 17 Sep 2025 14:32:29 +0200
Message-ID: <20250917123352.814778698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit ce971233242b5391d99442271f3ca096fb49818d ]

Deny all sampling event by the CPUMF counter facility device driver
and return -ENOENT. This return value is used to try other PMUs.
Up to now events for type PERF_TYPE_HARDWARE were not tested for
sampling and returned later on -EOPNOTSUPP. This ends the search
for alternative PMUs. Change that behavior and try other PMUs
instead.

Fixes: 613a41b0d16e ("s390/cpum_cf: Reject request for sampling in event initialization")
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 6a262e198e35e..952cc8d103693 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -761,8 +761,6 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 		break;
 
 	case PERF_TYPE_HARDWARE:
-		if (is_sampling_event(event))	/* No sampling support */
-			return -ENOENT;
 		ev = attr->config;
 		if (!attr->exclude_user && attr->exclude_kernel) {
 			/*
@@ -860,6 +858,8 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	unsigned int type = event->attr.type;
 	int err = -ENOENT;
 
+	if (is_sampling_event(event))	/* No sampling support */
+		return err;
 	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
-- 
2.51.0



