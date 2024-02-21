Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39976A8D6;
	Wed, 21 Feb 2024 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521794; cv=none; b=Nbj54CCqrbdRsiziY4/BOrLod27nnPDuZtlrry5eMeZa4iQAoXbC5QB6kWeS/w3ewud2HUEvlkqaKZNhBrltPmXxu0/9wNWzmP4Yu4rfQVTzQCq88ZYkGdoFRbcQu//uIz/+id/OXSMjven/kfDP7+R2jav21lYEJw2p49XQbIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521794; c=relaxed/simple;
	bh=dv7q2iV/qLgrRt5kA80/FNCDvgx76HwlWBjaVJ55UQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOrHC3T/7e8AqrzK17o9C6rGup3bEuFp4aEOAlzSpdcrRCE+Z5qCgY8cAxU/wJZbl5ATBs/23tc+sFhT9lkcpJ/PY8ytNL+fIAWaA/bfgETPwoNMbLwbmgk/KKyE/riuoYy2CJJATnx9WSfK+yqbjmOUBGkGa1xs2OH5lfXvK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVw9FYAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVw9FYAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8E2C433C7;
	Wed, 21 Feb 2024 13:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521794;
	bh=dv7q2iV/qLgrRt5kA80/FNCDvgx76HwlWBjaVJ55UQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVw9FYAoeMnyUwlHH18c+DZjZZtiPf2TW2bGbReOP51wm8cbd7Tr+XTNvPe+btE79
	 zv1hREEzqQyyQbwc5PO+ArsAjJuYfIIDETy19rzq2xOmPMHncEoiz3OZPmoQpoLVac
	 T5QSkcRDQ2TJtwQRle6nx0nQp9VIcQO9QHFUXIY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Duncan <lduncan@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 179/202] scsi: Revert "scsi: fcoe: Fix potential deadlock on &fip->ctlr_lock"
Date: Wed, 21 Feb 2024 14:08:00 +0100
Message-ID: <20240221125937.613728448@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Duncan <lduncan@suse.com>

commit 977fe773dcc7098d8eaf4ee6382cb51e13e784cb upstream.

This reverts commit 1a1975551943f681772720f639ff42fbaa746212.

This commit causes interrupts to be lost for FCoE devices, since it changed
sping locks from "bh" to "irqsave".

Instead, a work queue should be used, and will be addressed in a separate
commit.

Fixes: 1a1975551943 ("scsi: fcoe: Fix potential deadlock on &fip->ctlr_lock")
Signed-off-by: Lee Duncan <lduncan@suse.com>
Link: https://lore.kernel.org/r/c578cdcd46b60470535c4c4a953e6a1feca0dffd.1707500786.git.lduncan@suse.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -330,17 +330,16 @@ static void fcoe_ctlr_announce(struct fc
 {
 	struct fcoe_fcf *sel;
 	struct fcoe_fcf *fcf;
-	unsigned long flags;
 
 	mutex_lock(&fip->ctlr_mutex);
-	spin_lock_irqsave(&fip->ctlr_lock, flags);
+	spin_lock_bh(&fip->ctlr_lock);
 
 	kfree_skb(fip->flogi_req);
 	fip->flogi_req = NULL;
 	list_for_each_entry(fcf, &fip->fcfs, list)
 		fcf->flogi_sent = 0;
 
-	spin_unlock_irqrestore(&fip->ctlr_lock, flags);
+	spin_unlock_bh(&fip->ctlr_lock);
 	sel = fip->sel_fcf;
 
 	if (sel && ether_addr_equal(sel->fcf_mac, fip->dest_addr))
@@ -710,7 +709,6 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr
 {
 	struct fc_frame *fp;
 	struct fc_frame_header *fh;
-	unsigned long flags;
 	u16 old_xid;
 	u8 op;
 	u8 mac[ETH_ALEN];
@@ -744,11 +742,11 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr
 		op = FIP_DT_FLOGI;
 		if (fip->mode == FIP_MODE_VN2VN)
 			break;
-		spin_lock_irqsave(&fip->ctlr_lock, flags);
+		spin_lock_bh(&fip->ctlr_lock);
 		kfree_skb(fip->flogi_req);
 		fip->flogi_req = skb;
 		fip->flogi_req_send = 1;
-		spin_unlock_irqrestore(&fip->ctlr_lock, flags);
+		spin_unlock_bh(&fip->ctlr_lock);
 		schedule_work(&fip->timer_work);
 		return -EINPROGRESS;
 	case ELS_FDISC:
@@ -1725,11 +1723,10 @@ static int fcoe_ctlr_flogi_send_locked(s
 static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
-	unsigned long flags;
 	int error;
 
 	mutex_lock(&fip->ctlr_mutex);
-	spin_lock_irqsave(&fip->ctlr_lock, flags);
+	spin_lock_bh(&fip->ctlr_lock);
 	LIBFCOE_FIP_DBG(fip, "re-sending FLOGI - reselect\n");
 	fcf = fcoe_ctlr_select(fip);
 	if (!fcf || fcf->flogi_sent) {
@@ -1740,7 +1737,7 @@ static int fcoe_ctlr_flogi_retry(struct
 		fcoe_ctlr_solicit(fip, NULL);
 		error = fcoe_ctlr_flogi_send_locked(fip);
 	}
-	spin_unlock_irqrestore(&fip->ctlr_lock, flags);
+	spin_unlock_bh(&fip->ctlr_lock);
 	mutex_unlock(&fip->ctlr_mutex);
 	return error;
 }
@@ -1757,9 +1754,8 @@ static int fcoe_ctlr_flogi_retry(struct
 static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
-	unsigned long flags;
 
-	spin_lock_irqsave(&fip->ctlr_lock, flags);
+	spin_lock_bh(&fip->ctlr_lock);
 	fcf = fip->sel_fcf;
 	if (!fcf || !fip->flogi_req_send)
 		goto unlock;
@@ -1786,7 +1782,7 @@ static void fcoe_ctlr_flogi_send(struct
 	} else /* XXX */
 		LIBFCOE_FIP_DBG(fip, "No FCF selected - defer send\n");
 unlock:
-	spin_unlock_irqrestore(&fip->ctlr_lock, flags);
+	spin_unlock_bh(&fip->ctlr_lock);
 }
 
 /**


