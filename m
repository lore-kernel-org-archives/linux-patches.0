Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771AC315D5C;
	Mon, 13 Oct 2025 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370297; cv=none; b=UjIj2V7ChxFlkrtxexRUbWlppnT1eDav73QnORCyxnVqtDKM3Z9yP+RFlbIadPGhmmskTtllJUA/e5VMRuuMC2eRWeTmZjUG9ETHAzUfyit9tSVJhRwp8BwDiyiWQyPfyhTLsAW8j469UqIi9nSnW5y9VEnTUdLbfuEb0UfB3lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370297; c=relaxed/simple;
	bh=JSZCIXXtwxHsEdR7Tp9DbRRAi+OsOBH6Dexrq/qRtVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP8fmEjkpuuBQRuhhsGryEzQDqXFk8W6r7lExHuHh32KriiczSAv50Ux4MXTnhNrszY6dtbJVCd6ejgCkze1Xh+8aGAQ48c2UgLlZt16SietQceYVZNTR4LJHWzGOdZjGtQ5nFGXbeJ8qgW6ky1Hxx+ZGQSSG69iOHeY0DwrNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGaZ2eJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGaZ2eJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02747C4CEE7;
	Mon, 13 Oct 2025 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370297;
	bh=JSZCIXXtwxHsEdR7Tp9DbRRAi+OsOBH6Dexrq/qRtVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGaZ2eJq6NBkSl2u2oELy6l0K/h9xSJXUBD3MzvLygo3ubgn/jDaQ0V24vHh9lJZj
	 BUuLjV/Y1Hy3YOiPSpwU2/FcPhTBALEjnALP2pM+B3GeJW8c7lZv0ZqG4j0VU7+Zqy
	 Fgk94VO77US52rF7WT0wWh1CRe1bXdNBX/xrp75M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.17 547/563] Input: atmel_mxt_ts - allow reset GPIO to sleep
Date: Mon, 13 Oct 2025 16:46:48 +0200
Message-ID: <20251013144431.122778282@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

commit c7866ee0a9ddd9789faadf58cdac6abd7aabf045 upstream.

The reset GPIO is not toggled in any critical section where it couldn't
sleep, allow the reset GPIO to sleep. This allows the driver to operate
reset GPIOs connected to I2C GPIO expanders.

Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Link: https://lore.kernel.org/r/20251005023335.166483-1-marek.vasut@mailbox.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -3317,7 +3317,7 @@ static int mxt_probe(struct i2c_client *
 	if (data->reset_gpio) {
 		/* Wait a while and then de-assert the RESET GPIO line */
 		msleep(MXT_RESET_GPIO_TIME);
-		gpiod_set_value(data->reset_gpio, 0);
+		gpiod_set_value_cansleep(data->reset_gpio, 0);
 		msleep(MXT_RESET_INVALID_CHG);
 	}
 


