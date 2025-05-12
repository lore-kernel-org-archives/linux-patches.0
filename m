Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF7F1C173C;
	Mon, 12 May 2025 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072171; cv=none; b=hZATk7nbjMu+VO0+/V86hF0TUdQUWvFW9fWB+HwwyaEYCtPIHTN4cZcand73STuXp0WVN8r2+I2rNS3bJVLelwyAWrVN897+OiwHDeBKxjsseGtrId77QZ8MMmARJq3Df+bF1fSo4l419KW5NYS2dQvo4F5ILhRanAtMRdRoo08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072171; c=relaxed/simple;
	bh=5nSj9n57eEtQaaJCDPsmOfNC/pCIYDryYBWEUjUSBzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/oV5/nfDiTVH7QEewA5qZE8ii2ZL6WgjYKs0h7t5I2MWrcLb4e+jHCNAfUUF1SKCGHnopD8wkbKrqLlnX66K0UJHFpx+Ej8IkAoJZM8oGE4hxTcqPy5RbbTwXMD3F3yIFVs79v8v9QLUOtZNJHnucPmH9jSDRwF7uAZTTDYyL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ+90xsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ+90xsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76B8C4CEE7;
	Mon, 12 May 2025 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072170;
	bh=5nSj9n57eEtQaaJCDPsmOfNC/pCIYDryYBWEUjUSBzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ+90xsMyEsY58/YBxf94URoGzkORSK8G7YjOOtb6XSFOCuxovEQZEcilrj8qtRO1
	 3/h0SBtGLpxaErlRbSJ5ysUcl2H4Iji4e+DMhvpeWHwLvtjAmhV1cn3aJZ8VNGFw39
	 0NzpEEhqVKkyiK8ymEHgRaO4VFsrK86bFFFnVJ94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 158/197] accel/ivpu: Correct mutex unlock order in job submission
Date: Mon, 12 May 2025 19:40:08 +0200
Message-ID: <20250512172050.819293394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit 75680b7cd461b169c7ccd2a0fba7542868b7fce2 ]

The mutex unlock for vdev->submitted_jobs_lock was incorrectly placed
before unlocking file_priv->lock. Change order of unlocks to avoid potential
race conditions.

Fixes: 5bbccadaf33e ("accel/ivpu: Abort all jobs after command queue unregister")
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250425093656.2228168-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 766fc383680f1..79b77d8a35a77 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -646,8 +646,8 @@ static int ivpu_job_submit(struct ivpu_job *job, u8 priority)
 err_erase_xa:
 	xa_erase(&vdev->submitted_jobs_xa, job->job_id);
 err_unlock:
-	mutex_unlock(&vdev->submitted_jobs_lock);
 	mutex_unlock(&file_priv->lock);
+	mutex_unlock(&vdev->submitted_jobs_lock);
 	ivpu_rpm_put(vdev);
 	return ret;
 }
-- 
2.39.5



