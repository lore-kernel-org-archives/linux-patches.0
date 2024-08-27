Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490B61BFE04;
	Tue, 27 Aug 2024 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770696; cv=none; b=KMBIB3BluIio8gYAG5MqcISHFV3aa6kjSSfkzoMDKUQ/B8ZWSUfj2OqBWNaVw/IEPLS2xqSfpQR0+ydnpjpKaXXlumOgVsMxWqRPY4TjhNW8qTU/vu/vl6IiNDxmJnKBfBQkRgE47GR0cPd9Jb69KbkJsV7WY4N62Q+vp1kr4lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770696; c=relaxed/simple;
	bh=4o3/Za6AYK8JFZKQNWJmQS+uE1XnP8AuRBb/qhncAMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rl08D1Z4DY0zvJrY6uUugQpUheAX4cWqgVV7ymMfX6CFOJTqew5ADEPbBxWyfuBHmObYsiTv0t5CL1bdQvGDLw7PSVFrZgzjJlvZWfQKwPhWvHRHQrMeyRwJ8j/GyrB9N+xxSuH3dGL1GHhfv5FaIG6PJ1KrLdALJkx1T1vkN+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epAQAB9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epAQAB9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE91FC6107B;
	Tue, 27 Aug 2024 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770696;
	bh=4o3/Za6AYK8JFZKQNWJmQS+uE1XnP8AuRBb/qhncAMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epAQAB9iDbpYoo14d6DZBfhtUKmliwFXQA1fnV/CRUdEoS74ZO0zH/5xTevOQK6JT
	 28d0/VRExKTL1HTFhGmIoGoUZgHKVCxZYL9VkvsZGFVIniXvItWgvwRxhdkn+bxnF8
	 0fFfeMNxkTivCqXTvPASQMlNK4muouYlk/EqNo0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Whitten <ben.whitten@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 306/341] mmc: dw_mmc: allow biu and ciu clocks to defer
Date: Tue, 27 Aug 2024 16:38:57 +0200
Message-ID: <20240827143855.034047009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ben Whitten <ben.whitten@gmail.com>

commit 6275c7bc8dd07644ea8142a1773d826800f0f3f7 upstream.

Fix a race condition if the clock provider comes up after mmc is probed,
this causes mmc to fail without retrying.
When given the DEFER error from the clk source, pass it on up the chain.

Fixes: f90a0612f0e1 ("mmc: dw_mmc: lookup for optional biu and ciu clocks")
Signed-off-by: Ben Whitten <ben.whitten@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240811212212.123255-1-ben.whitten@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -3294,6 +3294,10 @@ int dw_mci_probe(struct dw_mci *host)
 	host->biu_clk = devm_clk_get(host->dev, "biu");
 	if (IS_ERR(host->biu_clk)) {
 		dev_dbg(host->dev, "biu clock not available\n");
+		ret = PTR_ERR(host->biu_clk);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
 	} else {
 		ret = clk_prepare_enable(host->biu_clk);
 		if (ret) {
@@ -3305,6 +3309,10 @@ int dw_mci_probe(struct dw_mci *host)
 	host->ciu_clk = devm_clk_get(host->dev, "ciu");
 	if (IS_ERR(host->ciu_clk)) {
 		dev_dbg(host->dev, "ciu clock not available\n");
+		ret = PTR_ERR(host->ciu_clk);
+		if (ret == -EPROBE_DEFER)
+			goto err_clk_biu;
+
 		host->bus_hz = host->pdata->bus_hz;
 	} else {
 		ret = clk_prepare_enable(host->ciu_clk);


