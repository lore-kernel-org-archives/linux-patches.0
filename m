Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9F179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F228C433D6;
	Wed, 30 Nov 2022 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834533;
	bh=bRLZHKh2zNHAUYhN/K+kEkdojDudkiQXqx8uEY36ZG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzrXY6HMVZeZKcSlvxe6CiH4VF9Sw1LeJjY8euAXf8B12+qnEUjUubwEaFMrZg6AF
	 n1eLeekUEdx6euXe5PTXuYHxY4wIrPs+KzfNT19ljwt7kzinBdT8Jo+SMNhXry9r+0
	 ZltzF/1gh1xhoR7fWi6HhCz5lw5tU9rRknrxb90E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 261/289] scsi: mpi3mr: Suppress command reply debug prints
Date: Wed, 30 Nov 2022 19:24:06 +0100
Message-Id: <20221130180550.018070844@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 7d21fcfb409500dc9b114567f0ef8d30b3190dee ]

After it receives command reply, mpi3mr driver checks command result. If
the result is not zero, it prints out command information. This debug
information is confusing since they are printed even when the non-zero
result is expected. "Power-on or device reset occurred" is printed for Test
Unit Ready command at drive detection. Inquiry failure for unsupported VPD
page header is also printed. They are harmless but look like failures.

To avoid the confusion, print the command reply debug information only when
the module parameter logging_level has value MPI3_DEBUG_SCSI_ERROR= 64, in
same manner as mpt3sas driver.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20221111014449.1649968-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index bfa1165e23b6..1b4d1e562de8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2930,7 +2930,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
-	    (scmd->cmnd[0] != ATA_16)) {
+	    (scmd->cmnd[0] != ATA_16) &&
+	    mrioc->logging_level & MPI3_DEBUG_SCSI_ERROR) {
 		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
 		    scmd->result);
 		scsi_print_command(scmd);
-- 
2.35.1



