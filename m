Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA101AAE08;
	Mon, 14 Oct 2024 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916920; cv=none; b=dq1YL7sKvWy8uHijFGQ1GlcSshfGZhAd9AnnTUmEUvEfCM+l0WIITmlNVotp0w0MTntARcMFw0Auzo9tMU4gxDMjuSazPY8acMsi4XxMZm+12zNoEYv4O0MON1hvx9py9PIX6G2qmh09LpqeMAEXhOAMJp1ASmdvtOilKNFp8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916920; c=relaxed/simple;
	bh=swVuxx/eSO45LJd9xF8bW/FZJhB7IwBO1C8L65Msm74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKkZ2igqfhpkGpx+EmJehZWX02idqUOOMMnT9YayuYxQ5dycY7x82ZKbnF3pxsViHRazQRB1jEpHV7PGtQvlcV4SiuBPEE0f4iZ8fpJFmju/4JrHrK6wR4BsCzSdSxgxYwz9UHpYYyuEF4w19SbIxL4uSbsFbSyvveD2j7p+5a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4rsIl9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4rsIl9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3105C4CEC3;
	Mon, 14 Oct 2024 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916920;
	bh=swVuxx/eSO45LJd9xF8bW/FZJhB7IwBO1C8L65Msm74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4rsIl9DYuWgJfZi7t6bdFOiG4t9mQ/r+xXM6xU4fnaJe+ysGlpdWR/NTPCkFlfGa
	 uzkA1T6KlK2uEZfL8NbyhUOuXM6vsSiioC/r0nujfrN67ACHVOUs2Ghafh8+i3mNO+
	 iUga96ayeE9CjAf37o9vNbcOyL9S1zAKlsIe70bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/213] scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()
Date: Mon, 14 Oct 2024 16:20:07 +0200
Message-ID: <20241014141046.912856147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 93bcc5f3984bf4f51da1529700aec351872dbfff ]

During HBA stress testing, a spam of received PLOGIs exposes a resource
recovery bug causing leakage of lpfc_sqlq entries from the global
phba->sli4_hba.lpfc_els_sgl_list.

The issue is in lpfc_els_flush_cmd(), where the driver attempts to recover
outstanding ELS sgls when walking the txcmplq.  Only CMD_ELS_REQUEST64_CRs
and CMD_GEN_REQUEST64_CRs are added to the abort and cancel lists.  A check
for CMD_XMIT_ELS_RSP64_WQE is missing in order to recover LS_ACC usages of
the phba->sli4_hba.lpfc_els_sgl_list too.

Fix by adding CMD_XMIT_ELS_RSP64_WQE as part of the txcmplq walk when
adding WQEs to the abort and cancel list in lpfc_els_flush_cmd().  Also,
update naming convention from CRs to WQEs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240912232447.45607-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f67d72160d36e..ebe84bb7bb3dd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9649,11 +9649,12 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED && !mbx_tmo_err)
 			continue;
 
-		/* On the ELS ring we can have ELS_REQUESTs or
-		 * GEN_REQUESTs waiting for a response.
+		/* On the ELS ring we can have ELS_REQUESTs, ELS_RSPs,
+		 * or GEN_REQUESTs waiting for a CQE response.
 		 */
 		ulp_command = get_job_cmnd(phba, piocb);
-		if (ulp_command == CMD_ELS_REQUEST64_CR) {
+		if (ulp_command == CMD_ELS_REQUEST64_WQE ||
+		    ulp_command == CMD_XMIT_ELS_RSP64_WQE) {
 			list_add_tail(&piocb->dlist, &abort_list);
 
 			/* If the link is down when flushing ELS commands
-- 
2.43.0



