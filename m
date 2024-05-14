Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB4C139593;
	Tue, 14 May 2024 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682970; cv=none; b=gCnxQ8eyggtypovsSdkYPf373ibjmy3hmUor+Qvwp3R2g6m85MULPsN5co8hQncXK25ZwSot1XNXuJqunQdplvlmB/0NdxX8mfwpcT6hFujmnFMwPSBK3IUP1m3RiykFaX1lOfNDpOS7S5sbISGM9DGHg4ZqpI2N/MdYZ+HXQjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682970; c=relaxed/simple;
	bh=sJG/ypozmohnmk4GADWGKh3zZO6U48E87rD6BthPeYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSJxS/AuTrM86WeKurxVqDKCzKjoCZV/nZLuBe9ak94Z9u/vMkGM1k6KjQNgE6sDIOHDGNT8o4rXm8EMfN8FTefBb5R9ueIawITTEA1QLuunW/3z2xfaRiMczCuevrDM+/d1TtMM8jn3DJfplCO2s99uFiG6H+Z9wBzzL8S9dN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVhs4eT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVhs4eT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693EDC2BD10;
	Tue, 14 May 2024 10:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682970;
	bh=sJG/ypozmohnmk4GADWGKh3zZO6U48E87rD6BthPeYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVhs4eT+9Uv5w2fpgu71/xXQU9H/qAGe4fIR3SpARQwGVjrCAoRU+UwOABXlsXWWV
	 Kw5QE6JhSZmdggQHzEA+qPc0ttLgbkbw6useGSVaJaGMDhbH/Bw43XTD5TuGwR55K1
	 7ywOgmTJettYCjluWZ91OS2vCzDmDPS8sFv0WCG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 112/336] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Date: Tue, 14 May 2024 12:15:16 +0200
Message-ID: <20240514101042.832650019@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 0380996b5ad27..55d590b919476 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1644,7 +1644,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if ((mpirep_offset != 0xFF) &&
 	    drv_bufs[mpirep_offset].bsg_buf_len) {
 		drv_buf_iter = &drv_bufs[mpirep_offset];
-		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) - 1 +
+		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) +
 					   mrioc->reply_sz);
 		bsg_reply_buf = kzalloc(drv_buf_iter->kern_buf_len, GFP_KERNEL);
 
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index c72ce387286ad..30a5c1a593764 100644
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



