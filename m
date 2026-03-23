Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784263B27C5;
	Mon, 23 Mar 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279177; cv=none; b=rHD5vo3V4OV/O2twOO7ebo08dhsmbWth4TrhXkevRAWzMoXw1lsX0KicdlDCDJGFTnlNJrjVUDHf1jT9ENOD3hAET7loSy56ax5kFVHSA2Fj4gfzlt+6Cg0IMCSibKVHzKbPUSkEXwczv15mdOIuSpeB79UPjCfh00o71il39YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279177; c=relaxed/simple;
	bh=ADEbv0+WP72UdrZRsIcrOF4paoBd5v+Ydj1+AGuZYoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJD0aGG12t/Ir5hxH9sPMkeFrf8oXXIhgFToarylX2Q/dpa72qA4v2NfM5kV+aHPVWpnBYjQ2tlRR/Trf2fbTP2NUj04cBAquLeMtiwxVA9FzMNKsW7ThWrR0mfXuRflTffnYSvWqrnP769rA0bOLMLLfoiv96h6Ba6Wm1HQoOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHbuj1ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHbuj1ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29BAC4CEF7;
	Mon, 23 Mar 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279177;
	bh=ADEbv0+WP72UdrZRsIcrOF4paoBd5v+Ydj1+AGuZYoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHbuj1ZKuPUWd96N81Sd0GtHoGUo0ZyqPTp1zcFLEXC1ukZ2s4blTRU0ZKYj/65VG
	 Z/gFua0YYUO7BlM0/xo6vODO2kwaayGYqJjYaPQA/OCa5cIuS4eGe5sHdxEf4da7tt
	 xCgtmmliQOaC6MOKhf6mK0SYyii6LTfKnR9rsHX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Genoud <richard.genoud@bootlin.com>,
	CHAMPSEIX Thomas <thomas.champseix@alstomgroup.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 499/567] soc: fsl: qbman: fix race condition in qman_destroy_fq
Date: Mon, 23 Mar 2026 14:46:59 +0100
Message-ID: <20260323134546.372073244@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@bootlin.com>

[ Upstream commit 014077044e874e270ec480515edbc1cadb976cf2 ]

When QMAN_FQ_FLAG_DYNAMIC_FQID is set, there's a race condition between
fq_table[fq->idx] state and freeing/allocating from the pool and
WARN_ON(fq_table[fq->idx]) in qman_create_fq() gets triggered.

Indeed, we can have:
         Thread A                             Thread B
    qman_destroy_fq()                    qman_create_fq()
      qman_release_fqid()
        qman_shutdown_fq()
        gen_pool_free()
           -- At this point, the fqid is available again --
                                           qman_alloc_fqid()
           -- so, we can get the just-freed fqid in thread B --
                                           fq->fqid = fqid;
                                           fq->idx = fqid * 2;
                                           WARN_ON(fq_table[fq->idx]);
                                           fq_table[fq->idx] = fq;
     fq_table[fq->idx] = NULL;

And adding some logs between qman_release_fqid() and
fq_table[fq->idx] = NULL makes the WARN_ON() trigger a lot more.

To prevent that, ensure that fq_table[fq->idx] is set to NULL before
gen_pool_free() is called by using smp_wmb().

Fixes: c535e923bb97 ("soc/fsl: Introduce DPAA 1.x QMan device driver")
Signed-off-by: Richard Genoud <richard.genoud@bootlin.com>
Tested-by: CHAMPSEIX Thomas <thomas.champseix@alstomgroup.com>
Link: https://lore.kernel.org/r/20251223072549.397625-1-richard.genoud@bootlin.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/qman.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index 7e9074519ad22..bcbf6bf2e8f45 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -1827,6 +1827,8 @@ EXPORT_SYMBOL(qman_create_fq);
 
 void qman_destroy_fq(struct qman_fq *fq)
 {
+	int leaked;
+
 	/*
 	 * We don't need to lock the FQ as it is a pre-condition that the FQ be
 	 * quiesced. Instead, run some checks.
@@ -1834,11 +1836,29 @@ void qman_destroy_fq(struct qman_fq *fq)
 	switch (fq->state) {
 	case qman_fq_state_parked:
 	case qman_fq_state_oos:
-		if (fq_isset(fq, QMAN_FQ_FLAG_DYNAMIC_FQID))
-			qman_release_fqid(fq->fqid);
+		/*
+		 * There's a race condition here on releasing the fqid,
+		 * setting the fq_table to NULL, and freeing the fqid.
+		 * To prevent it, this order should be respected:
+		 */
+		if (fq_isset(fq, QMAN_FQ_FLAG_DYNAMIC_FQID)) {
+			leaked = qman_shutdown_fq(fq->fqid);
+			if (leaked)
+				pr_debug("FQID %d leaked\n", fq->fqid);
+		}
 
 		DPAA_ASSERT(fq_table[fq->idx]);
 		fq_table[fq->idx] = NULL;
+
+		if (fq_isset(fq, QMAN_FQ_FLAG_DYNAMIC_FQID) && !leaked) {
+			/*
+			 * fq_table[fq->idx] should be set to null before
+			 * freeing fq->fqid otherwise it could by allocated by
+			 * qman_alloc_fqid() while still being !NULL
+			 */
+			smp_wmb();
+			gen_pool_free(qm_fqalloc, fq->fqid | DPAA_GENALLOC_OFF, 1);
+		}
 		return;
 	default:
 		break;
-- 
2.51.0



