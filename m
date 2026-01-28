Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A528B242D7F;
	Wed, 28 Jan 2026 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615269; cv=none; b=D5/hewVnMn8bfk19t0NeG16HIYqG+hTNIGCCfPVrC/IVb+jvqW7hFsnB8TYx2ZxR0yjyImiaTesDPLzbr/HWo6nQYds2Ou8gb1K/7qSQkSoMj9B9Bq1yj6mgevRbQDmC66AsSQ7MME1RPTM9x+Mna2Io+LKe7xTk0L3uhejeub8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615269; c=relaxed/simple;
	bh=UGkgN0We3p0cNpJoQMa0fwKJy8zieScxVXqgyP2vGgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG66L11xEmfwTObAxpzhHVCocfbOB38XPRwo8eNP+mMkbRw8ugpuo1UicBkKea2z8HdYJ/8jbb1aOt+E9/md44LHsg3bmpq8QlkvsQUAvetk5qm7xa4JnEf7KKonh4MSGFy/idnLuZAXsqHXFBcP541VqQ3Qlac7+ck5mS/+stQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0UKmiWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0UKmiWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5357C4CEF1;
	Wed, 28 Jan 2026 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615269;
	bh=UGkgN0We3p0cNpJoQMa0fwKJy8zieScxVXqgyP2vGgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0UKmiWgK8GWe+3uhFz0p2ovAzzhhshB0CyZbkmbtPH8O9++kWhZ+wfkHPcHBUxYI
	 HIFBMyoUh+ZWlumNjpk58JNtabYlcZS0cj4zFsEfOhDuA5QtnuIalY4mTlpjwROcF8
	 XpTDRy5rBuZKaXBq0ptQxA3AG9+oBf6xPWJducNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 129/169] s390/ap: Fix wrong APQN fill calculation
Date: Wed, 28 Jan 2026 16:23:32 +0100
Message-ID: <20260128145338.651897043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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
@@ -268,7 +268,7 @@ static enum ap_sm_wait ap_sm_write(struc
 		list_move_tail(&ap_msg->list, &aq->pendingq);
 		aq->requestq_count--;
 		aq->pendingq_count++;
-		if (aq->queue_count < aq->card->hwinfo.qd) {
+		if (aq->queue_count < aq->card->hwinfo.qd + 1) {
 			aq->sm_state = AP_SM_STATE_WORKING;
 			return AP_SM_WAIT_AGAIN;
 		}


