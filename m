Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310DC1FC7F0;
	Tue, 15 Oct 2024 13:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998472; cv=none; b=QioecpnuVZP8ZPCfWyCqjcarILfxwnfd3eIo0F5WkxZfOXcCmzc1IfjPdxvtYQXXa4emL/33RRvvc2Xwz6LIHOi+2UMeKAmUWH1ZEchxOUjhg8JsmoNu5Wgxg91E48SWW4sD2xtY+29pjzvZkyTCZffEDle73NgTmStNZCQybxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998472; c=relaxed/simple;
	bh=RvFXQtyhqPD2ppjoWg8/wDP+DatHTvshgzphyrcc2mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChyS2CJlY6K0Dy2eLymSCitLDRFpHFik3qZOmreJ9TlkriInIKzBEykfKT+FvXxQl+xYQ/ciMlv18dlW8CiC+zz71NRU2qZMZEn5utA61Zy0NFtirKUwmbSGgo4+xBXhhJQChuf/D/fxz7jL73fM1+E32k50HtZBDQyRY83Bez0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNY2zekr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNY2zekr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63887C4CECE;
	Tue, 15 Oct 2024 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998471;
	bh=RvFXQtyhqPD2ppjoWg8/wDP+DatHTvshgzphyrcc2mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNY2zekriAWJw0YGF9moC/53NhtVKuN5He4xgsbH0gZt1Dp1tILFzpZ2jKD8MAo9u
	 0CGf9ZybZI+FKOJD1vU88ZEUPYXphb0Zxftj2jDMPiKYkVhSZaHmn60Q+IZHa3UO+r
	 A7MMJYCDmOFGUQi4aNqR3Mh7GvBHYemoZw5pb9hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/518] gpio: aspeed: Add the flush write to ensure the write complete.
Date: Tue, 15 Oct 2024 14:46:31 +0200
Message-ID: <20241015123935.795266839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 1bb5a99e1f3fd27accb804aa0443a789161f843c ]

Performing a dummy read ensures that the register write operation is fully
completed, mitigating any potential bus delays that could otherwise impact
the frequency of bitbang usage. E.g., if the JTAG application uses GPIO to
control the JTAG pins (TCK, TMS, TDI, TDO, and TRST), and the application
sets the TCK clock to 1 MHz, the GPIO's high/low transitions will rely on
a delay function to ensure the clock frequency does not exceed 1 MHz.
However, this can lead to rapid toggling of the GPIO because the write
operation is POSTed and does not wait for a bus acknowledgment.

Fixes: 361b79119a4b ("gpio: Add Aspeed driver")
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20241008081450.1490955-2-billy_tsai@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index bbd04a63fb12a..41e3f3b351cf6 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -404,6 +404,8 @@ static void __aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
 	gpio->dcache[GPIO_BANK(offset)] = reg;
 
 	iowrite32(reg, addr);
+	/* Flush write */
+	ioread32(addr);
 }
 
 static void aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
-- 
2.43.0



