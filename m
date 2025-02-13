Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D715689A;
	Thu, 13 Feb 2025 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458215; cv=none; b=oFqsr9e0+hBJnIMlQEbDAF5d7tLdnzbILFA9vX6JLWq2pYDmuJbEB1MgKNAM+V5V9J2qSqCFUr5szrfPXIR+8x4cxix/8XELMAxbnEO09BUQo0G7UFT8+IN7suiWjVJvHNv2dL8SbEo/xJQmrWQsGct8g2zIoYrsD0rmsOgBG1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458215; c=relaxed/simple;
	bh=9uSgCDgwzxtO/BQ9pdd2P/T/QiyvgVmQbHdXhL9mwZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtftTbWeNDEmC+UpYHx6Fd4mlkliGTTzyiZXTkBfrdgcoeFhCNlh8aa8rRRzIoGMshKa5LTB2lMi2xNxlbM5Xsi5yU6NLYvL8Gu+0COpu9jcxUrJkBXI51oKT36lqSw+ixIK+1QJEiOwaDhuC5Ib0QqCVpqxXYuOIdwAzLKF+AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh48VOxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh48VOxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A056C4CED1;
	Thu, 13 Feb 2025 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458214;
	bh=9uSgCDgwzxtO/BQ9pdd2P/T/QiyvgVmQbHdXhL9mwZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oh48VOxJ+M9giKwqQb1HfcV2uWsFkzgGje48bPmackQKfT0BPLmAU7cUMnh7Qn4R6
	 oQi5gJuUr+uR6aW9SXBTFKRRJUdwD5vOSOkWpLO0AaFK04EtDU7XVM2/iL1mU9yoo+
	 VIQkdw4HA3ESLUtMOMfECxnhwdRSgbgz5X/LUVFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 303/422] accel/ivpu: Clear runtime_error after pm_runtime_resume_and_get() fails
Date: Thu, 13 Feb 2025 15:27:32 +0100
Message-ID: <20250213142448.235191320@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit f2bc2afe34c107a02ce829a4039e85514feafe55 upstream.

pm_runtime_resume_and_get() sets dev->power.runtime_error that causes
all subsequent pm_runtime_get_sync() calls to fail.
Clear the runtime_error using pm_runtime_set_suspended(), so the driver
doesn't have to be reloaded to recover when the NPU fails to boot during
runtime resume.

Fixes: 7d4b4c74432d ("accel/ivpu: Remove suspend_reschedule_counter")
Cc: stable@vger.kernel.org # v6.11+
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129124009.1039982-3-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -295,7 +295,10 @@ int ivpu_rpm_get(struct ivpu_device *vde
 	int ret;
 
 	ret = pm_runtime_resume_and_get(vdev->drm.dev);
-	drm_WARN_ON(&vdev->drm, ret < 0);
+	if (ret < 0) {
+		ivpu_err(vdev, "Failed to resume NPU: %d\n", ret);
+		pm_runtime_set_suspended(vdev->drm.dev);
+	}
 
 	return ret;
 }


