Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B496744BC94;
	Tue, 16 Jun 2026 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624173; cv=none; b=IqcnaFLhgRnYDEgFBfPsvQo/7t2pjrs1F1oH9aQYUJjORh1lvnwDzFwqPGoI1rgcOCW06Ff5VAVSmW+eC+F5xjXS1zv87rMVM7fypFKRwWQ9FeIalXDajaJpM6K5I2c2epz3GPY3iF4rHgZVuSbSg01Hsz30ib7yDdf7zAkyvQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624173; c=relaxed/simple;
	bh=xfr85P9SGLdynyOGdX5YIVqQtu2deB0KM/RhHS2nOa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNnC5/6DYSFyF2vjVh8A0TSZeZSzqrAz03g9O4am7sFqXe0im86HfGZMznSEkZvpQFmdmp0up1oituwZiJ53uwyD8koQQQHAA7Ga40JHAoIyojtdITm0oZAYF3v1H1T3E2v6BranKBCv3aa/JgOa0nbfGpcaoZmZhGEFVz+XurQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKUXAU7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKUXAU7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DE51F000E9;
	Tue, 16 Jun 2026 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624172;
	bh=W0gLRua9DQbishpJoHfqfMWrTgTpL1k3wZXV5DegsZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKUXAU7fJYeDvKJ/P5rtDEPsNozQMr5XYjWHWyuOCpQbocyT5YB8B0n+PnCzFNZzr
	 uPPlVZScnyzAurVJp76fCWsKG6YMMxwIdLXSIpTT8p7sB7DDc3ytji2yPX2OD16X+O
	 BVWr9ToMX+CHTenNpWRDSfulvSS9vYt+zDun/T5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 7.0 286/378] firmware: samsung: acpm: Fix mailbox channel leak on probe error
Date: Tue, 16 Jun 2026 20:28:37 +0530
Message-ID: <20260616145125.143696949@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit b66829b17f6385cc9ffbcbe2476d532d2e3121ad upstream.

Sashiko identified the leak at [1].

The ACPM driver allocates hardware mailbox channels using
`mbox_request_channel()` during `acpm_channels_init()`. However, the
driver lacked a `.remove` callback and did not free these channels on
subsequent error paths inside `acpm_probe()`.

Additionally, if `acpm_achan_alloc_cmds()` failed during the channel
initialization loop, the function returned immediately, bypassing the
manual cleanup and permanently leaking any channels successfully
requested in previous loop iterations.

Fix this by modifying `acpm_free_mbox_chans()` to match the `devres`
action signature and registering it via `devm_add_action_or_reset()`.

Cc: stable@vger.kernel.org
Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Closes: https://sashiko.dev/#/patchset/20260420-acpm-tmu-v3-0-3dc8e93f0b26%40linaro.org [1]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260505-acpm-fixes-sashiko-reports-v5-2-43b5ee7f1674@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -526,10 +526,11 @@ static int acpm_achan_alloc_cmds(struct
 
 /**
  * acpm_free_mbox_chans() - free mailbox channels.
- * @acpm:	pointer to driver data.
+ * @data:	pointer to driver data.
  */
-static void acpm_free_mbox_chans(struct acpm_info *acpm)
+static void acpm_free_mbox_chans(void *data)
 {
+	struct acpm_info *acpm = data;
 	int i;
 
 	for (i = 0; i < acpm->num_chans; i++)
@@ -557,6 +558,10 @@ static int acpm_channels_init(struct acp
 	if (!acpm->chans)
 		return -ENOMEM;
 
+	ret = devm_add_action_or_reset(dev, acpm_free_mbox_chans, acpm);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add mbox free action.\n");
+
 	chans_shmem = acpm->sram_base + readl(&shmem->chans);
 
 	for (i = 0; i < acpm->num_chans; i++) {
@@ -578,10 +583,8 @@ static int acpm_channels_init(struct acp
 		cl->dev = dev;
 
 		achan->chan = mbox_request_channel(cl, 0);
-		if (IS_ERR(achan->chan)) {
-			acpm_free_mbox_chans(acpm);
+		if (IS_ERR(achan->chan))
 			return PTR_ERR(achan->chan);
-		}
 	}
 
 	return 0;


