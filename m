Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952C737FF46;
	Sat, 12 Sep 2026 10:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209601; cv=none; b=B0XIu1h9ziv6Civg5ocjZleBu20GhLK0Wn6b1gVYFpeGUzlkV1ja1ReJpe03nyko8mKoRZ+c3hDTWJyrKnltGIDcGpUzrvomVP3AI7Ej8s582MoO4w7j8DTJpELdDyuaH5Eo4txpuS/EOsrNfGiKtuf9Yb5mlhUv2st5Y8mjaZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209601; c=relaxed/simple;
	bh=FZHMXO16OSdTUJWqGX1o+4m9RQOqOvBqMiMP+sfbPLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeDVS3y3tEy88JXDaPqsWZmwozUp3auBJiZ4FLfydQvXv2TQ51f6mPywCpI8GbX7S1lhj05t/RI7/1tMMOuLdBToFFGX+ejE3varL6yI+eCTB7WknKn7ahqdWqP6wW2ZA4+z1IJT9iDMHdYvBH05TZdq5XNDB3Bo9As3eEcSKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSdIDRON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSdIDRON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984E1F000FF;
	Sat, 12 Sep 2026 10:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209600;
	bh=MXRwQsqNMjv3C/GglTGXUAgqL3CUvIg2ZThcM3iIbpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSdIDRONqplHlOywFHtLMNkOYNgLvsO/hlbccthyE+zjiiuYwaTy1VObS569U1n8p
	 cZ3WvRsdmMi6/CKldmqVFRdfGnm6bgSIbfuM8eemjjUd1zH8KquCANF7RUfi9pMEQV
	 q5cPtBo0LMtsKdt3yA2wQPz+XHw8vwmdTw/IYSgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0854/1518] perf arm-spe: Reject zero nr_cpu in metadata to prevent division by zero
Date: Sat, 12 Sep 2026 08:50:23 +0200
Message-ID: <20260912065642.770248238@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d67241d43b709af4d13051bb8494892b654aba41 ]

arm_spe__alloc_metadata() reads nr_cpu from the auxtrace_info priv
array without validation.  When a crafted perf.data provides nr_cpu=0,
the per_cpu_sz calculation divides by zero:

  per_cpu_sz = (metadata_size - (hdr_sz * sizeof(u64))) / (*nr_cpu);

Reject nr_cpu <= 0 early, before the division.  The caller already
treats NULL return with metadata_ver != 1 as a parse failure.

Fixes: 7842a4b6ff698 ("perf arm-spe: Support metadata version 2")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 71be979f50771..cc99b06e59802 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -1543,6 +1543,10 @@ static u64 **arm_spe__alloc_metadata(struct perf_record_auxtrace_info *info,
 	hdr_sz = ptr[ARM_SPE_HEADER_SIZE];
 	*nr_cpu = ptr[ARM_SPE_CPUS_NUM];
 
+	/* nr_cpu is used as a divisor below */
+	if (*nr_cpu <= 0)
+		return NULL;
+
 	metadata = calloc(*nr_cpu, sizeof(*metadata));
 	if (!metadata)
 		return NULL;
-- 
2.53.0



