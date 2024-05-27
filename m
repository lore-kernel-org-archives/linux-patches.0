Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD02326ACA;
	Mon, 27 May 2024 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836900; cv=none; b=LMXUBPPrlVcvjPt14Il9scA/esmgNlcM81pAW5VaYnphmJcDDPvDeWu3TiyGw3mbGuhwMljckOOhp9FvJdGvJ8vvQtkN12XplwqWgPFJBS6fpSd/TEwCa4cCicGhpZupTyb4KPlXxb4HvnpBz37RMU+LyYV/urD6Y3KZ/mGQZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836900; c=relaxed/simple;
	bh=xOjXN57eMozpnnCdPfPamrzKnZIBXE0AFBnmhnLKLVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEHSoxpMdTo+KJZ4ci4ahgYK5pLU5aCRPoNKQoMpmQLafueKMGPWXstFb1GHNCoLWo57fk0cBmH6joe1zpRB9ZpbqFgd1M3cVIPEyCLouf5/trdhWzKDLB9NRs75AvAlx/3SZ3ufN1jYpI4WnE9RzO7nIzcmHiqES/lewPMvw9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S17WjqM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S17WjqM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603AAC2BBFC;
	Mon, 27 May 2024 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836900;
	bh=xOjXN57eMozpnnCdPfPamrzKnZIBXE0AFBnmhnLKLVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S17WjqM3PTup+BHUishSWAWnfZD8iznftr3X9O0ViwDlNf3DaFXPrdE5rmY6T6MsG
	 nRJiJIX2bAFvXGrANxMEn6CdGflB54baXu5LAOB0ItBM79x3VPBUzC77BZwPuXIsPz
	 qTfIBTjIniloVpDNLSEZjqqgS+l8tXt1h/H6NpF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 180/427] thermal/debugfs: Create records for cdev states as they get used
Date: Mon, 27 May 2024 20:53:47 +0200
Message-ID: <20240527185619.015359850@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit f4ae18fcb652c6cccc834ded525ac37f91d5cdb1 ]

Because thermal_debug_cdev_state_update() only creates a duration record
for the old state of a cooling device, if its new state is used for the
first time, there will be no record for it and cdev_dt_seq_show() will
not print the duration information for it even though it contains code
to compute the duration value in that case.

Address this by making thermal_debug_cdev_state_update() create a
duration record for the new state if there is none.

Fixes: 755113d76786 ("thermal/debugfs: Add thermal cooling device debugfs information")
Reported-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_debugfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index 47ab95b3699e9..2891d2ab4875c 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -435,6 +435,14 @@ void thermal_debug_cdev_state_update(const struct thermal_cooling_device *cdev,
 	}
 
 	cdev_dbg->current_state = new_state;
+
+	/*
+	 * Create a record for the new state if it is not there, so its
+	 * duration will be printed by cdev_dt_seq_show() as expected if it
+	 * runs before the next state transition.
+	 */
+	thermal_debugfs_cdev_record_get(thermal_dbg, cdev_dbg->durations, new_state);
+
 	transition = (old_state << 16) | new_state;
 
 	/*
-- 
2.43.0



