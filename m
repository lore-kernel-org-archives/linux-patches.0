Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2281E1C57B1;
	Tue, 15 Oct 2024 12:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993800; cv=none; b=H3cZXnXC+MVZOf+vOUGxP4lJHgSXT00SfNNbbWM7aOChIoV8H8F4zNpMh1RXE3GbP+dkxkjTfZblPYlch4V33fK6RU5Gz3l1cw1OpdxF0JVxBBd9KDCzsKjU/SuFspE+xQZiPV3ywlVtwCXI9EkjtRBqZZ++iWWq6+B4MbpcjNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993800; c=relaxed/simple;
	bh=R+MTYHquBGA4+lh900ofZC7+2EEmW2KtoCiz+LigZU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPryvfPxPuWuU+aRddmAv443mKNgdlr0YvsK1QQYi//ozZrGVyRlxQF+mMhfKuYx6iz25w/SD5J/ZXdugljDTrzISu3TNfc/q6v2eVsitdOdNNSsEE0VD1CluoudFIFgtGllnfN3O3cUbrSzlXGKf5uIXXE1hoVwmkhrKBWo5R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlGCCDgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlGCCDgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E115C4CED0;
	Tue, 15 Oct 2024 12:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993800;
	bh=R+MTYHquBGA4+lh900ofZC7+2EEmW2KtoCiz+LigZU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlGCCDgYU88lb8Wl4/P2siweWNVcQ/6SvsydBARwREItUxGAnzVRDPPNTwEFPl8fc
	 3PfF0Olde8pXHrElFGbtAnTnRSLqP7gdHxvnODANh3uvY1gYqewFkJGGJw7oank2zu
	 EBVRggaqhUHZpL87VQaXGncBLV953QldBXJy2F78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Marek Vasut <marex@denx.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 489/691] i2c: stm32f7: Do not prepare/unprepare clock during runtime suspend/resume
Date: Tue, 15 Oct 2024 13:27:17 +0200
Message-ID: <20241015112459.746402246@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
@@ -2351,7 +2351,7 @@ static int __maybe_unused stm32f7_i2c_ru
 	struct stm32f7_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
 	if (!stm32f7_i2c_is_slave_registered(i2c_dev))
-		clk_disable_unprepare(i2c_dev->clk);
+		clk_disable(i2c_dev->clk);
 
 	return 0;
 }
@@ -2362,9 +2362,9 @@ static int __maybe_unused stm32f7_i2c_ru
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


