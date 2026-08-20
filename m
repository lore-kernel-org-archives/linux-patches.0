Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC78246781;
	Thu, 20 Aug 2026 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244258; cv=none; b=ZjZRYf+fO9K8oBUjav0ekx+3aKIRej3w2JBTj3LGjexcO9ImAIAS6fVvvY2csPOBmSq9JtS1kdDwYysuAGHin1eYRShMcNwYCYKXxubgZsVT/o4Eu8Ia3ZYkS/KKZhMW6eQrjG1G4Jv1v2SzVcHnvg7Cjl+fvpJKUlzsBEMT0vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244258; c=relaxed/simple;
	bh=RO4U0xdkl60vJMZDjwi1UVeI/WdPSnNet8CRn7Qs0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPnh1fYaHR6S6btxnc8H8TITEjsWthziHkmj4N/jpvggC5eca4rakxSB8ZkCpiV5JupAhVglKK9x2/ytAPhgjtTnn99NCgOqvkl+JmL+NOf+VRs8ylPCV7kb93M35WvIHnAZruZwIaIyK0cIq8IMddj5YRSeuM16Ijf5BZ2MXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwgZQAQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwgZQAQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8561F000E9;
	Thu, 20 Aug 2026 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244257;
	bh=rWpbTMxVi+99Txa0JKFLELck6Kf8qroJ8ZcK/dalREs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwgZQAQayVxjLQfbqCModjuRak5dhWtZoNQ+8L1LuykdgU8/GoGgQqOfjflpdBPQR
	 X+UY5Qy7jZ5B1SzQ8VUjrvFomvQcga4LQHaaBEBH03s4kzhVuKMpuEKOhmdtrWp7pA
	 thfi+86gN3hNuT2ItWRrfoLnJk6o5E3V2as9qkvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/235] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Thu, 20 Aug 2026 16:55:43 +0200
Message-ID: <20260820145219.696784871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6811,6 +6811,7 @@ lpfc_sli4_driver_resource_setup(struct l
 			goto out_free_bsmbx;
 		}
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
@@ -6932,8 +6933,6 @@ lpfc_sli4_driver_resource_setup(struct l
 	if (!phba->lpfc_cmd_rsp_buf_pool)
 		goto out_free_sg_dma_buf;
 
-	mempool_free(mboxq, phba->mbox_mem_pool);
-
 	/* Verify OAS is supported */
 	lpfc_sli4_oas_verify(phba);
 


