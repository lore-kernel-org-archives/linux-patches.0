Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F03101AD;
	Mon, 13 Oct 2025 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368001; cv=none; b=qVXmEbmuSgzGBalR2cKM/JCXJ9TTAVnKEmvBJ8kGUIRBPjFEWZbl5ju9zCxMoeqL1KhrSHxiLol2aFLIntzvj7DcDIYsF1h7TAuyAeIstLWB0u/37rHIMnVL9FJvXBSL3nFi6lgJrjNe1oTgFpBkHiUzoAmEHv1v7NLmlyYmGEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368001; c=relaxed/simple;
	bh=56EIppqCiW4JSTYvZcgtig6eu5uBfP/mij7hy5TLKr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAjHqv3N6upaXqNaeZ93aERYr+aYJY7c/vLaFSueHZzAIpWUBfvWOHV94g71aVcsSYaPp6y16lGG1GX/rLqQRpMa7VoZhVsfQbl0hIX6SEELISTugkhJqv/9H03SBXXHUhUtz8yla6LU/D0HmA3U2xI9qQes9VLYASmZrVkgHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3jHUELY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3jHUELY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17121C4CEE7;
	Mon, 13 Oct 2025 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368001;
	bh=56EIppqCiW4JSTYvZcgtig6eu5uBfP/mij7hy5TLKr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3jHUELYdx5LNGrzFgkBTG/1rpoRNUckzMlTFzex1nvoi+a3zbZC1YdidYUErFVXT
	 kAVggDj/uxejheb/kqInmF72jJIUv4tEImyGNYhzfnJunnLVIUgqVSa0XWCX/l/L6L
	 XrpcwKv6nM5i0gV7ep4LzDtDWOhZXa6jQJ11ECjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/262] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:42:32 +0200
Message-ID: <20251013144326.497607845@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3569050f9cf37..abd23430dc033 100644
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



