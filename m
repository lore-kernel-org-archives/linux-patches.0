Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8079613B287;
	Tue, 14 May 2024 11:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684933; cv=none; b=ZwAYh8QpgyTN7ZgKSr2rNZCb8wnNBOSinpFsSWa2LfqCtj5vaIe2gmBjbybKlJyYPUsCS7f5XDzidKZXmS0VMQzjRKQlF4M8Xynh2iQmu9M58Oinoz/daJtkTzc1yWAYVHPI0/AZJ3/T4bVMy2Qebyhyy/tG/ANNhxe7y2AC8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684933; c=relaxed/simple;
	bh=sQYxwAFUEBS+GVyYzB9etnK9UCDcvAnTkjl6/n39E4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+hzuwmVtXeIbRHoZG2naaCuoJojBDkmBfmHsxZ5VbB7MqK7+rTYXwTzKeObrMU3QNYykSwQsCqEx/1uqvMLQO3BuZhzLsU+UyYqAkp5Tjo/CGy1I64RdmWb8kQD9Pesu5wyul/8Ht0UZIxJQaFoSyLNav7kJYrGpbGExtQHaSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZZ8SMZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZZ8SMZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7E8C2BD10;
	Tue, 14 May 2024 11:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684933;
	bh=sQYxwAFUEBS+GVyYzB9etnK9UCDcvAnTkjl6/n39E4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZZ8SMZNcmwJGORFLtxujBQq2hsa/iPIItqr0y18EOI3ELPR/Xs4Xm6h0QvKJMi5o
	 F/mY29gQeSnJGr/leTOao6ai+k8XKOKx6C50nAnYAu7fbusTTe1mjOuX2AphOX96P/
	 ML943ebEBCGSIfkOxMb5ZvT7gezskT/rlnEuU/LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/301] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Date: Tue, 14 May 2024 12:16:21 +0200
Message-ID: <20240514101036.405301679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 429846b4b6ce9853e0d803a2357bb2e55083adf0 ]

When the "storcli2 show" command is executed for eHBA-9600, mpi3mr driver
prints this WARNING message:

  memcpy: detected field-spanning write (size 128) of single field "bsg_reply_buf->reply_buf" at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 (size 1)
  WARNING: CPU: 0 PID: 12760 at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 mpi3mr_bsg_request+0x6b12/0x7f10 [mpi3mr]

The cause of the WARN is 128 bytes memcpy to the 1 byte size array "__u8
replay_buf[1]" in the struct mpi3mr_bsg_in_reply_buf. The array is intended
to be a flexible length array, so the WARN is a false positive.

To suppress the WARN, remove the constant number '1' from the array
declaration and clarify that it has flexible length. Also, adjust the
memory allocation size to match the change.

Suggested-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20240323084155.166835-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 2 +-
 include/uapi/scsi/scsi_bsg_mpi3mr.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9dacbb8570c93..aa5b535e6662b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1345,7 +1345,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	if ((mpirep_offset != 0xFF) &&
 	    drv_bufs[mpirep_offset].bsg_buf_len) {
 		drv_buf_iter = &drv_bufs[mpirep_offset];
-		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) - 1 +
+		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) +
 					   mrioc->reply_sz);
 		bsg_reply_buf = kzalloc(drv_buf_iter->kern_buf_len, GFP_KERNEL);
 
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index 907d345f04f93..353183e863e47 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -382,7 +382,7 @@ struct mpi3mr_bsg_in_reply_buf {
 	__u8	mpi_reply_type;
 	__u8	rsvd1;
 	__u16	rsvd2;
-	__u8	reply_buf[1];
+	__u8	reply_buf[];
 };
 
 /**
-- 
2.43.0



