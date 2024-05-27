Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB90262BE;
	Mon, 27 May 2024 19:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838042; cv=none; b=tqD46lxNlCTH+qtFRYyqz24PVyWtdCKSE8bEc3Yd9X01WZ33i0YWt0wwaDAliaKp75GwYp/7duJF/WOgLUeUqN3gnc4+lE1Isy8i2KiB3tCuSGjpEzXEVSsH30wuuJeVWx7pr632hes8VgGzSkl9GefQ3jQowKdTjhFt5t10qQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838042; c=relaxed/simple;
	bh=VNAArefKWp5eldadxbL7j7YrwpoChqGcLzSFUbAAJ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ctvvg0lE8C+HbCXmETIP4OebUQx4K/H42vDPJP96czOzx1LAwtKVPIVfzy+PJkuqY88UMdD9NmSjCsITbYlb2TcxeceY6qxTOEBD4cIZrSLm2KRn5xRHjXjCTSEALSC7Wht24BqH0CWm1tl1aTsAu9p9/QaCFrkHeb9YW7x10as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIJ6Z7N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIJ6Z7N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65DAC2BBFC;
	Mon, 27 May 2024 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838042;
	bh=VNAArefKWp5eldadxbL7j7YrwpoChqGcLzSFUbAAJ+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIJ6Z7N5rYXlCM6OqSc5mfPY9yKwP3h+h1bEsoBATpGXUltXbTgINPYeSV1vqgquo
	 LutGOs5OM4mt1wjFRLIh/xGmoRKQRd5fRhsniPbgBtNdBNCzsMKP8F0s46e5Uvq90f
	 joPx1v4pX2fO/QwWil2zQlYBrx5x2FFy0Mf/DdF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 244/493] thermal/debugfs: Create records for cdev states as they get used
Date: Mon, 27 May 2024 20:54:06 +0200
Message-ID: <20240527185638.288213918@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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



