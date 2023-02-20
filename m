Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC2263B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1614DC433D2;
	Mon, 20 Feb 2023 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900954;
	bh=fBdbItXesamawB7FaHpxM6X9MEhryq0ALpylqO/1AgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5tpSaQQYnlC1X2E4OkPaK5KpxRvMZKe43bGHgZs/tNQta4lzODslmHXt9x5O0rZ9
	 gVTpo5ph1ff9ymj4iCEY3E7y01BBRuYJ39b8q7o+n6E8ug8B8luuCViVFMmGtOWyi2
	 6EAyvFqryj7og63cFA+j/00DkNHm7JkN+mAtJSbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 130/156] mmc: mmc_spi: fix error handling in mmc_spi_probe()
Date: Mon, 20 Feb 2023 14:36:14 +0100
Message-Id: <20230220133608.016440636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit cf4c9d2ac1e42c7d18b921bec39486896645b714 upstream.

If mmc_add_host() fails, it doesn't need to call mmc_remove_host(),
or it will cause null-ptr-deref, because of deleting a not added
device in mmc_remove_host().

To fix this, goto label 'fail_glue_init', if mmc_add_host() fails,
and change the label 'fail_add_host' to 'fail_gpiod_request'.

Fixes: 15a0580ced08 ("mmc_spi host driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230131013835.3564011-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmc_spi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1420,7 +1420,7 @@ static int mmc_spi_probe(struct spi_devi
 
 	status = mmc_add_host(mmc);
 	if (status != 0)
-		goto fail_add_host;
+		goto fail_glue_init;
 
 	/*
 	 * Index 0 is card detect
@@ -1428,7 +1428,7 @@ static int mmc_spi_probe(struct spi_devi
 	 */
 	status = mmc_gpiod_request_cd(mmc, NULL, 0, false, 1, NULL);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status) {
 		/*
 		 * The platform has a CD GPIO signal that may support
@@ -1443,7 +1443,7 @@ static int mmc_spi_probe(struct spi_devi
 	/* Index 1 is write protect/read only */
 	status = mmc_gpiod_request_ro(mmc, NULL, 1, 0, NULL);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status)
 		has_ro = true;
 
@@ -1457,7 +1457,7 @@ static int mmc_spi_probe(struct spi_devi
 				? ", cd polling" : "");
 	return 0;
 
-fail_add_host:
+fail_gpiod_request:
 	mmc_remove_host(mmc);
 fail_glue_init:
 	if (host->dma_dev)


