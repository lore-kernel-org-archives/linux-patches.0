Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6165C25783A;
	Wed, 28 Jan 2026 16:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616042; cv=none; b=AHX+DFOt41A9QMkEwqYCiTdS8DXSWLjTqnrWNyZUvfGrh/nvpgDvbqAFps7pqFudX8QsnVcA8bHlY904noSm0fNhYbnOK4Vu5Ah6S36WfN6d1k31Idu3Hp5A6XYdwJBJB0FasPGKJJEd+65qxj80BR9mH06JUirmA0elZY0Qy0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616042; c=relaxed/simple;
	bh=3gss+Hwjr+/ztrTunU2GXG/ljS4+2VMGAB6vddMfxp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJKCm4/WHROST7RDsBXD8wwdtSPmQ3JFi8w+QsDMPydUHp+f4CbjtLeN5DukPW9zVmt3CRSqkD/7MZGfg6OogVsrgnMtRF6b1aucAWPPM/uQfKT60BZk2uI+SH44e6ApyeRTYfW9j+fyBqAq1yB4TDOsw9XMd7cmP1dF83vmY6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Py44ZQHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Py44ZQHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9DFC4CEF7;
	Wed, 28 Jan 2026 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616042;
	bh=3gss+Hwjr+/ztrTunU2GXG/ljS4+2VMGAB6vddMfxp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Py44ZQHSiSBqie6xRTywK6KoloC4EK1uv1aSW7SWn4lLlzh/w/A4h448kLi5xX1Th
	 nJzC/SnAVHtiFD9LhydWy1go1bXsfWj35hcazxKIrzTLBERdY/EjxHOAL9FSYiAMkI
	 aRgifX1ksMTK+lCF3sJufyFmZPQHELlXhzggu/qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 189/227] s390/ap: Fix wrong APQN fill calculation
Date: Wed, 28 Jan 2026 16:23:54 +0100
Message-ID: <20260128145351.247387591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 3317785a8803db629efc759d811d0f589d3a0b2d upstream.

The upper limit of the firmware queue fill state for each APQN
is reported by the hwinfo.qd field. This field shows the
numbers 0-7 for 1-8 queue spaces available. But the exploiting
code assumed the real boundary is stored there and thus stoppes
queuing in messages one tick too early.

Correct the limit calculation and thus offer a boost
of 12.5% performance for high traffic on one APQN.

Fixes: d4c53ae8e4948 ("s390/ap: store TAPQ hwinfo in struct ap_card")
Cc: stable@vger.kernel.org
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/ap_card.c  |    2 +-
 drivers/s390/crypto/ap_queue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/crypto/ap_card.c
+++ b/drivers/s390/crypto/ap_card.c
@@ -44,7 +44,7 @@ static ssize_t depth_show(struct device
 {
 	struct ap_card *ac = to_ap_card(dev);
 
-	return sysfs_emit(buf, "%d\n", ac->hwinfo.qd);
+	return sysfs_emit(buf, "%d\n", ac->hwinfo.qd + 1);
 }
 
 static DEVICE_ATTR_RO(depth);
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -269,7 +269,7 @@ static enum ap_sm_wait ap_sm_write(struc
 		list_move_tail(&ap_msg->list, &aq->pendingq);
 		aq->requestq_count--;
 		aq->pendingq_count++;
-		if (aq->queue_count < aq->card->hwinfo.qd) {
+		if (aq->queue_count < aq->card->hwinfo.qd + 1) {
 			aq->sm_state = AP_SM_STATE_WORKING;
 			return AP_SM_WAIT_AGAIN;
 		}


