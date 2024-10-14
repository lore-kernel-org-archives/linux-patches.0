Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971D1B86CC;
	Mon, 14 Oct 2024 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919151; cv=none; b=Mp3qyS6toyOVGtyG2bplC0N13MOv56xdCKxD1jdo83DmGijE7DRaFFmfXR7+WGJlCI1IWtHDjzon9Dk2wBpKoE2LcYqKIc9fiNC5dDM0oWCTe9Nr43QTdR6hWlhuQozzJjlKUEi6HNjWNSUNYacP951rQ2xH0LgNb+q1MSDBZxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919151; c=relaxed/simple;
	bh=F4TvSckTmLOKHsfUuCtDT62VjNrHnBP8l3KibBmf0DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns/5zY0FjuoXddZ0igKUrV9ycXF9UX0Nlt/FkvULYaq8B6DuBIO6F6obUacluK3g4rXFuVAJwumAWmdnXciq6WrfvchhYC17V1rLB82dIVsBwSx6pmpVaA2Xly8f4DbBMmA5QcHwru9HlynK6fX+RzPtQO6XbloqKSHaHDqx2uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyEmtTa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyEmtTa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D284C4CEC3;
	Mon, 14 Oct 2024 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919151;
	bh=F4TvSckTmLOKHsfUuCtDT62VjNrHnBP8l3KibBmf0DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyEmtTa4yPV7f/rbkiOBlBjqseaw40NSCj3Guw4d/+xGa4DyS6FVR/SXycVulR+II
	 YiTALH/p7obdeuxHZqp8XBXBZn0axGVmUzkQDe+bDpWLmVzl3s8HnnhkP6bAXTetPX
	 KaTkQAu+2KuC/VuQqtguHJOgVjFHG0FiHOWh4B+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Marek Vasut <marex@denx.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 525/798] i2c: stm32f7: Do not prepare/unprepare clock during runtime suspend/resume
Date: Mon, 14 Oct 2024 16:17:59 +0200
Message-ID: <20241014141238.604819054@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -2353,7 +2353,7 @@ static int __maybe_unused stm32f7_i2c_ru
 	struct stm32f7_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
 	if (!stm32f7_i2c_is_slave_registered(i2c_dev))
-		clk_disable_unprepare(i2c_dev->clk);
+		clk_disable(i2c_dev->clk);
 
 	return 0;
 }
@@ -2364,9 +2364,9 @@ static int __maybe_unused stm32f7_i2c_ru
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


