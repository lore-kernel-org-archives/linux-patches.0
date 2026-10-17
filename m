Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029FF34C98C;
	Sat, 17 Oct 2026 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260243; cv=none; b=bTKfZx1/hbaDfx8B2EyzKG6NTn/ozlAGJ1hi+an933gDaEalUrChlo+q7r6HYxcMsM3cBVLMMIzXhXqz5whuIf44y43srRTaqky0Xgb/d6ciedwplNAj3x8SzU39jvo8LogTu6PLydcgJHCISoOWpHRY0othnDM2QndwLbNJKLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260243; c=relaxed/simple;
	bh=r9ZuBi8DmycKd78wzkY9lmyiN9U9IPT4RzfFbhrwY08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZQmouzKKeHLbXwHCeKvPGCXfEiK4QDtfml1k1tBWN/3gD50nhB65aPxNAYkf5WnBdKwBnFbZmasf4Pp05dZncljFXL/bCmLjnmGGThAiwGPf9b3ya9pg5CcI/GVPVcVZicr0FNO80BJMjjDVWuaqEI/JygvY2hTr+Fa7sN7v8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXyZA4Zy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXyZA4Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F0A1F000C4;
	Sat, 17 Oct 2026 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260241;
	bh=NRuad0+XS/Uxz5DSZnsJIJgk+boCHs5benhaJ2bi97U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXyZA4ZyOtYgCVsKy1TD8I/4sstXKP5p63iUPnTlM05qCgnDAE7uyOmvRJFUxD8Zn
	 C/EpRIVq/nOTT+vz3baqTgsR/dqOCyDgtX60byKnwP3fW4yv4f4y7htWsW5QEXcQ8L
	 umwUyOWaxNmrQXbfxuoQOZkZUxG8kFLv03gyJY78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1480/1674] RDMA/rvt: Return NULL after port allocation failure
Date: Sat, 17 Oct 2026 18:02:32 +0200
Message-ID: <20261017160509.143296774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2982eaf3b9d2d953318c74cd6f1b7576ea6d7b1f ]

rvt_alloc_device() deallocates the IB device when its port array cannot
be allocated but then returns the pointer to the released allocation.
Callers treat any non-NULL value as valid and dereference it, resulting
in a use-after-free.

Return NULL immediately after deallocation so callers can propagate the
allocation failure.

Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-1-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d61f8de7f21c2..ddc47691791ee 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -54,8 +54,10 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 		return rdi;
 
 	rdi->ports = kcalloc(nports, sizeof(*rdi->ports), GFP_KERNEL);
-	if (!rdi->ports)
+	if (!rdi->ports) {
 		ib_dealloc_device(&rdi->ibdev);
+		return NULL;
+	}
 
 	return rdi;
 }
-- 
2.53.0



