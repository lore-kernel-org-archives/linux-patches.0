Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539CD17C;
	Sun,  1 Sep 2024 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210365; cv=none; b=LWlJH7X3laHJJETzS3QioltjjKitkfZXEMb56cz6Bs5U46odo3YcEgmfTd+SqhDgb7JsNqCGKO5UDHzsiPSDcHilSu0RFQqHpjxHMQ+xPGwIxamXGNTH5kt4r5FRJxVHL0L5ldqk75bod03x5Ett1eqELYW601dkt6szSifD1I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210365; c=relaxed/simple;
	bh=EPq9WxZQLa3vBt9zLo4YtZU8O7uEl8BdW9vSqd2F0pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzZJAh8U76jQDfI55VE5cqVXoECY26xfPzIU+hwrDt2bV6IYb+hQebTleCrFukniNM4ukJoPMzCflhuk/qP10/TKKvDi+WSfAWuhCsbEy8009MBpWyp2Sn6A8+fc5yFJDJkXr9xrIyBbdZ2ZLNvptcczmVa3Z9cBh2rrMtVBQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlE/z3Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlE/z3Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C97C4CEC3;
	Sun,  1 Sep 2024 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210365;
	bh=EPq9WxZQLa3vBt9zLo4YtZU8O7uEl8BdW9vSqd2F0pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlE/z3Go8wGYF5s5+P4xrc9pVhJJsnCLtiF5aZKO+EV4TzzpZY3Q9CYoBtykWynYe
	 ojtIUTjAbq7kzPsLZRlU5NxKEs7HjQRabvdllll1lnzKUM0tdZhbFZWHp5cbaOiMbp
	 d24dlWU2u+h2HDx2E9kh+I9WkCgiC5suidkybbdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Whitten <ben.whitten@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 166/215] mmc: dw_mmc: allow biu and ciu clocks to defer
Date: Sun,  1 Sep 2024 18:17:58 +0200
Message-ID: <20240901160829.633413110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3246,6 +3246,10 @@ int dw_mci_probe(struct dw_mci *host)
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
@@ -3257,6 +3261,10 @@ int dw_mci_probe(struct dw_mci *host)
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


