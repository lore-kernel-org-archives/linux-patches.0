Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AB635AC1E;
	Sat, 12 Sep 2026 08:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201563; cv=none; b=RceVHzKxTdy+SC4+vw2b15h8SogvRqyn+4AP8CU4Px3No/8UOV0TYgbckPPaK7ThcJNPkjfXdsF6iSU1LAMCFrtt0F8ER5JF89MA9/z0ydp9rj074j+Q5oVQLN1whBBNX13nW8Heo2lpvw+wgOplzhpLbMo+SuaLMLFlttylTVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201563; c=relaxed/simple;
	bh=163aaLN1ZGIpVBEFw3zKQBVmMwSQl6Z7CyiLqn4jh9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svSLnJmC2BW+FT1j7INkSM7bXnJQ0s3QEzcm3WJm83SRjG1U2JQrU/klU3cKEoDcn5wcb0RIcYI+mw1ai0UaktoHsBWBu/nEH4UfIoc9Vzo9zyQh5iqpQkIRS56e+gv4nII5Bfm4M5X4Xw7r9WNFD6DA7BidYNJ7lz9eidAS9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3vhcdN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3vhcdN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1333A1F00893;
	Sat, 12 Sep 2026 08:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201561;
	bh=vvibOS3LUTh1ap7Ddicp2OiatBgqyJexaJftTxmOP0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3vhcdN3YhNB0Y0ynpEu82EReaR8WAk7zMeuAdI1pQtKYaxEnGp+tS5uyXZydvyUc
	 y0bwUpYr9MKk+9aDbYaRaX9xu2WSQB6IZtElqCdpt2r/QoVo4KxF4RKw1KH/ss4uwC
	 XURCNVnQURRUM4UKmKKA1Z4BZu+3sOEGniIwKT5I=
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
Subject: [PATCH 7.2 1022/1815] perf arm-spe: Reject zero nr_cpu in metadata to prevent division by zero
Date: Sat, 12 Sep 2026 08:46:12 +0200
Message-ID: <20260912065713.008098112@linuxfoundation.org>
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
index 552f063f126e6..401aab529309c 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -1605,6 +1605,10 @@ static u64 **arm_spe__alloc_metadata(struct perf_record_auxtrace_info *info,
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



