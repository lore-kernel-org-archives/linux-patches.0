Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8713438A1;
	Tue, 13 Oct 2026 12:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895604; cv=none; b=UsAew6RRwvt5KTnwzfgkHb+ZDuMWl1CacWU1oV4CzNmYzHxRNd8ncHSinVd19XZrJoDooPM8gexIfKBa3JkQv3zCanhRBkx/1Im5WKuwWG95/cZAlv7pxTdUKVvTKm7iFSgpF39Gk8dFtl3xjrrMd1BlED0Ovb0AZkrdLyFUASQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895604; c=relaxed/simple;
	bh=YdBDvmZC7gkpvnH2TEQXDVz23K5P3Iakbfja71kxOa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0XEDSeWVb61ra6aNyDDgidgmmX7LO5TEdtvxdSnI/O5JPpqtUaPM5a0wzbT+nv//QUWh5asNIptf4aX7g1WvfEs2Fy283C/mCrBXBS1XChT2wiI3Ueih49y8Ph7xE2CQG2cDQTol32cfCu16K7AoIhdjyLINDLJDJiOA2UA4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3VfU+Z2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3VfU+Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A571F000FF;
	Tue, 13 Oct 2026 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895602;
	bh=1LgVZYjS6zIjikL63+XHhYW/OEbXpHEp+Qj3yjnnCMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3VfU+Z2DQ3TM2hQa2evjH2+tBqMo5L4+Vb73yF9XaOnbSkY0o+33f6Bq+SGgMnh+
	 e7IiZ8qoR3szAiviH7EOZmQGxXk9zq1rWAmORFCUtQ+a1ry7lH+O1vYok701uDHSa8
	 qJ1gMYhDZFY4adMksJhFNux5LDJCGWqUVZDktWoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/497] iio: adc: aspeed: propagate reset deassert errors
Date: Tue, 13 Oct 2026 13:38:18 +0200
Message-ID: <20261013112915.760502377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 95e4eb426b4bd666fa2f37886c0ddf74a0cc6167 ]

aspeed_adc_probe() continues to register ADC resources after deasserting
the shared reset, even if the reset controller reports a failure.

A failed deassertion leaves the hardware unavailable, so stop probing
before installing the cleanup action and enabling the ADC.

Fixes: edf7550a1f93 ("iio: adc: aspeed: Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 1cf9df6a14a54..8039370e1cd28 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -540,7 +540,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(data->rst),
 				     "invalid or missing reset controller device tree entry");
 
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(data->dev, aspeed_adc_reset_assert,
 				       data->rst);
-- 
2.53.0



