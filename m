Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99D55C3B;
	Tue, 14 May 2024 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682529; cv=none; b=NmoXMJ9MW37oQUEg1vQ1nNr6zrnZ5pyJHHwxARXsQnLMqerdlCosSTfWQjJPMH9845Y7pGPCWN8VMJEVe02HuGAt/RgHRK6qeMwn1BlzzpnnQsYbDvtrCiTc41vzu3mnUNXZm3QgkXKP48T7UXOKdGp9w+ZhXqmsHB319PiKYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682529; c=relaxed/simple;
	bh=JHsmsxzJXtD/7GQqbw+jsaOTiKH+vO1eGxxdd69wNaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQOLbJiNBSetuMa5jug9UQSTW+qvcu7P/KKlJ37V4RpElPsyzxaloOCX/1jNJLkdr+JPNKVk+lLYTLzqSxLear15rhtNSQYHeojS3EswojITrgEzGRM3xD4Uwz67qxzsvQEfQsifzsaORZlwuHi2/jxgyP1CZvkzU1u8zmMcfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6tFSQTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6tFSQTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2CEC2BD10;
	Tue, 14 May 2024 10:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682529;
	bh=JHsmsxzJXtD/7GQqbw+jsaOTiKH+vO1eGxxdd69wNaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6tFSQTqTqebRsvByAase9pHnw0UnmXwEACnS+T4NPtTEGNBID7ouOAHuqqwJDa/k
	 v1rs85+dxdEniIfvrMWAOg7lmBZkDeFvzr2A+06u5b8qwRVqYrZCoZUnJCWJT3NQ0D
	 g0Pw43PAL4TFPnCMXZCW7MzbxsB0732eKRxxWOXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 046/336] thermal/debugfs: Free all thermal zone debug memory on zone removal
Date: Tue, 14 May 2024 12:14:10 +0200
Message-ID: <20240514101040.346382403@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 72c1afffa4c645fe0e0f1c03e5f34395ed65b5f4 ]

Because thermal_debug_tz_remove() does not free all memory allocated for
thermal zone diagnostics, some of that memory becomes unreachable after
freeing the thermal zone's struct thermal_debugfs object.

Address this by making thermal_debug_tz_remove() free all of the memory
in question.

Fixes: 7ef01f228c9f ("thermal/debugfs: Add thermal debugfs information for mitigation episodes")
Cc :6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_debugfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index d78d54ae2605e..8d66b3a96be1a 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -826,15 +826,28 @@ void thermal_debug_tz_add(struct thermal_zone_device *tz)
 void thermal_debug_tz_remove(struct thermal_zone_device *tz)
 {
 	struct thermal_debugfs *thermal_dbg = tz->debugfs;
+	struct tz_episode *tze, *tmp;
+	struct tz_debugfs *tz_dbg;
+	int *trips_crossed;
 
 	if (!thermal_dbg)
 		return;
 
+	tz_dbg = &thermal_dbg->tz_dbg;
+
 	mutex_lock(&thermal_dbg->lock);
 
+	trips_crossed = tz_dbg->trips_crossed;
+
+	list_for_each_entry_safe(tze, tmp, &tz_dbg->tz_episodes, node) {
+		list_del(&tze->node);
+		kfree(tze);
+	}
+
 	tz->debugfs = NULL;
 
 	mutex_unlock(&thermal_dbg->lock);
 
 	thermal_debugfs_remove_id(thermal_dbg);
+	kfree(trips_crossed);
 }
-- 
2.43.0



