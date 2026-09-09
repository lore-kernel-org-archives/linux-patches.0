Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CE255409C;
	Wed,  9 Sep 2026 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964197; cv=none; b=Z4HZ+l15U3Dxw1X9naxAKwB67BqbExXP95yzRHMdRfqH7Wh46e/EqgceL2i5wbz26CMxIToszwFaz9MlypXbY9oEofMa9K02mMQLitIu4xy8LMrgHmYELpy2uXWcNH+rK1wTIdLndtyy3yuUgWoEuBTfWOwN6tw2w/X9om0h97Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964197; c=relaxed/simple;
	bh=EShCowyBAt8FmqXpTqSmh3MWLj+Bah0uRWipeQuN5ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5WIoJtHRZXL/PtnImuHuDGoeMyHOu/eQbka8jR5PPphDooBJsvTAce0tu3k4s+ZdLctYYBNSIUn3k0XUlxX1LqMMbX3Bj8qvyVcT1Cbx/8mjn1Ng5DqYBlsKoi7GL7QJMZdW4YtfLmC7mFJoY6tcxNCwo/Nr27lfitTaN+jHjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fl8Bfn3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fl8Bfn3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397841F00A3A;
	Wed,  9 Sep 2026 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964196;
	bh=X8anXp122qaITeuIZwwqBNRHDE8qpZ9WKu/NJCf4nqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fl8Bfn3bgnQa6fiJ7IlGlCEacW6yFYzuR2GuAMa+MnNRrf2kz6bFUO0Y4g/nzNY/z
	 9p4cJb4FyVEiPEdc7/lIdn/tQD1yK0npIKdk6i0Fio34ZORWYDD0uSSsMO52T3xu+d
	 nxVHLEt/JV6u2sFzhtXnZTnFxDNUQF6u4FEP3A0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 340/583] scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_iocb()
Date: Wed,  9 Sep 2026 15:40:25 +0200
Message-ID: <20260909134249.773455163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


