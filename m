Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E09D1D6DB4;
	Wed,  5 Mar 2025 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198433; cv=none; b=FH3RONbLF5zegCZw68gM7coamt/y5gIzeZ5buuruDxYIVdL4v/6Tpu9b9ipAm4wgtoOQstMuRMQsl8nyZ9Pmi2X/WnBkkm0V0dF5Ry2l4DGnZCd6eyBmzabPysybbrPKpgJxQeiMitvIv7zCVUknx8tmAP/KlfnkAnaVDxrZYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198433; c=relaxed/simple;
	bh=zezXWg4nbPR/w/UqkVXSwFoJGxUhzwqD1QIDFZ6l5Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKp/1h6lwz+C5oF1aO08N2BdZZbwhiErtz2fL/CHw8I9XS2LXgE2OHl5NwuIpdQVLyyoV5rBT7bd4c/WYkZwHQk8Rwyvg5rzM4X6E3lXrS5uAOmWJfi42TGWRbvx66tkbnxPc5y9NDA8pgY+A32iI0iiZ41r/S82CtK5EYugoqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0HUJHjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0HUJHjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E89C4CED1;
	Wed,  5 Mar 2025 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198433;
	bh=zezXWg4nbPR/w/UqkVXSwFoJGxUhzwqD1QIDFZ6l5Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0HUJHjMkFrwyaN03uOZJB6ErFs0Pj5FmccQp56a9/h6JJNFZnhgNAUV9HceO3gy1
	 JvpWrpg0br6T3T53EyPkHlhDZlvdNvqukoDF+qO3Ia3e7jwNUubwHdsBJPxUdfNTem
	 kVr37YD0bZfjRitzxquRK4WWPWA8yfYpXGJyrNEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 009/157] RDMA/bnxt_re: Fix the statistics for Gen P7 VF
Date: Wed,  5 Mar 2025 18:47:25 +0100
Message-ID: <20250305174505.653107121@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 8238c7bd84209c8216b1381ab0dbe6db9e203769 ]

Gen P7 VF support the extended stats and is prevented
by a VF check. Fix the check to issue the FW command
for GenP7 VFs also.

Fixes: 1801d87b3598 ("RDMA/bnxt_re: Support new 5760X P7 devices")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1738657285-23968-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 4 ++--
 drivers/infiniband/hw/bnxt_re/qplib_res.h   | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 656c150e38e6f..f51adb0a97e66 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -357,8 +357,8 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 			goto done;
 		}
 		bnxt_re_copy_err_stats(rdev, stats, err_s);
-		if (_is_ext_stats_supported(rdev->dev_attr->dev_cap_flags) &&
-		    !rdev->is_virtfn) {
+		if (bnxt_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+					     rdev->is_virtfn)) {
 			rc = bnxt_re_get_ext_stat(rdev, stats);
 			if (rc) {
 				clear_bit(BNXT_RE_FLAG_ISSUE_ROCE_STATS,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index be5d907a036b6..711990232de1c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -547,6 +547,14 @@ static inline bool _is_ext_stats_supported(u16 dev_cap_flags)
 		CREQ_QUERY_FUNC_RESP_SB_EXT_STATS;
 }
 
+static inline int bnxt_ext_stats_supported(struct bnxt_qplib_chip_ctx *ctx,
+					   u16 flags, bool virtfn)
+{
+	/* ext stats supported if cap flag is set AND is a PF OR a Thor2 VF */
+	return (_is_ext_stats_supported(flags) &&
+		((virtfn && bnxt_qplib_is_chip_gen_p7(ctx)) || (!virtfn)));
+}
+
 static inline bool _is_hw_retx_supported(u16 dev_cap_flags)
 {
 	return dev_cap_flags &
-- 
2.39.5



