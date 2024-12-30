Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5015E8B;
	Mon, 30 Dec 2024 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574202; cv=none; b=ktJRpn2sByNxqWsYZa0YZL353VRmV+zyyZUlg53ALt9CJAmvD1sXThNnPvw7vNTZw5neEy2MvJj2V3k/u3DxfUxCGns2ZGLOPbaR3IM10gUa3dwooiCisWluFeqvMAy76L9f9OBPX141GcN48emlqOKqm/fbIE5UfMcoMflopcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574202; c=relaxed/simple;
	bh=kdVdRFH1EhmZ3GgSxwGiADriWYXhovL5NNGK3gCTXos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ7ebppidGmI92LLR6TgIT5mq07rdjc2izM2P5ivBsJVvNMAQSkjzTY10L2l1y2JAnsmPYsfP+6HS5IKSgoxyRH0yxoi0JOlnmtfXV5KanLzp4WDAOtYoGtRlfkWUx+aCc3AytuwB9gtmqnvys+zTKrlxC5bezdhg8wxetA+kLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kocC7bh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kocC7bh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D74C4CED0;
	Mon, 30 Dec 2024 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574202;
	bh=kdVdRFH1EhmZ3GgSxwGiADriWYXhovL5NNGK3gCTXos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kocC7bh0UWIHIhxYQJzdRW/BVMWgVKcsWF9kNyjDJrvX3sH7WK5dcexJSGn6RVhsw
	 5ggQRB9JWIwVBY/e3oIaVunVtitk5LFfjXIXrSYiw0qY+NmHw26RcTd1Z/1Lw4tD3C
	 Tf0TOIQEmhbJw6T0M15VPnLfdDzW+8xhM0y3l8EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/114] scsi: mpi3mr: Synchronize access to ioctl data buffer
Date: Mon, 30 Dec 2024 16:43:04 +0100
Message-ID: <20241230154220.680330108@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 367ac16e5ff2dcd6b7f00a8f94e6ba98875cb397 ]

The driver serializes ioctls through a mutex lock but access to the
ioctl data buffer is not guarded by the mutex. This results in multiple
user threads being able to write to the driver's ioctl buffer
simultaneously.

Protect the ioctl buffer with the ioctl mutex.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 36 ++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 01f035f9330e..10b8e4dc64f8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2329,6 +2329,15 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if (!mrioc)
 		return -ENODEV;
 
+	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
+		return -ERESTARTSYS;
+
+	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
+		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		return -EAGAIN;
+	}
+
 	if (!mrioc->ioctl_sges_allocated) {
 		dprint_bsg_err(mrioc, "%s: DMA memory was not allocated\n",
 			       __func__);
@@ -2339,13 +2348,16 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		karg->timeout = MPI3MR_APP_DEFAULT_TIMEOUT;
 
 	mpi_req = kzalloc(MPI3MR_ADMIN_REQ_FRAME_SZ, GFP_KERNEL);
-	if (!mpi_req)
+	if (!mpi_req) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		return -ENOMEM;
+	}
 	mpi_header = (struct mpi3_request_header *)mpi_req;
 
 	bufcnt = karg->buf_entry_list.num_of_entries;
 	drv_bufs = kzalloc((sizeof(*drv_bufs) * bufcnt), GFP_KERNEL);
 	if (!drv_bufs) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2353,6 +2365,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	dout_buf = kzalloc(job->request_payload.payload_len,
 				      GFP_KERNEL);
 	if (!dout_buf) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2360,6 +2373,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	din_buf = kzalloc(job->reply_payload.payload_len,
 				     GFP_KERNEL);
 	if (!din_buf) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2435,6 +2449,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 					(mpi_msg_size > MPI3MR_ADMIN_REQ_FRAME_SZ)) {
 				dprint_bsg_err(mrioc, "%s: invalid MPI message size\n",
 					__func__);
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				rval = -EINVAL;
 				goto out;
 			}
@@ -2447,6 +2462,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (invalid_be) {
 			dprint_bsg_err(mrioc, "%s: invalid buffer entries passed\n",
 				__func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2454,12 +2470,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
 			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
 				       __func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
 		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
 			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
 				       __func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2472,6 +2490,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc, "%s:%d: invalid data transfer size passed for function 0x%x din_size = %d, dout_size = %d\n",
 			       __func__, __LINE__, mpi_header->function, din_size,
 			       dout_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2480,6 +2499,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x din_size=%d\n",
 		    __func__, __LINE__, mpi_header->function, din_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2487,6 +2507,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x dout_size = %d\n",
 		    __func__, __LINE__, mpi_header->function, dout_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2497,6 +2518,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			dprint_bsg_err(mrioc, "%s:%d: invalid message size passed:%d:%d:%d:%d\n",
 				       __func__, __LINE__, din_cnt, dout_cnt, din_size,
 			    dout_size);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2544,6 +2566,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				continue;
 			if (mpi3mr_map_data_buffer_dma(mrioc, drv_buf_iter, desc_count)) {
 				rval = -ENOMEM;
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				dprint_bsg_err(mrioc, "%s:%d: mapping data buffers failed\n",
 					       __func__, __LINE__);
 			goto out;
@@ -2556,20 +2579,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		sense_buff_k = kzalloc(erbsz, GFP_KERNEL);
 		if (!sense_buff_k) {
 			rval = -ENOMEM;
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			goto out;
 		}
 	}
 
-	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex)) {
-		rval = -ERESTARTSYS;
-		goto out;
-	}
-	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
-		rval = -EAGAIN;
-		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
-		mutex_unlock(&mrioc->bsg_cmds.mutex);
-		goto out;
-	}
 	if (mrioc->unrecoverable) {
 		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
 		    __func__);
-- 
2.39.5



