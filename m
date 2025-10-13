Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268EE2153E7;
	Mon, 13 Oct 2025 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367033; cv=none; b=pYfSoXtSCGgIPK53CsV/uWU3I+DYr10nIHlqQmmqo8pm4gy+4GpJ9sIW+C9JWAZhozLr0U8Ib6Z02C4hm3U0nRA/YKRvdQ1mXN/n84fGrRDKv+9BGMHIIfE8o1dnOtgFQMsYX/B4VESdSLDRBfIoczvp3LaKKEy8mglI6NA96iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367033; c=relaxed/simple;
	bh=DcLSX1fzGE0WgES0ZqMV6meYOZ3ylkY5AEHrfx7l+og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9Z7BJROLN3awH1jXsitdH7KCiyK/Pln7XhUY/vx3nRa36IdnmqpvSDyOPnyE6LuNt47TK1pXk3CGyTzoNFYHTXXe7aLpn36r+aXaeG6D2CSjHOhvJN2SDenjCHiEqxdyRac/JIWon//2feRoTiIns8/M56ZhTNyjJbF235+8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5HLgDNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5HLgDNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8E9C4CEE7;
	Mon, 13 Oct 2025 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367032;
	bh=DcLSX1fzGE0WgES0ZqMV6meYOZ3ylkY5AEHrfx7l+og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5HLgDNdAT4DYXFMzAvDzQAJjml/YvCLdnRr10Frm/z0IRNgekLqIuETHi/qXoLjK
	 WPqJ3lifdRZ36bkuL3/7i6xfUzDZaJsyZkAf5ZWAPewGj3nzz1zWwDuiYJYuzUCYBf
	 BsNUyRJdh5RGScm1VKTTO4y+F8PAFF585Y5NM2OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/196] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:43:44 +0200
Message-ID: <20251013144316.431692234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 00e3a637f7b63..815bf2e2dffa4 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -95,7 +95,8 @@ struct arm_spe_pmu {
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
 
 /* Convert a free-running index from perf into an SPE buffer offset */
-#define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
-- 
2.51.0



