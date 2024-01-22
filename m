Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64097657B3;
	Tue, 23 Jan 2024 01:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971770; cv=none; b=D1LIAV8XcddDjlRDuzmJiK5XreU7379GHt9Z3C0iE/hCwwaQ3rYUMU754eTrjzIz9GyIKiHRnYMOPKM6nD6n9IDbFABYVcAGzN06aDew6hN3eLCtW7qohoSvXSzb3r6CEl1wzlVD0d5HnjBjk85ZAVrBRpI2zSSvpCDSX1Oi6vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971770; c=relaxed/simple;
	bh=cqhft99F011V+jt7/vZN+giKC1R/TQZ2hPMyImaBVJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGEbpsFNmjxiOP+EU7CJxZeQwn3n5WLHoT7zAqEOt6K4Udsw4vQ24paZFn+qMjqk80kpZl/DTedPkXI5Y7kNWzKHP6y4qAmnTZ8XCaT4Cb9tujMOn3719miJYA2Bde5fL4zuvAor9ySFiOxkBJx0popFk838Ij23VXS1Hpgl4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs0driVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs0driVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21414C433F1;
	Tue, 23 Jan 2024 01:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971770;
	bh=cqhft99F011V+jt7/vZN+giKC1R/TQZ2hPMyImaBVJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bs0driVP1Xvx79Dc0EVKTxFonwpKVqN7EX3HOuRPVPAe1RcA69bxy46Q5MA7cL2Em
	 WuBUokRL0N3FnfRqqyk/If3Z9TDaLxrWsaMgE2MbKsmOc8RhJ3Qc4hu5brTLCFn1cu
	 g3/VVk09G2EogZBF7piKyo0j2cc4RAmVLCYkKWw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 292/417] scsi: mpi3mr: Block PEL Enable Command on Controller Reset and Unrecoverable State
Date: Mon, 22 Jan 2024 15:57:40 -0800
Message-ID: <20240122235801.947209051@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth patil <chandrakanth.patil@broadcom.com>

commit f8fb3f39148e8010479e4b2003ba4728818ec661 upstream.

If a controller reset is underway or the controller is in an unrecoverable
state, the PEL enable management command will be returned as EAGAIN or
EFAULT.

Cc: <stable@vger.kernel.org> # v6.1+
Co-developed-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20231126053134.10133-4-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 08645a99ad6b..9dacbb8570c9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -223,6 +223,22 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 		return rval;
 	}
 
+	if (mrioc->unrecoverable) {
+		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
+			       __func__);
+		return -EFAULT;
+	}
+
+	if (mrioc->reset_in_progress) {
+		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
+		return -EAGAIN;
+	}
+
+	if (mrioc->stop_bsgs) {
+		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
+		return -EAGAIN;
+	}
+
 	sg_copy_to_buffer(job->request_payload.sg_list,
 			  job->request_payload.sg_cnt,
 			  &pel_enable, sizeof(pel_enable));
-- 
2.43.0



