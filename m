Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C83A39B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302635; cv=none; b=Se/ScdFBJQC+13glnD7U70NkJA5Q6b2GhuEZEK8fsJKinxyKdwvZyXew8TRUGvbNKtyE3ujD/+198Clqd4Na0YwPtCbA47z89YRbXUfazCbCI5BvcxljPlxDaodO8jyLjX646RImN6ibOIWVxoVTA7NpLvsRtJmwPBIgbGuCmX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302635; c=relaxed/simple;
	bh=AAqUlRUGprOn4OLCf6WF05OVMZJalZUt7X2ST+lrxaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhCssp2ECPleHZD4PODT5iF175bPzwKz5spSUDHl0SUzgpFXV9q9h5q+9ulsaE85Dv5R237oF3yniMkeDdjwMOCKKUmsFRb80Ts73TuzvweYzbZ9a0thccih5Ju2ul5AP6hk+1PVLttDK8SZ3gzaveUB3REO+HkCxcXiJMrQZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICJPQfkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICJPQfkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B45AC19423;
	Sat, 28 Feb 2026 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302634;
	bh=AAqUlRUGprOn4OLCf6WF05OVMZJalZUt7X2ST+lrxaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICJPQfkreec9N75YJaLeuWoCHyWJGRDBQaEQleF/vtPKhTbwqEREJ7d6ErJe8oDJG
	 Aj8GWdhzEpcHIJDViryXgYooQfIOImpZqAJh21Nb8XFqf+JAKVsvvSWQWqebGMY1vi
	 1TTsSnKKn9LFT81fkHp3UrvavtEPnMBI9vtusuu+ZbNRgylOSRw2EzhJxigNJrbNcT
	 5NST9hhnrrciW5AUMSiFA51oTO+MvFNtdIEDEVdHtYkij2Ng7Z8W0pY4CD5z2l+Oy6
	 r4UaQpbZFm80XBdRu3Bw3ArlKRrReJWhaLx87E2nJAM5CIsaiRwiBh96JyztwGUZ2f
	 uKmGTbnEbi+0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/164] cpuidle: Skip governor when only one idle state is available
Date: Sat, 28 Feb 2026 13:14:54 -0500
Message-ID: <20260228181505.1600663-155-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit e5c9ffc6ae1bcdb1062527d611043681ac301aca ]

On certain platforms (PowerNV systems without a power-mgt DT node),
cpuidle may register only a single idle state. In cases where that
single state is a polling state (state 0), the ladder governor may
incorrectly treat state 1 as the first usable state and pass an
out-of-bounds index. This can lead to a NULL enter callback being
invoked, ultimately resulting in a system crash.

[   13.342636] cpuidle-powernv : Only Snooze is available
[   13.351854] Faulting instruction address: 0x00000000
[   13.376489] NIP [0000000000000000] 0x0
[   13.378351] LR  [c000000001e01974] cpuidle_enter_state+0x2c4/0x668

Fix this by adding a bail-out in cpuidle_select() that returns state 0
directly when state_count <= 1, bypassing the governor and keeping the
tick running.

Fixes: dc2251bf98c6 ("cpuidle: Eliminate the CPUIDLE_DRIVER_STATE_START symbol")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260216185005.1131593-2-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index e371d6972f8d9..20b9f77a8fb02 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -319,6 +319,16 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		   bool *stop_tick)
 {
+	/*
+	 * If there is only a single idle state (or none), there is nothing
+	 * meaningful for the governor to choose. Skip the governor and
+	 * always use state 0 with the tick running.
+	 */
+	if (drv->state_count <= 1) {
+		*stop_tick = false;
+		return 0;
+	}
+
 	return cpuidle_curr_governor->select(drv, dev, stop_tick);
 }
 
-- 
2.51.0

