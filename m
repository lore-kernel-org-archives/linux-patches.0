Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9A2505A7;
	Wed,  5 Mar 2025 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197055; cv=none; b=f19awpMgVuSdr3ZibSWylWEMtODGDOwIufiQTVj03+gakmnh50albfCfu4GdZV62GFKijDiBRPjpFWJ8aHYEChnimLcJePf3GHU8ccpT8A+6x69L3JTDR9vkw/gnpCG6mU9CiatmcXRzecFKWSN4oX/vgVw9rhQrIh0fuuVuq8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197055; c=relaxed/simple;
	bh=Si585bt1deFdfrF6jStS8s//M9AZwvdcSLMAMWEM9y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/ef+a/Tsi8m/TOeZUSjBOOL8XFLBLMZ0co5VPPX6cJx9r+EDIpaWpxZZxEZoY/r3KcHKSd4z3rwvr0bG9YGhfEpjkek0MM5Easn/Fyy8W6rhCUvZxMiAAB5z7K/+MVytBruSiq7VNESxjBScPsujHAboF+tg0/vE7dOY1REliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8BatX3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8BatX3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF96C4CED1;
	Wed,  5 Mar 2025 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197054;
	bh=Si585bt1deFdfrF6jStS8s//M9AZwvdcSLMAMWEM9y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8BatX3Z7HacMI7BZJmmOGTJ0DxtUz9LGuDlTofrwupFEynmijwkSOU02EEODdN1E
	 gPV+iqV6C5SPhP78NAX5uOdTf/BcWZzFsrLLZ/r/2zBex4FMgl4zfqFPRFoNKx2zLf
	 u6c46PHKOzljteLUtvwzPTNpejJBYsB4V/220vU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/176] scsi: core: Handle depopulation and restoration in progress
Date: Wed,  5 Mar 2025 18:46:32 +0100
Message-ID: <20250305174506.390732678@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit 2bbeb8d12404cf0603f513fc33269ef9abfbb396 ]

The default handling of the NOT READY sense key is to wait for the device
to become ready. The "wait" is assumed to be relatively short. However
there is a sub-class of NOT READY that have the "... in progress" phrase in
their additional sense code and these can take much longer.  Following on
from commit 505aa4b6a883 ("scsi: sd: Defer spinning up drive while SANITIZE
is in progress") we now have element depopulation and restoration that can
take a long time.  For example, over 24 hours for a 20 TB, 7200 rpm hard
disk to depopulate 1 of its 20 elements.

Add handling of ASC/ASCQ: 0x4,0x24 (depopulation in progress)
and ASC/ASCQ: 0x4,0x25 (depopulation restoration in progress)
to sd.c . The scsi_lib.c has incomplete handling of these
two messages, so complete it.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Link: https://lore.kernel.org/r/20231015050650.131145-1-dgilbert@interlog.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9ff7c383b8ac ("scsi: core: Do not retry I/Os during depopulation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 1 +
 drivers/scsi/sd.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5c5954b78585e..b8d58120badde 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -783,6 +783,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
 				case 0x24: /* depopulation in progress */
+				case 0x25: /* depopulation restore in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b35ef52d9c632..c3006524eb039 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2191,6 +2191,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				break;	/* unavailable */
 			if (sshdr.asc == 4 && sshdr.ascq == 0x1b)
 				break;	/* sanitize in progress */
+			if (sshdr.asc == 4 && sshdr.ascq == 0x24)
+				break;	/* depopulation in progress */
+			if (sshdr.asc == 4 && sshdr.ascq == 0x25)
+				break;	/* depopulation restoration in progress */
 			/*
 			 * Issue command to spin up drive when not ready
 			 */
-- 
2.39.5



