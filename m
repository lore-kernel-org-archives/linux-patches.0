Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE9F550DB2;
	Wed,  9 Sep 2026 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962921; cv=none; b=s22hhKTtgTnREVd/p/MsMyhPVU6+dtrqQvCRDkWgqRrN/V9tToealHqjzcLlp2W0Y32BQviflbBB6i7rrNNs6HFJdki8hXqB4llxaiDDc2Ze0tcU0Ni5PhawNb712WzWaLiR7Z6WoaNJbrVGOYBB9MPs3r0qeByTGAIEiRovDvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962921; c=relaxed/simple;
	bh=39jNFOIuIsisqA3CE6eg2kRiO8sWXT+CMgPbyCVyRso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWIkpP6AkDAMaR2oUVCvOgvB6QMVfgyHA8PnJDisSnPw1NJtyQ4FBR1EaaMe4mXxs5Xq99XmBOPk6VmhGygVltu2EpoqkEujXlzfhPicSAbr6JC1PE1UQQxzP6i4HYRlu7lTEBUsaeI8fJi0EExAX1HawLQNa853wH0QmIukD2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYrNNg5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYrNNg5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778321F00A3A;
	Wed,  9 Sep 2026 14:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962920;
	bh=olD6Gfn+Ek3HV7ocdLFyDzpy+ATOkvcIRC/Xxj/4CBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYrNNg5jXn42N4iPV2n4Za7EPNPJummhX8PnqmqQUR29FEd6mZJE2r8dDRO9YXviH
	 0/SRhnI5rnrE1AI/wz9SRkN8ueC6q5a9FFIy/1W7IcVe7C5kG0Dxm+GPpNA/Del3zP
	 LiU/JUnfjyMvPzTUUa4+6gI4EX5JBotAoZOhKa4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 435/556] scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_iocb()
Date: Wed,  9 Sep 2026 15:41:55 +0200
Message-ID: <20260909134245.907840153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 3ba019bdd89d931499d9476456b5d9c7ab7fa753 upstream.

qla24xx_process_response_queue() advances ring_ptr past the head IOCB
before dispatching, so by the time __qla_consume_iocb() runs, ring_ptr
already points at the first continuation IOCB. The function however
looped purex->entry_count times starting at ring_ptr. As entry_count
includes the head, this consumed one entry too many: it stamped
RESPONSE_PROCESSED on the next, unrelated IOCB and advanced the ring
past it, silently dropping a legitimate firmware response. The head
IOCB's signature was also never marked.

Mark the head processed and account for it, then consume only the
entry_count - 1 continuation IOCBs, matching __qla_copy_purex_to_buffer().

Fixes: fac2807946c1 ("scsi: qla2xxx: edif: Add extraction of auth_els from the wire")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-14-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -205,6 +205,17 @@ void __qla_consume_iocb(struct scsi_qla_
 	struct purex_entry_24xx *purex = *pkt;
 
 	entry_count_remaining = purex->entry_count;
+
+	/*
+	 * The caller already advanced ring_ptr past the head IOCB, so mark
+	 * the head processed and account for it here, then consume only the
+	 * continuation IOCBs that follow.
+	 */
+	((response_t *)purex)->signature = RESPONSE_PROCESSED;
+	/* flush signature */
+	wmb();
+	--entry_count_remaining;
+
 	while (entry_count_remaining > 0) {
 		new_pkt = rsp_q->ring_ptr;
 		*pkt = new_pkt;


