Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337B6330B1F;
	Fri, 17 Oct 2025 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715965; cv=none; b=aBp8/QKTblaba7q2loMk87xjAo/X9xJ2MZq8MJ1waaTxzGfEMuifLTKbAOvWRxJq4aTeMoH3lgczPV0wr6xwEfD+LwwocbaYb3eJlM27+tL4bnmYNiG39zPFqOMR5SLk6h9Ole7EKaNzQr7vL4ha3m6jTAYIoxIZO1sRFIYZQ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715965; c=relaxed/simple;
	bh=JUp+PfV1F/fIaXZVgRuD4jgH23zZE7XmPqHIxsWz4C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBxUWthA0IA8FZcuxJ5RXgnSlAWW9Er+XojlRAL0WwOeilyF/03P7h8h10Dd2/4ZCseiDeiPWZD6P3Vg7Ejg+Hp7SDLtTZRVZ2UqVjpM+yQTKBmM4eYRMpevNEbU0GZHnx/7SiTMj7KXbnc+8+lKh0+pPEieFpFW/suJ1ujhWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCWKSyY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCWKSyY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBB0C4CEE7;
	Fri, 17 Oct 2025 15:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715965;
	bh=JUp+PfV1F/fIaXZVgRuD4jgH23zZE7XmPqHIxsWz4C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCWKSyY8ILqG/O30nZ/qgSVF2VK2DYjyx7B2hrsoA2bWn96z7GWBuchW865QVyiJH
	 Qf8jXN+T0G49pHMUyYnqNwdjaaedkQTzEJWGGj/zAA926jGquckCt4SHtgwvtTvI9i
	 IPvOjDoGfIErljtDDaOu+IfUrcCAag+9ztAR1LKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/276] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Fri, 17 Oct 2025 16:51:59 +0200
Message-ID: <20251017145143.358092111@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cd5945e17fdf7..5ba677353d040 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -93,7 +93,8 @@ struct arm_spe_pmu {
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
 
 /* Convert a free-running index from perf into an SPE buffer offset */
-#define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
-- 
2.51.0



