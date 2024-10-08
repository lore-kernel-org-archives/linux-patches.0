Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA681DF75C;
	Tue,  8 Oct 2024 12:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390343; cv=none; b=MpJ4Rawy/nB1OxnOS3AsB843I0ATrTuFO+7ig6DCIhmDWoZlWO+RGjW7tnJsLX+gN5t0S7vjy0a8mAZVJPPXYI34beTf3WnhfhrKEjciDcYgqKaRdOZgo5+Iq2twoSPvZ2Dg1Ex12+8ojygtUQZYyaIUPlHxklGOSOVHpo2B4jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390343; c=relaxed/simple;
	bh=KFfyWytiyvURm99Q2UvbLqjXGlXzW2QDydv0aZ3AEpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV1Lwt1k/QL6wqnleWjRCVyL2nlylsr8batKk5fNknzZsHXDmAYVFmDqNacPL5tW6YsvCK3xqzj4gRteVoegJwAoW7BZ/B0bNb76hOJWo+sr8LbnSqfpNruRsphtevY1aVxrWfnYjL5HYYGBXIk3U7POzXS3WZ4bIg1Uz1tT1G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKXvkesi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKXvkesi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54703C4CECD;
	Tue,  8 Oct 2024 12:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390342;
	bh=KFfyWytiyvURm99Q2UvbLqjXGlXzW2QDydv0aZ3AEpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKXvkesiQF0ltfbjHvShGH8UmffYfWjCLkXeLKrI5UfvtCPNrXC/koyhZBWMYntci
	 OPb/v1sRPg8dbNk180EHKK8I/ZDv7rQskdlAcwRTbsl9iE+iVFAFXb3FZ3L9GB8hsQ
	 Wt7OghUi8mqzJTt//SSBgOFd/Yvvj6tRjGLu1HB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 229/482] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
Date: Tue,  8 Oct 2024 14:04:52 +0200
Message-ID: <20241008115657.316126926@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 1c71065df2df693d208dd32758171c1dece66341 ]

Following an incomplete transfer in MSG IN phase, the driver would not
notice the problem and would make use of invalid data. Initialize 'tmp'
appropriately and bail out if no message was received. For STATUS phase,
preserve the existing status code unless a new value was transferred.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/52e02a8812ae1a2d810d7f9f7fd800c3ccc320c4.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 00e245173320c..4fcb73b727aa5 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1807,8 +1807,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				return;
 			case PHASE_MSGIN:
 				len = 1;
+				tmp = 0xff;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
+				if (tmp == 0xff)
+					break;
 				ncmd->message = tmp;
 
 				switch (tmp) {
@@ -1996,6 +1999,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				break;
 			case PHASE_STATIN:
 				len = 1;
+				tmp = ncmd->status;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				ncmd->status = tmp;
-- 
2.43.0



