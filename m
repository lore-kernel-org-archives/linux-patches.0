Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F4B3081BE;
	Mon, 27 Oct 2025 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590982; cv=none; b=MurgeH8gDNejv+7yjYWs2t877YIwn8amHEoI78262fVJstpl7eqAx4oWH7Zoz//w+Z1eHpm6BLel07ziTeAAPBNUTkpEsy2tP4ChXA1gAyGR+OTpL8IvqNyqERYH9sQGTLHCVZdRmnvbB3Ba3de6lru5yvqvSiXZthtpUEy8nvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590982; c=relaxed/simple;
	bh=PvzBRkuDT+wcACqnibaTfXwubBYK5H1+VztIWYuK3sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzQtIJUeJjmBEGmzjw9w78Jhh78GrGP88RArgrnPYcoZ+9u4lb7G/Kq8TNiO08/QSK89LiS4Pm7KEabuPoy3gkCQUNmH5K48RK1+47Kst4up10pHQLFptu+sOybhngAMEgxGWk60Rag0Cx0JjOy5n03Y4n6oPzXycxgMPutC3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+S7dQKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+S7dQKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F5BC4CEF1;
	Mon, 27 Oct 2025 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590982;
	bh=PvzBRkuDT+wcACqnibaTfXwubBYK5H1+VztIWYuK3sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+S7dQKG2J1ecXSARju6M0B/nce6N+pZLV0fCWb2tzCIHvAYzPmSNQcGJYHaJJUHo
	 3yzlZxocUZKYQz+1aOfE4zWfotpflnVKO3/kxVV7osWCJvN8Ak63LpQSCuu2VBlVXv
	 SXmiLLV8P7lT/kFJIFzHDOyJ+RFqSYzA8ZuSGO8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/332] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 27 Oct 2025 19:31:15 +0100
Message-ID: <20251027183525.206583513@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6fbfcab4918cf..3280c4b488d44 100644
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



