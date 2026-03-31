Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1E7423A89;
	Tue, 31 Mar 2026 16:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976305; cv=none; b=aryjRvq/vGGT26rtXD+ptn1HUs/GJyU+Sta+gi2OQ+GZRsbHqA4XfodA7BOAjQkYoqsoGDa2BV/OZCjz7A1upEUW+9CxZu8jcT4ALHw2Y5JPCC/G5qQk0CN+VFe7lLMdMYsa4mMexBvbHhZ9Ho3Z2EBogwn9MShnmwi70YavIl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976305; c=relaxed/simple;
	bh=dNI89v9vR+yWr7EgX061Oa9F8falEHLob9RagXk1m7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl1KbS9D+6Semr4FVQPz9VVe4hZf9u5lw0U2FL1RRdzkW08frcoCVRcvE9CAnrwPlY2TYKD0gAagFG2Xby+DPi79lw8ex2aJB8vyoElR9SslLUptcNHM7QdDZC4qi4ket9sHcp74PYfTAFUyep4dlbn0lPTlBQr0rpG+hzAltiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLtECfhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLtECfhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E61C19423;
	Tue, 31 Mar 2026 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976305;
	bh=dNI89v9vR+yWr7EgX061Oa9F8falEHLob9RagXk1m7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLtECfhPq+Eg+0yCXMMEVe2HObAWqc2gLI4vI7RXsvBCV0pUT8Klanqoiukpr0NI6
	 W4UpXbTHR6p/LSigJPLutDggwZ4nUqQ0dfWh/46hvaRMuo6z+QJ5z2Gztw3Ii4NVoP
	 SELt2ahQwornUZH4axgHYSBd63sPFlsJVehNulHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/309] scsi: mpi3mr: Clear reset history on ready and recheck state after timeout
Date: Tue, 31 Mar 2026 18:19:04 +0200
Message-ID: <20260331161754.996955252@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8382afed12813..4c8d78b840fc9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1530,6 +1530,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			ioc_info(mrioc,
 			    "successfully transitioned to %s state\n",
 			    mpi3mr_iocstate_name(ioc_state));
+			mpi3mr_clear_reset_history(mrioc);
 			return 0;
 		}
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
@@ -1549,6 +1550,15 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
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



