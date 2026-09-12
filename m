Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204D1C75F9;
	Sat, 12 Sep 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221600; cv=none; b=AuhMB61QaiVm6hv7SsWVhSSFmG1bYfncn36z6IotMhQG/TlRzY2FKsmAzByDNMWbm4FL9+5aFTBVuZKfEssl3kaU/1qit0xSC6MwZ8t3anx1VeYTSUI997LdfuRezfGYNQZj46mnVX0Fqqh4dDHtKoMLUm+yrY79NgphrUzrRGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221600; c=relaxed/simple;
	bh=0hvYZK2ldzIWbKfTVyr1JWmqso+gShRySvG/xG113+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T98XoXCuAoZQ4CWRxPt2Z14daV3eDVwgxHqOWKDA7vOmejAZgXrVQbZEX5GzFPQah8f/Ee02BJ85nrk5BV8AHyDoFwGvWwcgEjTi7C+B2WMs0Mf97q9djriGNRH0T91U9w2GgW/Jt4h1DijyLWYeibNdZZ6D2TxPrLaM1N/3/s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk/LXLj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk/LXLj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A041F00893;
	Sat, 12 Sep 2026 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221596;
	bh=uUuWs3/D8x4bFTXZOXNMoM8wt6uG+riE3tg8U5V3Ibo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk/LXLj5aO/r5l6PA3jeq1HUiHQkgO8mPACnAOSmkoF9RmABLlqQtGOO69ZJoJFC6
	 jkYwNu3p7Vj9SS52a4G2JwA/Q/U84j/euu57+HEBT8zYRQx3N7Bd0+bTsWBzRb2+W2
	 3kwI6PVKgnY9DHrlW2ZaDJ1UPSwCNsHtNtxnOk74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0415/1424] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Sat, 12 Sep 2026 08:47:27 +0200
Message-ID: <20260912065616.575543236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 1135d6875d2dbda3f6ec718f3421a6ce4378bd63 upstream.

kthread_run() can fail and return an error pointer, but sgp_probe() stores
it and returns success, so the device is registered without its IAQ thread
and sgp_remove() later passes the error pointer to kthread_stop(). Return
the error from probe instead.

Fixes: ce514124161a ("iio: chemical: sgp30: Support Sensirion SGP30/SGPC3 sensors")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sgp30.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/chemical/sgp30.c
+++ b/drivers/iio/chemical/sgp30.c
@@ -548,6 +548,9 @@ static int sgp_probe(struct i2c_client *
 
 	data->iaq_thread = kthread_run(sgp_iaq_threadfn, data,
 				       "%s-iaq", data->client->name);
+	if (IS_ERR(data->iaq_thread))
+		return dev_err_probe(dev, PTR_ERR(data->iaq_thread),
+				     "failed to start IAQ thread\n");
 
 	return 0;
 }


