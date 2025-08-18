Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C020C461;
	Mon, 18 Aug 2025 13:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523826; cv=none; b=BRrDvuBJCKoE6BNmb+lvfM4NasbZfZvBfuUYyGWX8f936lodmySiAF5KMaAfdtjc7E8jvMrB7tPT+6H6uy18jkn2csdSpNMLuVWpEASiW0YTq28C0z07dbKUU8wvVPArRqhR8tzQdqz/F8FYPSDcpjTOpR28ff2m5u+RoSr29Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523826; c=relaxed/simple;
	bh=mHbhihw2gsa4LdV+qJYcKvZLrJLxqzq4v1v/YIASBPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brovADzm3mUt7v8WfwpYm7iU0Ty0O6uTK4L1YMn58wkqEoP73GBAS6x0sQXWbvJG1BXb7ucs3HRX6MIRR4UJNyqLMm1LJQxHaoPhXwDP9C/qPi4MFLv/1PB7uswLCiCB3cfg2GVNS0dLTapng5AyIXLRZ+wc5ns/taR4efoxqo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjRFOPAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjRFOPAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA3CC4CEEB;
	Mon, 18 Aug 2025 13:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523826;
	bh=mHbhihw2gsa4LdV+qJYcKvZLrJLxqzq4v1v/YIASBPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjRFOPAvXALRbDvQ9UjH/CvBeNL8jLjZhROflfkT2lkv9dIjCoEoimyXP76lsKysm
	 TovOfwaZMLemkUfg6QSDe9vudIVX0l+1LnVHW4RHP/CB9wbDsmKe/yyEgDR3g8LyDl
	 J+wFK5hSKdEQQJcq40qRwhYVjkE+op+H+ovptVZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 257/515] drm/imagination: Clear runtime PM errors while resetting the GPU
Date: Mon, 18 Aug 2025 14:44:03 +0200
Message-ID: <20250818124508.306751041@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessio Belle <alessio.belle@imgtec.com>

[ Upstream commit 551507e0d0bf32ce1d7d27533c4b98307380804c ]

The runtime PM might be left in error state if one of the callbacks
returned an error, e.g. if the (auto)suspend callback failed following
a firmware crash.

When that happens, any further attempt to acquire or release a power
reference will then also fail, making it impossible to do anything else
with the GPU. The driver logic will eventually reach the reset code.

In pvr_power_reset(), replace pvr_power_get() with a new API
pvr_power_get_clear() which also attempts to clear any runtime PM error
state if acquiring a power reference is not possible.

Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://lore.kernel.org/r/20250624-clear-rpm-errors-gpu-reset-v1-1-b8ff2ae55aac@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_power.c | 59 ++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_power.c b/drivers/gpu/drm/imagination/pvr_power.c
index 850b318605da..d97613c6a0a9 100644
--- a/drivers/gpu/drm/imagination/pvr_power.c
+++ b/drivers/gpu/drm/imagination/pvr_power.c
@@ -317,6 +317,63 @@ pvr_power_device_idle(struct device *dev)
 	return pvr_power_is_idle(pvr_dev) ? 0 : -EBUSY;
 }
 
+static int
+pvr_power_clear_error(struct pvr_device *pvr_dev)
+{
+	struct device *dev = from_pvr_device(pvr_dev)->dev;
+	int err;
+
+	/* Ensure the device state is known and nothing is happening past this point */
+	pm_runtime_disable(dev);
+
+	/* Attempt to clear the runtime PM error by setting the current state again */
+	if (pm_runtime_status_suspended(dev))
+		err = pm_runtime_set_suspended(dev);
+	else
+		err = pm_runtime_set_active(dev);
+
+	if (err) {
+		drm_err(from_pvr_device(pvr_dev),
+			"%s: Failed to clear runtime PM error (new error %d)\n",
+			__func__, err);
+	}
+
+	pm_runtime_enable(dev);
+
+	return err;
+}
+
+/**
+ * pvr_power_get_clear() - Acquire a power reference, correcting any errors
+ * @pvr_dev: Device pointer
+ *
+ * Attempt to acquire a power reference on the device. If the runtime PM
+ * is in error state, attempt to clear the error and retry.
+ *
+ * Returns:
+ *  * 0 on success, or
+ *  * Any error code returned by pvr_power_get() or the runtime PM API.
+ */
+static int
+pvr_power_get_clear(struct pvr_device *pvr_dev)
+{
+	int err;
+
+	err = pvr_power_get(pvr_dev);
+	if (err == 0)
+		return err;
+
+	drm_warn(from_pvr_device(pvr_dev),
+		 "%s: pvr_power_get returned error %d, attempting recovery\n",
+		 __func__, err);
+
+	err = pvr_power_clear_error(pvr_dev);
+	if (err)
+		return err;
+
+	return pvr_power_get(pvr_dev);
+}
+
 /**
  * pvr_power_reset() - Reset the GPU
  * @pvr_dev: Device pointer
@@ -341,7 +398,7 @@ pvr_power_reset(struct pvr_device *pvr_dev, bool hard_reset)
 	 * Take a power reference during the reset. This should prevent any interference with the
 	 * power state during reset.
 	 */
-	WARN_ON(pvr_power_get(pvr_dev));
+	WARN_ON(pvr_power_get_clear(pvr_dev));
 
 	down_write(&pvr_dev->reset_sem);
 
-- 
2.39.5



