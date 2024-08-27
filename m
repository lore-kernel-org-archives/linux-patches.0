Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE24C54648;
	Tue, 27 Aug 2024 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772742; cv=none; b=rNBctKsOQmhV+hoc+JdFfyKqmzCx8e7d15T3/ppICGcdIlIFRwYWCu6eX4Y+dgg1yO3mTxU+MhJ5baLb8jMH3mRNf6gjHE0p5TZ2wtttHXh+1FE5HgpjY6SUtqPx3kt5UkSbkkrPq0vdzfmd0HJgMRhqgLagPoA5lJiIC3+hP8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772742; c=relaxed/simple;
	bh=o+DzccuT4GP/WjDi83/FQmsqND+tzZtqYXsNhtRWprY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeW/3QoQT+yZOFphOwSKg8xAWhIHCF2OBF0qC1QFL56i3q9Ry1UTYkAZv+nd4Q5qWS6P/RZ+hIHmnvai7txZgrBuVjofY8z1EOXrB5bjBTo8oTi7eUA/eBA1AZsSX5Wl92jJFFc4MoTGn1GEZ6DKbNXVAccX+BGxW9+RFfVyevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxROK+DL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxROK+DL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F133C4DE04;
	Tue, 27 Aug 2024 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772741;
	bh=o+DzccuT4GP/WjDi83/FQmsqND+tzZtqYXsNhtRWprY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxROK+DLH0O9XShAtl3seyiB8i09NVYBvW6al58VJpVPjdRLbmpLouMjqFW+zt1pR
	 FspUGSRq1WMSxU7Qcme+nuQ/fj4JjsoF6ZM8mZftu1f4gzP/DertHABayEu8dkMsnn
	 yUZCWa74reaMQBAJMNxFYXM8InfPjrw3u4dq1FVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Whitten <ben.whitten@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 274/321] mmc: dw_mmc: allow biu and ciu clocks to defer
Date: Tue, 27 Aug 2024 16:39:42 +0200
Message-ID: <20240827143848.682011745@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3295,6 +3295,10 @@ int dw_mci_probe(struct dw_mci *host)
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
@@ -3306,6 +3310,10 @@ int dw_mci_probe(struct dw_mci *host)
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


