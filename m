Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DBB525A79;
	Wed, 30 Sep 2026 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790648; cv=none; b=gTwlX/FKtY1j1A0gf6YEhDoNS6a8jZAMGANRsP83Yf2bF/SBa/TwXfkJ6UhdJe/LCF99pWXJl5TrMdukKX3ZsOjje/ttYDKWLKLkFiK0pfexL4LWinkjEtC89v3L/ECiPvGnNpQLywT05kQD7eosp90vhiqUI0fCUhnoFjDFobo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790648; c=relaxed/simple;
	bh=DGA4l/TJMPR4gIt5oWAaP9fVjq8v+LdUkp53+62dcko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJCfVYWKTOXIycUoNxwtqjYZLRUddQazl4Wzp/H6ZhIXOqREHTqUuO2h+P3cYPixB9yo0MnfP2yjMU9P9LJsDvrHQhZfG+IRMSOUm6s6/z8fjifZ81jd1yGLRfBykInfaAEKTnzEVuAwDvl005MrExLDCOlTDBNEoe2wjCSUAmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuKSys3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuKSys3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E911F000FF;
	Wed, 30 Sep 2026 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790647;
	bh=Q8EFNulZcSHEL3fa4A9RkL4Gk7syL9vFimZ1jqwN8oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuKSys3xYylWs/QJLcs/O3EEw6WMLLBkiPuecP7X6figWWxI/3T7KTD/I09aVW8Ga
	 ILt24arfD1M0rad+KOAHiOxsF/5DVKEZEVSnLehPkWT4A4bB5Rj5rM1m8AUWXGuIlb
	 Xp3hG1ZQ4+HifsMtEp5XmWmoY8kNjHBj+mdSE7GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/752] mmc: davinci: avoid NULL deref of host->data in IRQ handler
Date: Wed, 30 Sep 2026 17:18:15 +0200
Message-ID: <20260930152358.696317045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 4f28846aaf8db9668e338b8987973f8935edff34 ]

mmc_davinci_irq() returns early only when both host->cmd and
host->data are NULL:

  if (host->cmd == NULL && host->data == NULL) {
          ...
          return IRQ_NONE;
  }

So we may legitimately reach the rest of the handler with
host->data == NULL (and therefore data == NULL). The DATDNE branch
already guards against this with an explicit "if (data != NULL)"
check, but the subsequent TOUTRD ("read data timeout") and
CRCWR/CRCRD ("data CRC error") branches dereference data
unconditionally:

  if (qstatus & MMCST0_TOUTRD) {
          data->error = -ETIMEDOUT;        <-- NULL deref
          ...
          davinci_abort_data(host, data);
  }

  if (qstatus & (MMCST0_CRCWR | MMCST0_CRCRD)) {
          data->error = -EILSEQ;           <-- NULL deref
          ...
  }

If either bit is set in qstatus while host->data is NULL, the kernel
will crash inside the IRQ handler. smatch flags this:

  drivers/mmc/host/davinci_mmc.c:933 mmc_davinci_irq() error: we
    previously assumed 'data' could be null (see line 914)

Gate both branches on a non-NULL data, matching the existing pattern
used by the DATDNE branch.

No functional change for callers where data is non-NULL, which is
the only case in which these branches did meaningful work before
this change.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/davinci_mmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index e0175808c3b0d..845604a96bc93 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -934,7 +934,7 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
 		}
 	}
 
-	if (qstatus & MMCST0_TOUTRD) {
+	if (data && (qstatus & MMCST0_TOUTRD)) {
 		/* Read data timeout */
 		data->error = -ETIMEDOUT;
 		end_transfer = 1;
@@ -946,7 +946,7 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
 		davinci_abort_data(host, data);
 	}
 
-	if (qstatus & (MMCST0_CRCWR | MMCST0_CRCRD)) {
+	if (data && (qstatus & (MMCST0_CRCWR | MMCST0_CRCRD))) {
 		/* Data CRC error */
 		data->error = -EILSEQ;
 		end_transfer = 1;
-- 
2.53.0



