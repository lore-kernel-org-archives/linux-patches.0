Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0E12CDA5;
	Sun,  7 Jun 2026 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829939; cv=none; b=qT+JhwVwcG1BPrpO1oBWnYtkgNarWGSpwHgJRjiv23is9N9yW21/FKr3nKchRlj+a+KIbw3ysahdBtueTRtANglllJC/TcLUUFxwqI2s/s9snp8AAeyw8121IXiTWuOnuvE7QtE46dtXLF4jBgBR/47A7Qa761LeNCSajlGz4E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829939; c=relaxed/simple;
	bh=3SOKXIaBQno+5AaSAjhDpPTO0v9c60Ff3NdKwL6zYrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKdTSFF7lYmKZuM9Urq9OdP9/IXgob2JX9n+2R8kR0otZ7OdlgXtDfW2pxoPfcFyzHtI8Jsoa65lfprgumPmwyS0HsiLJVul5p9wg7qFWiVIfVbl8mw+Gnh2T22pBsGOW6wkrSKazLByOlM+2RQCvyi7jQjOqMi87shI41kHci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnrFDTeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnrFDTeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49CF1F00893;
	Sun,  7 Jun 2026 10:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829938;
	bh=/GSDwjDsuQnekFrkVZadFZWEsGU2enI/OuUHlyNImzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnrFDTeNWPHlklClXucl+WArk2X/I0SW9NoIi61wUrC2+zUDvC0TGBsGQuWvpO54Q
	 wLZoW0p5q0al06Mqk62xRTOB3+olzkGnR7Gm+roMR+QTIWJXg6OHOFtY9cMG2RPXSs
	 ttdf+auhNr/oTwrmHM7KcoJFgOQrnnF43205JWPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 328/332] hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pmbus_lock
Date: Sun,  7 Jun 2026 12:01:37 +0200
Message-ID: <20260607095740.179479064@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 4e4af55aaca7f6d7673d5f9889ad0529db86a048 ]

adm1266_state_read() backs the sequencer_state debugfs entry and
issues an i2c_smbus_read_word_data(client, ADM1266_READ_STATE)
against the device without taking pmbus_lock.  pmbus_core holds
pmbus_lock around its own multi-transaction sequences (notably the
"set PAGE, then read paged register" pattern used by hwmon
attributes), so an unlocked debugfs reader can land between a PAGE
write and the subsequent paged read in another thread.  READ_STATE
itself is not paged, so it cannot corrupt PAGE in flight, but the
same defensive serialisation that applies to the GPIO accessors
applies here: any direct device access from outside pmbus_core
should be ordered with respect to pmbus_core's own.

Take pmbus_lock at the top of adm1266_state_read() via the
scope-based guard().

Fixes: ed1ff457e187 ("hwmon: (pmbus/adm1266) add debugfs for states")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-8-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -328,6 +328,7 @@ static int adm1266_state_read(struct seq
 	struct i2c_client *client = to_i2c_client(dev);
 	int ret;
 
+	guard(pmbus_lock)(client);
 	ret = i2c_smbus_read_word_data(client, ADM1266_READ_STATE);
 	if (ret < 0)
 		return ret;


