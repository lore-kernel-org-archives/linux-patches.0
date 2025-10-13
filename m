Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC3930EF64;
	Mon, 13 Oct 2025 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368808; cv=none; b=c/tC6qxlDG9IU/IeJ2mJevw6n7VaQ3WPWvavLuRS1bN1LT9xOz82rClyTrWszAsYWTM5innt54YCH6Yb6M9cr5hKv7LOUa9faAD8SwzO6XIbnrg4vNxt+h66xH7SArupc/vk1A3AoQTN6zfaiw2pmzotQoNIlIymeB7zYXOSTNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368808; c=relaxed/simple;
	bh=5DVo6RTVb7rUWbFHOCGCG94JSSkun/FGjY4iQVnzEI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea7vlFCxBPG34qzPEsEzulRKrIfeAczOwW2/Ke8FhGDT508TbhsbtMq635vLESem9ghjj/VQXJcpmYxs7k3IgVQ7KWBPRyKyRbpj5k5/3cQLq3uLnliOF3t4tNI3V2DNDaKHsGWyVkzRE7gnDZ9jTqs+i7O4OoOji44Wa2jYK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCDceMMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCDceMMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C88FC4CEFE;
	Mon, 13 Oct 2025 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368808;
	bh=5DVo6RTVb7rUWbFHOCGCG94JSSkun/FGjY4iQVnzEI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCDceMMwu3wy9Fu8Sbkgr/27C4TkztbokcOnDQoV06lizxXeTMBdMd4pApiLko981
	 S2ayhiCFD8SwJ2ayr9qt9+i+/ZUM8KjbtiXIWeST0FjsqqAkHPoxviUmYkaGWTmxnW
	 5Dy8zJ2NKYnNSx/MhF4unkC8Qc8G+YTK6XMdKVmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 027/563] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:38:08 +0200
Message-ID: <20251013144412.272605304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 369e77ad5f13f..8f14cb324e018 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -97,7 +97,8 @@ struct arm_spe_pmu {
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
 
 /* Convert a free-running index from perf into an SPE buffer offset */
-#define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
-- 
2.51.0



