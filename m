Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4FB1DEFE0;
	Tue,  8 Oct 2024 13:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393487; cv=none; b=b5xiwlHNGueumnMZ73U7N6Bu98Y3V4fZ1ar8cMqmica5CjTqnkRzdONZNNivZ3ga8IA3jZs21jzOFCF0hOKkBrFvXniI9crRRZVW4Rj0AAYEpoYytGYGuceB/W1bnhe8aGYnrGclNNqB9aULKLt2f7RntGn2pzV3LG9QKrH+XOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393487; c=relaxed/simple;
	bh=9ZSEP9Jqzwgw7KAr+5mW6xWB1javn0Hn+GRt96n4PMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPss41ZUBVsSENjmQdu2OZshNXPICNwJDPbBdGWfGQxgQwHA5zzxGuh6nSuCrdRXMPJCuOw+zNlt8MxWM+bPpJQgo/paGk7x1eX9VkD+qByb7z4g6rwHP/7XenfxMhYuCfzjiIcDbBBJd/KjSSPU/ydvEQ9Y6Le9PtAkgo1CRGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxWQZveL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxWQZveL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0501C4CECC;
	Tue,  8 Oct 2024 13:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393486;
	bh=9ZSEP9Jqzwgw7KAr+5mW6xWB1javn0Hn+GRt96n4PMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxWQZveLfurKJo8SD7VSlVjt50zneUf7qn2/CRyzpSvYQlOGjZKRGHHz3g5eCD+h2
	 0NKHQOYcoKvmH4jQoXYdmAuIXOL0Jt3zo26A+49f0hDBUDPkT+bPdau54FGbmH6Cj0
	 4o4OcK42It7TVO7RIla382lIldwsXeUWPPhEVZYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/386] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
Date: Tue,  8 Oct 2024 14:06:52 +0200
Message-ID: <20241008115635.995042765@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



