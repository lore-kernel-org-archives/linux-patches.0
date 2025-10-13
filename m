Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08E01CBEAA;
	Mon, 13 Oct 2025 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367497; cv=none; b=jz1wpWZPsR0qNqexUaN1pmqjywFO24m/2d3yUkvXuU+5bc4JOx/NJWnGuOUDiKwcuylEf+qvbA2qD/pIfpNkwHbGZ6SVY2tINr/cRw5Ib3KQVxrtuW3BVrntu1PrSGShKAioS1S3IDV6txRWeiFzlixZDrspHqMa2Yr6uvwoPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367497; c=relaxed/simple;
	bh=ulR/uo+jd0OzY+86jgezxg9ShASWWGeRVvPvJcIcVmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulvnfuz5bjCpqMxXp9J9xhabOE6Vf9kO0VEQxPJ8ZwgRFP2bxrElB1KjPWYwhwGrSpffTP45WKTKhY3lEkDgbjZg46EvENyfL4L0eJ/IhP6p0f9yjWHu23KZtjYB18GdmEXtxbk5k3K5eR/KJJc7K3E/NKPVh3q87YFaTZBWPeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hT1BNJkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hT1BNJkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D615C4CEE7;
	Mon, 13 Oct 2025 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367496;
	bh=ulR/uo+jd0OzY+86jgezxg9ShASWWGeRVvPvJcIcVmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hT1BNJkQka6uW8FpZiG30qfcdvVn7BXMjE8mDE2o2tI4kv6R/IKco+saA9NqSGTIr
	 NQjoIN/1T4kVlkPZ1ofxZdxQMN+0OuKk70L3c6lRepNTQULhcU3R37LBHUZ3cs7fu2
	 yom7C71DpQ/OOe6iNcqwiafFWMzWx451RqhwuVAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/196] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:43:18 +0200
Message-ID: <20251013144315.460108577@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit a29fea30dd93da16652930162b177941abd8c75e ]

Cast nr_pages to unsigned long to avoid overflow when handling large
AUX buffer sizes (>= 2 GiB).

Fixes: d5d9696b0380 ("drivers/perf: Add support for ARMv8.2 Statistical Profiling Extension")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 2bec2e3af0bd6..affa78376b6a8 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -96,7 +96,8 @@ struct arm_spe_pmu {
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
 
 /* Convert a free-running index from perf into an SPE buffer offset */
-#define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
-- 
2.51.0



