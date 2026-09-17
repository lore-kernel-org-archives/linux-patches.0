Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF04F390B;
	Thu, 17 Sep 2026 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661142; cv=none; b=aWIBdPmfO+9b9UMwgjSIHcXfGg5iO9jkTG2H4jZCZS+bILVl8hOyuLMh+OfFBTu8SQuIQsgq/nh5GFecBYXIksE6DW8iS2R4TG0mvBPXuVrG1K9AA3fIlhoIOhP507yQdD/WEaciW5a/JA6xetN+/7DEFs4/NBoKtQBDAhm581E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661142; c=relaxed/simple;
	bh=j8mwCm4e59vlfbItYASrvulltpW8BsChx0Lmj83ybZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwjNiMahuWdu7AnJmMtzhIg/YyOgWYWro0jmG81WGq30TgXGtrz9lyQrJY9Gx1N0kGWAuyu4Hf5zTGMXQDs1bvN2re+WPyg33HVB5xn0QAgLufUS7q48oGgWFpbfW/J/JT5b1dLWahTIzDZcUy8Mz3OoAi/9CCDVZC8D2Q1VueQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA8RHjMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA8RHjMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763261F000FF;
	Thu, 17 Sep 2026 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661141;
	bh=adkehM31YHgMruSZDuU2LWzJ3zdk5JaUN2POMgUMqRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GA8RHjMdmhL4hEV3CozBuXoXxtfiGysnUFfgyPRcYQyyYoaGl6VwdQE6oHr/ltEj8
	 VFRLSpw3SHPK9P7jrnfE4hwFhs9KjeQ2B6dNUox9fm5Td/Cpr0dzyAQYJYYSEh0sGS
	 7Wu6QGSW1rsFVgicEcc4mYdoOm5thmXkTcfCXBlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0096/1250] mmc: davinci: avoid NULL deref of host->data in IRQ handler
Date: Thu, 17 Sep 2026 15:58:11 +0100
Message-ID: <20260917151554.588999239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



