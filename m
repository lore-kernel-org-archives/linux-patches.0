Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D961EA8A
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DC1C433AB;
	Fri, 21 Jul 2023 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956444;
	bh=eCsDnf1oQhVzWVgJLDqVu4WT5qNqn9sFUv95P53tH7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkdYyrSCAvgqBqt0kaGtxFp4UAI/eWZt1P0DkwPM9yTbannTI1mcsBQzSpgDYJ4Tl
	 3/v+pxjGePGWuKP9s3O2FMyEF636PpAfyVTddJ/SFoSW1gXVcpqFduVVRUkie4QKD0
	 sbUnwr4e+jcAW0ASltyaaXcXNfPThzl/5AgqIvI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.4 167/292] scsi: mpi3mr: Propagate sense data for admin queue SCSI I/O
Date: Fri, 21 Jul 2023 18:04:36 +0200
Message-ID: <20230721160536.085039803@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sathya Prakash <sathya.prakash@broadcom.com>

commit f762326b2baa86ae647e2ba6832bc87e238f68ad upstream.

Copy the sense data to internal driver buffer when the firmware completes
any SCSI I/O command sent through admin queue with sense data for further
use.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Link: https://lore.kernel.org/r/20230531184025.3803-1-sumit.saxena@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -402,6 +402,11 @@ static void mpi3mr_process_admin_reply_d
 				memcpy((u8 *)cmdptr->reply, (u8 *)def_reply,
 				    mrioc->reply_sz);
 			}
+			if (sense_buf && cmdptr->sensebuf) {
+				cmdptr->is_sense = 1;
+				memcpy(cmdptr->sensebuf, sense_buf,
+				       MPI3MR_SENSE_BUF_SZ);
+			}
 			if (cmdptr->is_waiting) {
 				complete(&cmdptr->done);
 				cmdptr->is_waiting = 0;


