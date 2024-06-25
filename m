Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2E41465A8;
	Tue, 25 Jun 2024 09:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308801; cv=none; b=uJCVOwpECWEBq+zLud9QJON7zAXX2C7lByarYo72ROQpowXjpNdPZTqmXmQg5WnSStsd59t4MWDN+iYGQolIAhbWWPsoJvjOCbSlWfdzihFqPbBepxwg3BJ4oruM/2bfojxh2ue3Q8y9N7D5uwMxjEpVDx/rwsBYjWPs6koF8bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308801; c=relaxed/simple;
	bh=p29PLAnKFUCMxrYSrvvPiYfjythCtG5CuhoSYr1z+6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOB6D9xaTnvPzw98MlT3IiNeZiUY3oXFA/egX0YjXYQEEl3bfcFLk+Gv8DM83Uuhj5YygRnZl+ZMhc/VOGCC/ZW356Mrw2+5CDYYj86VAB+gwarRdWlPIDf0X6zW44f7A3lQQNPxrOtnBJDB5eghedYUrOJth0xsmjAktVrmVUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rNawRiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rNawRiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC67AC32781;
	Tue, 25 Jun 2024 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308801;
	bh=p29PLAnKFUCMxrYSrvvPiYfjythCtG5CuhoSYr1z+6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rNawRiDbqiJnYagY3fWhEb9Pkl1ZDy+F1BjxNbhrDkzkOqiL+RqutZR38YY8L1G1
	 SHQm/OTTtJhsv5z2FMcGB3DMmflBI7MDSpUBDehfz9Jp89elULXyy44ngudJlukwAP
	 qHgvT3iPeMaUJKdbvJ3qILOGDa5b30P5QMKTNIis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.9 245/250] wifi: ath12k: check M3 buffer size as well whey trying to reuse it
Date: Tue, 25 Jun 2024 11:33:23 +0200
Message-ID: <20240625085557.455792857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

commit 05090ae82f44570fefddb4e1be1d7e5770d6de40 upstream.

Currently in recovery/resume cases, we do not free M3 buffer but
instead will reuse it. This is done by checking m3_mem->vaddr: if it
is not NULL we believe M3 buffer is ready and go ahead to reuse it.

Note that m3_mem->size is not checked. This is safe for now because
currently M3 reuse logic only gets executed in recovery/resume cases
and the size keeps unchanged in either of them.

However ideally the size should be checked as well, to make the code
safer. So add the check there. Now if that check fails, free old M3
buffer and reallocate a new one.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: 303c017821d8 ("wifi: ath12k: fix kernel crash during resume")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240425021740.29221-1-quic_bqiang@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c |   36 +++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2685,6 +2685,19 @@ out:
 	return ret;
 }
 
+static void ath12k_qmi_m3_free(struct ath12k_base *ab)
+{
+	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
+
+	if (!m3_mem->vaddr)
+		return;
+
+	dma_free_coherent(ab->dev, m3_mem->size,
+			  m3_mem->vaddr, m3_mem->paddr);
+	m3_mem->vaddr = NULL;
+	m3_mem->size = 0;
+}
+
 static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 {
 	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
@@ -2715,8 +2728,14 @@ static int ath12k_qmi_m3_load(struct ath
 		m3_len = fw->size;
 	}
 
-	if (m3_mem->vaddr)
-		goto skip_m3_alloc;
+	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
+	if (m3_mem->vaddr) {
+		if (m3_mem->size >= m3_len)
+			goto skip_m3_alloc;
+
+		/* Old buffer is too small, free and reallocate */
+		ath12k_qmi_m3_free(ab);
+	}
 
 	m3_mem->vaddr = dma_alloc_coherent(ab->dev,
 					   m3_len, &m3_mem->paddr,
@@ -2740,19 +2759,6 @@ out:
 	return ret;
 }
 
-static void ath12k_qmi_m3_free(struct ath12k_base *ab)
-{
-	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
-
-	if (!m3_mem->vaddr)
-		return;
-
-	dma_free_coherent(ab->dev, m3_mem->size,
-			  m3_mem->vaddr, m3_mem->paddr);
-	m3_mem->vaddr = NULL;
-	m3_mem->size = 0;
-}
-
 static int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 {
 	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;


