Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6128547B438;
	Thu, 20 Aug 2026 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243557; cv=none; b=Oo/exUGYY6gIV7K70XlA0rMfkOXwVbzbf+X0gtRq7R2pAjX4V1s1UCvbdwytb5vE4bCIII46R3ovxYLoc6xZntvQkFj6O0+Y3n1tD/cta/Y4ll1YEdyvH57Sh9o0YvKS+Du0VFD2QdAWYJwZPzW3EcntrvrOoNkQOP3nQs9stTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243557; c=relaxed/simple;
	bh=sreJR2oqKxqZwHsmTacx27/TvvlVMs7wl4m3UcSl2ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4/dq+FgiH8gC/+GRWJ6huO7FqWnBavAqQm1MSufCaGsLaVwe2PxI6d1bjN9CkBnicBFHExZDWqGjHkxnuWCt+Paj/xZkNEPM+R64b8QAta8Gi1mwrY77sgRJD8MMNNKpuL7FXlR1B92WRK6OoHTa1FBPg5BYiCxyEjPEqL7z6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJLP0vzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJLP0vzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6D61F000E9;
	Thu, 20 Aug 2026 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243556;
	bh=6jq3cwbE90IrkbZfuMvGkbMxKcpOWeVjs5toeeSGoV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJLP0vzzx3GmMXaFrH2ZIMvoQG6lqzkUWxXMc1S7kLyXE6nDVhUTz5kn+kczDXnEF
	 NBFVm5UboFvf2rqD7MSFWHsHwrY22SbL5URdMfIWn54bn3xXlFv1IFESOIeKsvFtFr
	 HwPfebyXSx7yudKkwhwaAEOnYejgzW6Mvo29bghA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/272] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Thu, 20 Aug 2026 16:55:19 +0200
Message-ID: <20260820145235.318788171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 1bd28625e25be549ee7c47532e7c3ef91c682410 ]

The memory allocated for mboxq using mempool_alloc() is not freed in
some of the early exit error paths. Fix that by moving the
mempool_free() call to an earlier point after last use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260707065304.949135-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8010,6 +8010,7 @@ lpfc_sli4_driver_resource_setup(struct l
 			goto out_free_bsmbx;
 		}
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
@@ -8131,8 +8132,6 @@ lpfc_sli4_driver_resource_setup(struct l
 	if (!phba->lpfc_cmd_rsp_buf_pool)
 		goto out_free_sg_dma_buf;
 
-	mempool_free(mboxq, phba->mbox_mem_pool);
-
 	/* Verify OAS is supported */
 	lpfc_sli4_oas_verify(phba);
 


