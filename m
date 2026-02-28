Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21709359A95
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302468; cv=none; b=o5/Aio/CTqBq627bMeoTRVmy4ZLX4sDV7Xce0TFtCKbPN/20hC9pEkf1nehnqXjyVa3kwdSrzLx/HNXBgJ5pu6Sq3glFC6TuxblD31JbrZX2RNBKNhRAdAbuqL5cw/A0DVCg/TVGlVSuuYZxiD7IU12SjZZk7pu174ROtKAjAWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302468; c=relaxed/simple;
	bh=QOrEjyRYVqSLGHnn8SCe8n0zfHb8OzxWmWBfSgvEJuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELLc36+vSFpJjTPZf3yCGLUcSrkzoMtn99XZRmy8Bw3icuM+pGagwTtCPrthqXTZaudQUQ66Q331DlNHGTuYov2ua3pvMHiohQs6fuSepZ3JmGvrc23LVTbCRfwy+PDejoa+mjHT8jfagHak70FXDBq32T1XE/aHZtlKdpZZmc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WE7V5WNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WE7V5WNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FACC19423;
	Sat, 28 Feb 2026 18:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302468;
	bh=QOrEjyRYVqSLGHnn8SCe8n0zfHb8OzxWmWBfSgvEJuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WE7V5WNyCEQBhRBmdJUbNcWUP4rf+Ym4qZHrqk0Ll0uD56a+7+sxyXaf7p0tCJOCy
	 hX7sy16zHFnxoa/88uXZva8KziSohKUISl0j7ViyDy9lhY6XhrGDRqF+/Earwk2WKq
	 xz0Dbzk2ARFsD96OO1GeTI9K2075M2ar0Lu6/+xiocFxY16sh8hQAD5vGO6uEwNUq5
	 hQS/KnNSbpQqbbxxI9IPq4rcjcKH6YHEU0QFelKXNFgTO26qKkut+xvo87cSzVWjJU
	 /n7MRKlPY1ydPZsEGVz/fDAoBnA7Bj9qNfGnBbzuS0zw1uu0eisvT9K4X+mhK9PWo5
	 yYdU+omNu/raA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/232] cpuidle: Skip governor when only one idle state is available
Date: Sat, 28 Feb 2026 13:11:05 -0500
Message-ID: <20260228181127.1592657-212-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index fdd25271106a3..482bf87354a38 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -324,6 +324,16 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
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

