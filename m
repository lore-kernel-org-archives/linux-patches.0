Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4321347D92D;
	Sat, 28 Feb 2026 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301473; cv=none; b=akJFyt4d3Nxwl+HM2s9uL8s9/kcErkHbGErydDI/ojcEZ3oTygB0GQqcsGEQUEUyV2a8cBbw0QQ8JV7g/b7F5hdAavnCpljXtz74vG+0MNvitOPC1DlvtOjseA6zu+UG7dtUtv9RTl2Jfnhx03MWeXYRclRTBt16Qx1enRvSQx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301473; c=relaxed/simple;
	bh=mmxDR6oGDRvXSqQQJsylXSrQdtaNXjmn6TeRPkIXa1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWRdv6nw7TewcL6YKTXM2g/ndP0vVJ2VLURxEz/8ixYHrOrpufunLLyx9kNCy7Q2vT97AY5VDIWzBiHJpiQURCdol3Pp3kCKW+Hw91iAmuSUD9HtFs9Sv+Lj7qozGGCKIZ+OW6YYiN8ULYTXq/vPZar0DTW0SpyVaLSKF3NNYLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qW5BAt9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qW5BAt9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6366EC19424;
	Sat, 28 Feb 2026 17:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301473;
	bh=mmxDR6oGDRvXSqQQJsylXSrQdtaNXjmn6TeRPkIXa1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW5BAt9GGaW7VD3CgEbDe2HNG0AmFLFXjjbl5ZXzjmmUHlcLWNgQZnQT38n69EGw9
	 ML8aYi9XHTfMvQxEQbMG0re0KkCaBkWu33W6i6/1xk14igp335kYZy5Kl53NOOUlK3
	 CUSlUB/fKQ0Y+85WMnU9evmqBb3bNElnChpJ5ls/+YEgL67G4CZIPKmUsa5/M0Zn5s
	 VvsC5oe4+SRnIbJTEhofrlqV8MSTf0/MXYWL6JtwBikDh8bvJTtL84dUDyGt1FAJAX
	 /H+9WkYGFSe5XrLnBGf3teoMBMLEPnuY/kZv4Fw4H15qxk3WFq1mEpDvVNFX9Craca
	 LWIIPx2/FSTQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Yen <thomasyen@google.com>,
	Stable Tree <stable@vger.kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 658/752] scsi: ufs: core: Flush exception handling work when RPM level is zero
Date: Sat, 28 Feb 2026 12:46:09 -0500
Message-ID: <20260228174750.1542406-658-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Yen <thomasyen@google.com>

[ Upstream commit f8ef441811ec413717f188f63d99182f30f0f08e ]

Ensure that the exception event handling work is explicitly flushed during
suspend when the runtime power management level is set to UFS_PM_LVL_0.

When the RPM level is zero, the device power mode and link state both
remain active. Previously, the UFS core driver bypassed flushing exception
event handling jobs in this configuration. This created a race condition
where the driver could attempt to access the host controller to handle an
exception after the system had already entered a deep power-down state,
resulting in a system crash.

Explicitly flush this work and disable auto BKOPs before the suspend
callback proceeds. This guarantees that pending exception tasks complete
and prevents illegal hardware access during the power-down sequence.

Fixes: 57d104c153d3 ("ufs: add UFS power management support")
Signed-off-by: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260129165156.956601-1-thomasyen@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 022810b524e96..755aa9c0017df 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9878,6 +9878,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		ufshcd_disable_auto_bkops(hba);
+		flush_work(&hba->eeh_work);
 		goto vops_suspend;
 	}
 
-- 
2.51.0

