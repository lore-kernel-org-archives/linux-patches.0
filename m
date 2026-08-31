Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CD854A7EA;
	Mon, 31 Aug 2026 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184013; cv=none; b=qOVOKhnnbAy0q9wTsO0wOTUfa/g2rJkazpTMLQdYermYATLn0FepgMcDn6kmT/mwy+vslULHK1TaEXhK2TN4d3ocgVFzEEktIYO1UtuXJkkXbZYhusMynCeWQF8hJkuIdqsWj5uRcbDzTUO0KhHy4SbCzsx68S4pPzsdiGOiweA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184013; c=relaxed/simple;
	bh=sqc49t+truWSins9fRTsXY4A3xHIzZOXPG1tV7tKm5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHZbfLmRnBziTy2YoVXcRXxK8SsB0qYybTRp85fMS4244h+wGgAKIsLx67utmZdv9AluLeNmcA+z723+CetozF0wsL29wEygXe9hDkK1GF0UqRft7yO5QvUh3+I5NmQ8Uu1ryjypL1Tx1++qSVXQtN05y5vgFowxU3SnwIyAQUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZAPIrUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZAPIrUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B071F000E9;
	Mon, 31 Aug 2026 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184008;
	bh=AG0F9BvLOVbF4CLd/YQqa5xZ4iSGLAvGtaNOe68ZGQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZAPIrUcbZ+km19C6+Rdev3whexAW2QX3TKMWuuUDCBKlCMBCuL9PpSJCrOGeIsyP
	 lEMJhjIBOsF4jMP5xtX0K9C1Yao5CGeMMSpuvdKFX6mOOPxIuwklIE580XyVJ6x8wd
	 6RXX6ELGxdDDSA6Ls8b4z2YF1oEg2nuBLxydnQiMldq00d6XCVbwi3KSfpIcjtZJkV
	 LZ37paHxsmtYaKg9IW4SMX2bRMEpj6Z9UR2suhN53eEe8dDiY59H34lGteiaDViiPp
	 5cKZDpGAoM7uZt2aM9RFZBwxf0TH8yDgg3akxiPK8t/oH5WHq5V/xe5vbK/QN8m375
	 aUVO5gM9OCy3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stepan Ionichev <sozdayvek@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	ulfh@kernel.org,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mmc: davinci: avoid NULL deref of host->data in IRQ handler
Date: Mon, 31 Aug 2026 09:27:43 -0400
Message-ID: <20260831133314.4125787-435-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background git search finished. It found other DaVinci-related fixes
in this tree (gpio, i2c, etc.), but no commit matching the `if (data &&
(qstatus & ...)` guard pattern — so the MMC IRQ NULL-deref fix is still
absent from **6.18.43**.

That matches the earlier analysis: the buggy unguarded branches are
present in `drivers/mmc/host/davinci_mmc.c`, and this patch should be
backported.

**YES**

 drivers/mmc/host/davinci_mmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 2b7d6d9bcde51..00adc15956fd2 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -928,7 +928,7 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
 		}
 	}
 
-	if (qstatus & MMCST0_TOUTRD) {
+	if (data && (qstatus & MMCST0_TOUTRD)) {
 		/* Read data timeout */
 		data->error = -ETIMEDOUT;
 		end_transfer = 1;
@@ -940,7 +940,7 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
 		davinci_abort_data(host, data);
 	}
 
-	if (qstatus & (MMCST0_CRCWR | MMCST0_CRCRD)) {
+	if (data && (qstatus & (MMCST0_CRCWR | MMCST0_CRCRD))) {
 		/* Data CRC error */
 		data->error = -EILSEQ;
 		end_transfer = 1;
-- 
2.53.0

