Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F01DFDE;
	Mon, 24 Feb 2025 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407917; cv=none; b=BQaJ4lrkq4FRqGsWRHRgJ1zdXCjatyPpywNludsPCxy901N+P0hB54Rw7FfF2S0JB9g6gyproYCFB9GNoaDp7f42BVJHvVxvg5KQzUL/Bd9TjNZjdrjlaZoCwdjAGk3F1ZBPGNqxN/HbxaG9pbZ4U01bHhzkdhDj1zLCFw+pIzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407917; c=relaxed/simple;
	bh=seVyuiVNnBpDu5cYKwqJkrph/naTdwMHfK9HtxDLbZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shGSKg8dXSCZ/FDNIRtK4T9CVSA+pSDL+Ig+yUKYFxh0QHe+XxgvRLkaI+PCpdfNmWrCb6S4k8hCUvbfIBmSP0huwNwcYN1chZ8L1xAABX4ZFaGGQNanxTnA9xv85P1AaIKo3nUEhm8lLcnc2YYw93yUvbFpxl6orw/Fdue7LCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUraBksD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUraBksD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA77C4CED6;
	Mon, 24 Feb 2025 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407916;
	bh=seVyuiVNnBpDu5cYKwqJkrph/naTdwMHfK9HtxDLbZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUraBksD4wIl9Rpto9Y4HWN2N4581/WKlfRq4pIfPhWDV/HnKPeIEa4LePlcbcn9r
	 0bqoAeSQ7WqnTMp5BYj1MC0fFMAoE9lkjrzvfYBGkJAup8qa/iJGUF0rnAAA1icJMu
	 O/SRxqyxS9a3s4J7caSfI1f8zGpryQhXB8pWLSVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/140] scsi: core: Handle depopulation and restoration in progress
Date: Mon, 24 Feb 2025 15:34:05 +0100
Message-ID: <20250224142604.819212066@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97def2619ecf2..2f54e1a853099 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -775,6 +775,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
 				case 0x24: /* depopulation in progress */
+				case 0x25: /* depopulation restore in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c627deedc1fa..fe694fec16b51 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2309,6 +2309,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
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



