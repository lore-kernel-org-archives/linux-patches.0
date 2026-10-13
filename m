Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702E3E8338;
	Tue, 13 Oct 2026 12:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895327; cv=none; b=Uis41DbIFWQRiHs71zRZwynCfiBp2rHMoeXZShBd4U3VW8IAwmatkVN/zO0a0D/fdfNtj1wv+wIchezVIv0iEu32zdHk5n91a7nJyTP+ITxS1ybe8mlNkugC335kwnsOb3tEkv+RTFXS7ElX6U3P8dKi8w5VTAeyCfAm1U4/oC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895327; c=relaxed/simple;
	bh=UqqxRzV/0JcTrEyOGDnJsookI6beSCtp2vfXy7en3zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEjxAXcuSBY7ljshlSEKcnqxOiGVdttncizCuF4Wdwvmojcx02oDoTviH+h+U6tc8tyZOL0u9iEjgyAcZrhBzy8aFzGTp+ZcLuRRkAwg9gNy9xAor7bY1Aonzdc7ssATPwTRg59yGTKSWduHiDF/P133YF3cmFqy1F4oW7ZF/8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sr9iCUBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sr9iCUBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317741F000FF;
	Tue, 13 Oct 2026 12:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895326;
	bh=twxPhW0XOFXRmMmF7HWm7I2n08W+fViWUyR2GXT9I5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sr9iCUBeG28SgCFmJR0iWNPqIoDb0vSlSxGc25C3pLbl4aYmn/rLJHnGH1279Qnht
	 9Hc7YuLF59Gr8FmyLuD5dSK6DjIVBetUsg+6jFXUmiTciZGQPsvsNeveXh1CrLKvU0
	 V0l4RwHBtmscrKg9X04A0sEaMHXk7V67w2yaP3TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 238/497] iio: admv1013: initialize callback mutex before registering notifier
Date: Tue, 13 Oct 2026 13:36:45 +0200
Message-ID: <20261013112913.545639782@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit baf7e43b7fb5afb777353bf265ddf9d909f72b9f upstream.

admv1013_probe() registers a clock notifier whose callback takes st->lock
on POST_RATE_CHANGE. Initialize the mutex before
devm_clk_notifier_register() so the callback cannot observe an
uninitialized lock during probe.

Use devm_mutex_init() so the lock lifetime is tied to the device and
cleanup stays paired with the rest of the managed probe resources.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -604,11 +604,14 @@ static int admv1013_probe(struct spi_dev
 				     "failed to get the LO input clock\n");
 
 	st->nb.notifier_call = admv1013_freq_change;
-	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+
+	ret = devm_mutex_init(dev, &st->lock);
 	if (ret)
 		return ret;
 
-	mutex_init(&st->lock);
+	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+	if (ret)
+		return ret;
 
 	ret = admv1013_init(st, vcm_uv);
 	if (ret) {


