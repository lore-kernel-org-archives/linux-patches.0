Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0C13ACA43;
	Fri,  4 Sep 2026 05:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501190; cv=none; b=ufWzGd0fPEpbwyQwUapk8OZbkFWgF6FqpG0EYGClqMhGgXBjgxve5VZV1dNGBxe+GXQ1G90GtrViFLuZjerdO32/TW8DiEz0WR+Jv/dzZBLM/a1BI+vQC4xnJjSZRsKDY9kG1e2ycQm3jSy9I+6BTEC8GcOkAibSp+PUZACta3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501190; c=relaxed/simple;
	bh=6Uxpwn7P7KRjVUuVNvcemgQwpUtiMoeoNEGi4B3UkYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcLzX4AiKi4GwNsseOF8eycSuVVQEuiew1XW8IpdskHu8Vl37y1UFXzkunrqjdHMpUwgKQQS8jvSpka+mExtk6hH9WByI3a07ucKHgQ9veJ3XdpqN3kNxpmlICGjMLi4k/qUusHIATIg2W4leKUPlLWg3LoFQugKegbY0OcVO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuB+t2Sd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuB+t2Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2378F1F00A3E;
	Fri,  4 Sep 2026 05:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501189;
	bh=lWKUBgxDseix11U8d/3E1cAC2+Y9SAwAKe5k849mP1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuB+t2SdQWq19sGGYN/1SUtlUAbWZXZ6JG/h7DSqqBl7i5cefoTKacB0ERnUxythq
	 0ZzF4uQpJQ5mCxWaqeE6i+mLaN12m58c4xqXjsCv13xYZxrqoNycuTvtVWyRayC10n
	 xexCIf7/kpXBk2eLsFq6OphV/22MUVWyNzBbJXXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.18 322/552] RDMA/ionic: Cap eq_count to the eth drivers interrupt vector budget
Date: Fri,  4 Sep 2026 06:57:59 +0200
Message-ID: <20260904045757.570626948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

commit 1d0f877d593438a494ca5b05cc8699150409005a upstream.

ionic_fill_lif_cfg() reads eq_count from firmware uncapped, but the
eth driver only reserves ionic->neqs_per_lif MSI-X vectors for RDMA
event queues. Since ionic_rdma probes via the auxiliary bus before
the netdev is brought up, it can exhaust the shared interrupt bitmap,
causing ionic_open() to fail with -ENOSPC when allocating rx/tx
interrupts.

Cap RDMA eq_count to neqs_per_lif, which is populated by
ionic_lif_size() at PCI probe before the RDMA aux device registers.

Fixes: 8d765af51a09 ("RDMA/ionic: Register auxiliary module for ionic ethernet adapter")
Cc: stable@vger.kernel.org
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://patch.msgid.link/20260805053254.4023262-1-abhijit.gangurde@amd.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -70,7 +70,7 @@ void ionic_fill_lif_cfg(struct ionic_lif
 	 * eq_count is tunable; see ionic_eq_count
 	 */
 	cfg->aq_count = le32_to_cpu(ident->rdma.aq_qtype.qid_count);
-	cfg->eq_count = le32_to_cpu(ident->rdma.eq_qtype.qid_count);
+	cfg->eq_count = lif->ionic->neqs_per_lif;
 	cfg->cq_count = le32_to_cpu(ident->rdma.cq_qtype.qid_count);
 	cfg->qp_count = le32_to_cpu(ident->rdma.sq_qtype.qid_count);
 	cfg->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);


