Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1917623AB9D;
	Mon, 23 Mar 2026 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277260; cv=none; b=HmoPrt2e3ie9PnESg/mc5CRx1HGx2e1xREhzDWvxikrLV29W3C1gwrtJXcNfwjpuep/pdgyA7z76gRkpAOat3D2KMOwq9z9XGclRj3qKmR5YEf3GNKI1NePlXUb5IkpDgtsl8szI8Aau7uk/5T8h/ffIIzPoXhRoaT3l9BbaU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277260; c=relaxed/simple;
	bh=2vFtXkIC5Llr92Zl+A2r4noxcYTkghs47+QsZjsHFm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFuCnF8BaaR/A/1C/jKJdS41X/VI3IAzIKu7DYbBrE8/APqZVWfXkpFavo0HwQHln0Zd4jhPnqkukOzcocFMTCjM/T3IGaE1l8Ov2XFEBZZUZQO/uqMbys5Z/UZ63Lze1vTCF5BCPsb91dref7tv2MFe1VF0y4w/dvOGIzcle7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAoDTjPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAoDTjPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E41C4CEF7;
	Mon, 23 Mar 2026 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277259;
	bh=2vFtXkIC5Llr92Zl+A2r4noxcYTkghs47+QsZjsHFm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAoDTjPmZDGBcpnv0m4xhhyo3LxPmjiMz8NDwbpEIAL+FWeoETqG2mGGuKdJY8QnN
	 r7AQ5oyoWAQRbsYBO7GzB63gzVjdW4kvhv4CsB1CgvUGNVFMuHod7qn8hE1Mys6kNC
	 gl+5lellhVY1b7y30sAmPbAj/1DisVSs8dJKwc90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Genoud <richard.genoud@bootlin.com>,
	CHAMPSEIX Thomas <thomas.champseix@alstomgroup.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/460] soc: fsl: qbman: fix race condition in qman_destroy_fq
Date: Mon, 23 Mar 2026 14:46:08 +0100
Message-ID: <20260323134535.705320119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index 4dc8aba33d9b7..0791b41913383 100644
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



