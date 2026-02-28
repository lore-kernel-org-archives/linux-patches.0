Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3733333A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302250; cv=none; b=hCLP0pZPxhJGvojIl9epf34AjxMcoJfS7Kl/AR2Iukb1hngD2ll9PTdV4Hpz8tqcln5ALXrLQwjST+9cr/Rkl/vb+9oI0x3gEsquKwdir8dQGxPntiqRporKJ2iJIGqJlMjI+RVpkccWHdk6B2ERKfxyXCjndDD4w9INHiDo3mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302250; c=relaxed/simple;
	bh=jHi9tdbeGzt7f9lOk8DJs40M1qxkPTE/p6jS1hxtb98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COFk7iaK4w6rUv4fh5uxwsW6BUljAAdWBDFpVdH2n+TdsmAMDoNbaqmfewqCDqCKBxTa5qMgFRemuAJZVxIy6JsWyb3i5ECwTZrEwLVe4wzArVKiHnTQbIky2S8f/WOksE/wtXsOnW7cV1THYGlC4vWuIAWS91Gk8rWJjxlKHrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8/VXiHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8/VXiHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8801DC19423;
	Sat, 28 Feb 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302250;
	bh=jHi9tdbeGzt7f9lOk8DJs40M1qxkPTE/p6jS1hxtb98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8/VXiHR2R/l1agPMbL1kYRsUE6pye3oDlyDc42UDP1Afq/Khz8LQMdI+1YuHcpOH
	 mlEY0GO9WGG4TS4JpukezwwzEWkzeb9F2MYDJfdVoNULBCIkJvGXIgaqmD0HCsiKfa
	 +ScQbLP03g3wYqoFCgwd5LkqG5IFLUBUIFGvB1KKaBMSbyW/65LG14mvrjKmK4Ou+2
	 /kgufOpUzs6KhA0JkykCT96LcBk5kFhF9yM8xwDrJNawJIsRfNIadYDI5uxJ2OMmzy
	 UFZ9bHqlM8a0DUJoYXU0FbW2kH5Q+tUnyzGPekzbHurheXs5j7sK/9Gr/2rAMfMyh8
	 ZvymT2YVJmUdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/283] cpuidle: Skip governor when only one idle state is available
Date: Sat, 28 Feb 2026 13:06:45 -0500
Message-ID: <20260228180709.1583486-263-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 6704d610573ad..aa117f2967fdf 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -356,6 +356,16 @@ noinstr int cpuidle_enter_state(struct cpuidle_device *dev,
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

