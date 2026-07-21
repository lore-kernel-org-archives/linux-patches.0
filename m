Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF09546F4A1;
	Tue, 21 Jul 2026 20:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664051; cv=none; b=SP34+ObqPUd84WCiDQjqVdz4IDut1ahiJsbT/lpz5thDJUX/Rg1TCFw7HCEeLnvaezTbCipphAnGptuIpjZ+u7DhHoXRJopYNWk/rxqEd5ZJVimzOXpX4Slw5Jx0mY2eJdWImgSNoy4D65OSMshuq2bTOnANz/64ZkNbb/Xk3LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664051; c=relaxed/simple;
	bh=DZfxdxsve5TPvyRb5GKfBS7i2E8WHh+RbZ2bDCQHr1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9L7Z3/TBaP31BjtROcOujkvjkwsvzqGGqL6hYnLKXbWPBIFCvwKn6zrVWmYFGDnxsQ+QHOzrebzS7MCvy9jmFnYWXBR6YzVGwT7oKYWhSRgUKj2X2L2qH6vaqBVhE42WiSV+HNKr9VJIaQRiqsaFuGtUrbNotp9iZv5jbscL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2JEjsnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2JEjsnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314BE1F000E9;
	Tue, 21 Jul 2026 20:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664050;
	bh=13fsy+mMG5fo4gRlsOf7XTiRlVLiSd8V3rvnSAKmmhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2JEjsnj13s/mFnjlDokH+OJ9LUKcsgShh0X26sVZyYKUIRdQrEBwQ0kWQjCS0D6e
	 60NegCiEefEHqw6JuI72TFQt8+FtVwb4eC/0lD35nAyKsItMO8pAqh5Jm0LKYUy+6F
	 o+x5v8v9QZgueGJlblEHBiGMGq3eVFus1/oeVbcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 1017/1276] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Tue, 21 Jul 2026 17:24:20 +0200
Message-ID: <20260721152508.760605144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8192,6 +8192,7 @@ lpfc_sli4_driver_resource_setup(struct l
 			goto out_free_bsmbx;
 		}
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
@@ -8317,8 +8318,6 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_sg_dma_buf;
 	}
 
-	mempool_free(mboxq, phba->mbox_mem_pool);
-
 	/* Verify OAS is supported */
 	lpfc_sli4_oas_verify(phba);
 


