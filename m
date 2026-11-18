Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054879;
	b=37Rb/huAxLdiDCCRLnKBrzPIesJehWcxFTGsqkZ1L48R5mxuKYx7MDXPS4c+1Qhdt4La
	 LUugmRSVTqY0Fjdbmzq/QCQXqgjz5otZ7OFhS+ivNW/aSc/cLtROqZXlp3RnUZziAFTjk
	 /7ZBfC3kdkiQG0cDtcTntcLQdYvPy1zGri/RGH9jqw+VX/vbhA72ShGgEDnZbED4N8vcH
	 agr2IX3AjieV5aUsMtbV1E79uheh6xnorlBRggT0zE0LADaTAJiRv8QVGamsm/4czHiVm
	 72isS8N4XWjHVpkMjuxXO6vkAJRq9TB3Wq7UmJEPoKBt6H/gvk4ygFljKliUfjvBrNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0WE3hGpCN59PUykNWdIqdARcJ1x+ESeqi6DroPGLSg=;
	b=n65eWnDcS+tWCgdJ3kwmRpyttsmo1bsJv0Wu40lY/4fMakrXIs1J09CwkDYtaxe6zTkC
	 2hpfrrGespJQ8iyanlH9/uux+3jao7XtNry7FyTKNt0xUPiUxv89VxOYn1cllc6MR/7pu
	 VhUGMWnB+VjU2fZX/eIjt/DtVYWv6WpuvfNXNkVmSQEYnXKIGhPn7AFSoeXkSrAKOVEpQ
	 WS5nmQ+odcnDg+m5su88ROms3gLxTGkUfYWOjRNAJ7FrvSjQzddazJwOxHYiwN8m6RYXs
	 S4lIKtYDXt/hKY+xB2vZwiPupD1AaED+aWCV6/30P7/2+x8KdjVndDuuaLoZXRwpjtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZU4Zblk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F99606A320;
	Thu, 19 Nov 2026 02:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZU4Zblk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99921F000C4;
	Thu, 19 Nov 2026 02:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054879;
	bh=L0WE3hGpCN59PUykNWdIqdARcJ1x+ESeqi6DroPGLSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZU4Zblk9OPejjePee6rtpW5U0zfnQWA9KwSMqWyaHvSwiR41jP4rD8UK5BBMgQcjs
	 triLdb0Q+n1HdkIec31kKXarwIJ67MgDQpwOTvDnojTdUQ5oUnBq5ILA8E965fNUhx
	 XjVsWMqLeQGZi8PDmR4FdI2pT7tzvsWGWALSJSGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1433/2214] scsi: mpi3mr: Code refactor of IOC init - part2
Date: Wed, 18 Nov 2026 15:51:49 +0100
Message-ID: <20261118150108.511177119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 59bd9cfe3fa07234e34cc2406e97481b3398c2d6 ]

Move the IOC initialization's bring up logic to mpi3mr_bring_ioc_ready()
routine.

Link: https://lore.kernel.org/r/20211220141159.16117-14-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bcf0a5bed59a ("scsi: mpi3mr: Fix out-of-bounds reply frame access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 167 +++++++++++++++++---------------
 1 file changed, 89 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d0d50566e1ee2..952fc6dda2fac 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -10,6 +10,10 @@
 #include "mpi3mr.h"
 #include <linux/io-64-nonatomic-lo-hi.h>
 
+static int
+mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
+static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
+
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
 	spinlock_t *write_queue_lock)
@@ -995,26 +999,105 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
  * Set Enable IOC bit in IOC configuration register and wait for
  * the controller to become ready.
  *
