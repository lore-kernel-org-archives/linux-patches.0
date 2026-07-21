Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A12C3BA225;
	Tue, 21 Jul 2026 20:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667433; cv=none; b=azDv4ISZdHm5QF8dD/4l2TY4oM4bVuP/+RK+7YgS0heB+nvAH6FU7FK5GYtHsc2TE6LClniMGkI3ohT7eS5tJ4RmimT88UcCFSCtmI8nXCSn2pmDywzAP0baFiihyuP4u3of5S/HxpxWRZexSztst4JWTrdP4n+/jjLGXbrbb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667433; c=relaxed/simple;
	bh=f68sciPgVkpH3R1d4CpKO0WbjNa1Isft1tMeQ7YZYJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nor0woCVamkDRJt1GB2aPlNd3d4Dj796T2WNBoAShxn7NlgPf9VLvss0b+nffE/6qEyvGvixZn9ZQNDxaO1L1/+MPWZNCayVXsB0fe5alRmq7b3b6lVV7FmYZ8AhX/P4+yXqZJ9kRluY94qxvLsZWHGE+L/ememfy3AoDpynI24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Si8PrmDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Si8PrmDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7C41F000E9;
	Tue, 21 Jul 2026 20:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667432;
	bh=IQTJLs87n8YEjRHo0EYaSyhUg/d8vzDT5H3rP+zGHLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Si8PrmDBUzLCEFfixH3lnkSyUklRhpImMwgqynsCy+vKlg7ozmO8ctsQ1WK81tWpj
	 QmIaqTNyWumyWUcr+z3ax519WXVbAR4LU3rCtc+UAEaL+Fxy8l/Orm+eBwJjr+XBBr
	 LQxjGyYEgwCynLExgZIOHzLY0fQIaAgA7f5LsvBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 1057/1266] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Tue, 21 Jul 2026 17:24:54 +0200
Message-ID: <20260721152505.472086399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 1bd28625e25be549ee7c47532e7c3ef91c682410 upstream.

The memory allocated for mboxq using mempool_alloc() is not freed in
some of the early exit error paths. Fix that by moving the
mempool_free() call to an earlier point after last use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260707065304.949135-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8201,6 +8201,7 @@ lpfc_sli4_driver_resource_setup(struct l
 			goto out_free_bsmbx;
 		}
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
@@ -8326,8 +8327,6 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_sg_dma_buf;
 	}
 
-	mempool_free(mboxq, phba->mbox_mem_pool);
-
 	/* Verify OAS is supported */
 	lpfc_sli4_oas_verify(phba);
 


