Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0DE33120E;
	Tue, 31 Mar 2026 16:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975637; cv=none; b=Yg8oNpvlI7JLnXlMvKHbef9rsmcY6cOgffvG+orC0GvGVVGbY/9fLY5QeA8SUBZ5rjNYLfHNPdV2cnrAnXoVxXShPtX4clo86AtfMQ+q8mWuwM7K8N7+KJO3ibXJSWpbPHgrfsU5QE4LoNa2YAb6lKMVtF+YqyOMU0IMDNtM1mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975637; c=relaxed/simple;
	bh=31a3nOUvG6HptSH8Bh9yAPiDymOOOPUuAAi0449/nJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+IuM695awBrYYbI5RRYGTSThhM6+fruCJz1SYigvt2D/7PAoIIQjm7OiusLjT/iFc9D0PrTfFfKoz6mXuM6t2cF15S3Oo1OS5kl86CwpO47I11rFqRensSCaPW4lHXG+RvrRCYpMTYRSZWGzekgY17dLWbhPeLq5yklV+k6FWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9OsQ0QE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9OsQ0QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57E2C19423;
	Tue, 31 Mar 2026 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975637;
	bh=31a3nOUvG6HptSH8Bh9yAPiDymOOOPUuAAi0449/nJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9OsQ0QE2M3mju6sKeEZp6CknCJqKIeFl7+/KO7XsX+AMZ/zD70Rv8dVXLOxomyk0
	 qDUD+U53P6ZWPu+RDm/QupnKc1rB2ZjdqEEVdGE93RjXaT/gEc6lSwyA9HuO5oxK5Q
	 7Ly5auSwsga62cQ0cONvsB6fEC2IyzKAaK4jPF6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/244] scsi: mpi3mr: Clear reset history on ready and recheck state after timeout
Date: Tue, 31 Mar 2026 18:19:38 +0200
Message-ID: <20260331161742.742056253@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit dbd53975ed4132d161b6a97ebe785a262380182d ]

The driver retains reset history even after the IOC has successfully
reached the READY state. That leaves stale reset information active during
normal operation and can mislead recovery and diagnostics.  In addition, if
the IOC becomes READY just as the ready timeout loop exits, the driver
still follows the failure path and may retry or report failure incorrectly.

Clear reset history once READY is confirmed so driver state matches actual
IOC status. After the timeout loop, recheck the IOC state and treat READY
as success instead of failing.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://patch.msgid.link/20260225082622.82588-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 3a057a0f0d809..25e8186f5df49 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1514,6 +1514,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			ioc_info(mrioc,
 			    "successfully transitioned to %s state\n",
 			    mpi3mr_iocstate_name(ioc_state));
+			mpi3mr_clear_reset_history(mrioc);
 			return 0;
 		}
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
@@ -1533,6 +1534,15 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 		elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
 	} while (elapsed_time_sec < mrioc->ready_timeout);
 
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state == MRIOC_STATE_READY) {
+		ioc_info(mrioc,
+		    "successfully transitioned to %s state after %llu seconds\n",
+		    mpi3mr_iocstate_name(ioc_state), elapsed_time_sec);
+		mpi3mr_clear_reset_history(mrioc);
+		return 0;
+	}
+
 out_failed:
 	elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
 	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout - 60))) {
-- 
2.51.0