- * Return: 0 on success, -1 on failure.
+ * Return: 0 on success, appropriate error on failure.
  */
 static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 {
-	u32 ioc_config, timeout;
-	enum mpi3mr_iocstate current_state;
+	u32 ioc_config, ioc_status, timeout;
+	int retval = 0;
+	enum mpi3mr_iocstate ioc_state;
+	u64 base_info;
 
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
+	base_info = lo_hi_readq(&mrioc->sysif_regs->ioc_information);
+	ioc_info(mrioc, "ioc_status(0x%08x), ioc_config(0x%08x), ioc_info(0x%016llx) at the bringup\n",
+	    ioc_status, ioc_config, base_info);
+
+	/*The timeout value is in 2sec unit, changing it to seconds*/
+	mrioc->ready_timeout =
+	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
+	    MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT) * 2;
+
+	ioc_info(mrioc, "ready timeout: %d seconds\n", mrioc->ready_timeout);
+
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	ioc_info(mrioc, "controller is in %s state during detection\n",
+	    mpi3mr_iocstate_name(ioc_state));
+
+	if (ioc_state == MRIOC_STATE_BECOMING_READY ||
+	    ioc_state == MRIOC_STATE_RESET_REQUESTED) {
+		timeout = mrioc->ready_timeout * 10;
+		do {
+			msleep(100);
+		} while (--timeout);
+
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		ioc_info(mrioc,
+		    "controller is in %s state after waiting to reset\n",
+		    mpi3mr_iocstate_name(ioc_state));
+	}
+
+	if (ioc_state == MRIOC_STATE_READY) {
+		ioc_info(mrioc, "issuing message unit reset (MUR) to bring to reset state\n");
+		retval = mpi3mr_issue_and_process_mur(mrioc,
+		    MPI3MR_RESET_FROM_BRINGUP);
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		if (retval)
+			ioc_err(mrioc,
+			    "message unit reset failed with error %d current state %s\n",
+			    retval, mpi3mr_iocstate_name(ioc_state));
+	}
+	if (ioc_state != MRIOC_STATE_RESET) {
+		mpi3mr_print_fault_info(mrioc);
+		ioc_info(mrioc, "issuing soft reset to bring to reset state\n");
+		retval = mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
+		    MPI3MR_RESET_FROM_BRINGUP);
+		if (retval) {
+			ioc_err(mrioc,
+			    "soft reset failed with error %d\n", retval);
+			goto out_failed;
+		}
+	}
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state != MRIOC_STATE_RESET) {
+		ioc_err(mrioc,
+		    "cannot bring controller to reset state, current state: %s\n",
+		    mpi3mr_iocstate_name(ioc_state));
+		goto out_failed;
+	}
+	mpi3mr_clear_reset_history(mrioc);
+	retval = mpi3mr_setup_admin_qpair(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to setup admin queues: error %d\n",
+		    retval);
+		goto out_failed;
+	}
+
+	ioc_info(mrioc, "bringing controller to ready state\n");
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_config |= MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
 	timeout = mrioc->ready_timeout * 10;
 	do {
-		current_state = mpi3mr_get_iocstate(mrioc);
-		if (current_state == MRIOC_STATE_READY)
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		if (ioc_state == MRIOC_STATE_READY) {
+			ioc_info(mrioc,
+			    "successfully transistioned to %s state\n",
+			    mpi3mr_iocstate_name(ioc_state));
 			return 0;
+		}
 		msleep(100);
 	} while (--timeout);
 
-	return -1;
+out_failed:
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	ioc_err(mrioc,
+	    "failed to bring to ready state,  current state: %s\n",
+	    mpi3mr_iocstate_name(ioc_state));
+	return retval;
 }
 
 /**
@@ -3383,10 +3466,6 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 {
 	int retval = 0;
-	enum mpi3mr_iocstate ioc_state;
-	u64 base_info;
-	u32 timeout;
-	u32 ioc_status, ioc_config;
 	struct mpi3_ioc_facts_data facts_data;
 
 	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
@@ -3401,74 +3480,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		}
 	}
 
-	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-
-	ioc_info(mrioc, "SOD status %x configuration %x\n",
-	    ioc_status, ioc_config);
-
-	base_info = lo_hi_readq(&mrioc->sysif_regs->ioc_information);
-	ioc_info(mrioc, "SOD base_info %llx\n",	base_info);
-
-	/*The timeout value is in 2sec unit, changing it to seconds*/
-	mrioc->ready_timeout =
-	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
-	    MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT) * 2;
-
-	ioc_info(mrioc, "IOC ready timeout %d\n", mrioc->ready_timeout);
-
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	ioc_info(mrioc, "IOC in %s state during detection\n",
-	    mpi3mr_iocstate_name(ioc_state));
-
-	if (ioc_state == MRIOC_STATE_BECOMING_READY ||
-	    ioc_state == MRIOC_STATE_RESET_REQUESTED) {
-		timeout = mrioc->ready_timeout * 10;
-		do {
-			msleep(100);
-		} while (--timeout);
-
-		ioc_state = mpi3mr_get_iocstate(mrioc);
-		ioc_info(mrioc,
-		    "IOC in %s state after waiting for reset time\n",
-		    mpi3mr_iocstate_name(ioc_state));
-	}
-
-	if (ioc_state == MRIOC_STATE_READY) {
-		retval = mpi3mr_issue_and_process_mur(mrioc,
-		    MPI3MR_RESET_FROM_BRINGUP);
-		if (retval) {
-			ioc_err(mrioc, "Failed to MU reset IOC error %d\n",
-			    retval);
-		}
-		ioc_state = mpi3mr_get_iocstate(mrioc);
-	}
-	if (ioc_state != MRIOC_STATE_RESET) {
-		mpi3mr_print_fault_info(mrioc);
-		retval = mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
-		    MPI3MR_RESET_FROM_BRINGUP);
-		if (retval) {
-			ioc_err(mrioc,
-			    "%s :Failed to soft reset IOC error %d\n",
-			    __func__, retval);
-			goto out_failed;
-		}
-	}
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	if (ioc_state != MRIOC_STATE_RESET) {
-		retval = -1;
-		ioc_err(mrioc, "Cannot bring IOC to reset state\n");
-		goto out_failed;
-	}
-
-	retval = mpi3mr_setup_admin_qpair(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to setup admin Qs: error %d\n",
-		    retval);
-		goto out_failed;
-	}
-
 	retval = mpi3mr_bring_ioc_ready(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "Failed to bring ioc ready: error %d\n",
-- 
2.53.0



