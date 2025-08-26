Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E52F352FF3;
	Tue, 26 Aug 2025 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219079; cv=none; b=k+uehQ1CpD1z86KpPQaDv6PNW4QLwlNkfYxQ40nkHzHd3phJrXM7FbVfdlhw2djli1vhVin2tzSSfkQnLyuxIChnYkhZf0EvK0S7rjLgI3pHbPBEm71ZfjZF2xiNBHpgGPfiZHKRtwZ30DbC4tK95CfS2vgW/Rp9CqU0xHeUyNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219079; c=relaxed/simple;
	bh=6QaZesHp6vqHrTqvrkCcw02EyWl4XSZh9Blo6qDDW5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfjknLSILtgcMpo+Hh2BXxI6DRLtQh7v68oIlSj/65Se45cXrBtHM6Kx4KZ+Wjikwap45ONu5V8ZTVx2RkAgy6hxuRWjqHK11txHETIzc9I+AppIX57QesQz2xMqSr9h43XSJUKY1nAvIXF88q8ra5mvVq9fduIgANAlwz3qHCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbDPn9WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbDPn9WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DE3C4CEF1;
	Tue, 26 Aug 2025 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219078;
	bh=6QaZesHp6vqHrTqvrkCcw02EyWl4XSZh9Blo6qDDW5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbDPn9WSh6ebdk9g8XBVcFV5TpK/laz1XIlDfIksflTx/fxyWMNPp+vkukrSJx48I
	 V285nJooIJUfdiFyf8YLBHRgQTccg0+YaFri+E5gyEOnvXCQ02i4kXn73tOyubR8Bj
	 wau2XVcXiFGFN08W68GTGX3XzAzx2MbXj8hUlKLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/403] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Tue, 26 Aug 2025 13:09:30 +0200
Message-ID: <20250826110913.569846590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 6698796282e828733cde3329c887b4ae9e5545e9 ]

If a call to lpfc_sli4_read_rev() from lpfc_sli4_hba_setup() fails, the
resultant cleanup routine lpfc_sli4_vport_delete_fcp_xri_aborted() may
occur before sli4_hba.hdwqs are allocated.  This may result in a null
pointer dereference when attempting to take the abts_io_buf_list_lock for
the first hardware queue.  Fix by adding a null ptr check on
phba->sli4_hba.hdwq and early return because this situation means there
must have been an error during port initialization.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250618192138.124116-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f238e0f41f07..1d58895b3943 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -469,6 +469,10 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
 		return;
 
+	/* may be called before queues established if hba_setup fails */
+	if (!phba->sli4_hba.hdwq)
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	for (idx = 0; idx < phba->cfg_hdw_queue; idx++) {
 		qp = &phba->sli4_hba.hdwq[idx];
-- 
2.39.5



