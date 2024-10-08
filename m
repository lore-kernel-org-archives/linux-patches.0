Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD38B189910;
	Tue,  8 Oct 2024 12:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392319; cv=none; b=KQHW0Tab560pl4n9X/DSJKcKjn35N65UIU7CG9EeIwa0Phcg+8qaLF11uogdvDSvAUXAoiev9Ly/TDCwBNvoYQgZeg9iLsRsTRZJGJQbrAj0PgPoPRvvcfNJFo0ne6ml0p/RntH71Eyba2qRe7Hjq+wUCjV8xxGvlT9++n+NWwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392319; c=relaxed/simple;
	bh=pKHSgkyv2fTfqFu2E+0GnW03kesX5bz6S8lw5I/x3Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTIvm1AWzjMSjUak2DD0Y6oqwHN0pR3ATsrdPmxr/6b/haa55iRx4Zmoni6N1bQ+pd6wd+yYhb0BzcY2P9sBfFlYfLyPU9vlWtvCKT2i4SgFq3R/QY7eRJyHPDTqBOEsAfBcmn9XIfui1j3H/pMhDztIyJlPF8E5Pqtw1u6k3AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YM8+FsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YM8+FsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB94C4CEC7;
	Tue,  8 Oct 2024 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392319;
	bh=pKHSgkyv2fTfqFu2E+0GnW03kesX5bz6S8lw5I/x3Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YM8+FsF/9UHZzkLARRKAjLZOc6NsPR7l5p14BARfYa6KqMyARl2IiHPKyVeS1oP7
	 OER9t4/ZLiiz4JHLjKjGsDdcFAX6zxm30aQbYhxiTR2ydbapNmlGL3WZ3KZ7I4t8/Q
	 MsfeBQ1x6UNtzMGByAZnWDbtcQKBvS510zs1EZjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Marek Vasut <marex@denx.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.11 349/558] i2c: stm32f7: Do not prepare/unprepare clock during runtime suspend/resume
Date: Tue,  8 Oct 2024 14:06:19 +0200
Message-ID: <20241008115716.031522681@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 048bbbdbf85e5e00258dfb12f5e368f908801d7b upstream.

In case there is any sort of clock controller attached to this I2C bus
controller, for example Versaclock or even an AIC32x4 I2C codec, then
an I2C transfer triggered from the clock controller clk_ops .prepare
callback may trigger a deadlock on drivers/clk/clk.c prepare_lock mutex.

This is because the clock controller first grabs the prepare_lock mutex
and then performs the prepare operation, including its I2C access. The
I2C access resumes this I2C bus controller via .runtime_resume callback,
which calls clk_prepare_enable(), which attempts to grab the prepare_lock
mutex again and deadlocks.

Since the clock are already prepared since probe() and unprepared in
remove(), use simple clk_enable()/clk_disable() calls to enable and
disable the clock on runtime suspend and resume, to avoid hitting the
prepare_lock mutex.

Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Fixes: 4e7bca6fc07b ("i2c: i2c-stm32f7: add PM Runtime support")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -2395,7 +2395,7 @@ static int __maybe_unused stm32f7_i2c_ru
 	struct stm32f7_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
 	if (!stm32f7_i2c_is_slave_registered(i2c_dev))
-		clk_disable_unprepare(i2c_dev->clk);
+		clk_disable(i2c_dev->clk);
 
 	return 0;
 }
@@ -2406,9 +2406,9 @@ static int __maybe_unused stm32f7_i2c_ru
 	int ret;
 
 	if (!stm32f7_i2c_is_slave_registered(i2c_dev)) {
-		ret = clk_prepare_enable(i2c_dev->clk);
+		ret = clk_enable(i2c_dev->clk);
 		if (ret) {
-			dev_err(dev, "failed to prepare_enable clock\n");
+			dev_err(dev, "failed to enable clock\n");
 			return ret;
 		}
 	}


