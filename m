Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B95F264FA0;
	Tue,  8 Apr 2025 11:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110546; cv=none; b=TkFmiTNz0urvNHF5qcX/EfRVFZ/+HKichBmcRDkkIL5Victpawv7Fn66V72RLfdwfB3hbLTh7MYGAlmxdYZoQU7UjMFcLVrD82ixCil/fdDKsglD5KTyCZN9YaLmSRKfjahPEGds0rZ5ivXta17xv9BQabB3PvTgda01gJpSDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110546; c=relaxed/simple;
	bh=ZQvfR2waPJA5OscUDvMwU1giLZWUehfUMJUhPOBbQi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpY+D93hNiiKc+ms6i+NDrYlt/M0JQuIiQ7XBSnCrC1sHoffJp0rdVsqN0NKSANavJW9bw3QnhiwSqgQEq+DQCnxgq3qQBr1NxwMzeBMRZmR6ypY6LXdr1Y7TlcGTk8wFFCvLi+bsW0GxhXjBqwkdVfL7xeWW/1k5aPfLC0rPEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH7N7Ghb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH7N7Ghb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC68BC4CEE5;
	Tue,  8 Apr 2025 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110546;
	bh=ZQvfR2waPJA5OscUDvMwU1giLZWUehfUMJUhPOBbQi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH7N7GhbB8MaFhrqvas+Xvx/MoOc4JEF0usk+fyjgZOqL23E4gd3JP4etO5XckMiS
	 1Grq1wT04s242WR37MgtaoEVbFzg4IYKeK2aB7uXsL7UVq31amBso2bmvYK8FWKwwZ
	 bXaf5GVEDXjW5JyY+VHfx5pz5rMqsUZDlVHjfnVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 104/731] scsi: mpi3mr: Fix locking in an error path
Date: Tue,  8 Apr 2025 12:40:01 +0200
Message-ID: <20250408104916.693064619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c733741ae1c3a5927f72664b0d760d5f4c14f96b ]

Make all error paths unlock rioc->bsg_cmds.mutex.

This patch fixes the following Clang -Wthread-safety errors:

drivers/scsi/mpi3mr/mpi3mr_app.c:2835:1: error: mutex 'mrioc->bsg_cmds.mutex' is not held on every path through here [-Werror,-Wthread-safety-analysis]
 2835 | }
      | ^
drivers/scsi/mpi3mr/mpi3mr_app.c:2332:6: note: mutex acquired here
 2332 |         if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
      |             ^
./include/linux/mutex.h:172:40: note: expanded from macro 'mutex_lock_interruptible'
  172 | #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
      |                                        ^

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Fixes: fb231d7deffb ("scsi: mpi3mr: Support for preallocation of SGL BSG data buffers part-2")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250210203936.2946494-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 7589f48aebc80..f4b5813e6fc4c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2339,6 +2339,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 
 	if (!mrioc->ioctl_sges_allocated) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		dprint_bsg_err(mrioc, "%s: DMA memory was not allocated\n",
 			       __func__);
 		return -ENOMEM;
-- 
2.39.5



