Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6956E1ACEDE;
	Tue, 17 Mar 2026 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766906; cv=none; b=q9R7dAKVJy1tDkzJ/yH+M1BnFE7fFjqdKtYj2KyurIVGqtFKLM+a47Od9cuTRUsw4hT4qdDkHp55PJQ7oU1GFI9jCULIxOxovccFMWuPBuvg8OsSOlwlfdqcriBX1e16G1QVpXwaAzGGdpsdziSs4bqcW7k1oUkHTezOiF4T88g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766906; c=relaxed/simple;
	bh=Wwisc8fP9J8C5AoMsszGqBpYGFcaDrcVe+mq++HI95Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFX+tDuAxy63uk4M5Ds72O7PjJhrvIEpjwhi2FLG4u6rR5N+iG2MjzbB+YjWrwfEIMx8i2TXctzbq2Rj09cKlL0Z/59DGwl8DMK11Tcszd89WCdggSzYcF9LCv4etk24MGocDvaCNTxjOVlohKjqo2oCwN26qYZmfUxP01pPDlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9HMSEB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9HMSEB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941B0C4CEF7;
	Tue, 17 Mar 2026 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766906;
	bh=Wwisc8fP9J8C5AoMsszGqBpYGFcaDrcVe+mq++HI95Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9HMSEB5muJkSIpHo0U2GraMK57XkCqfRBcxEixHyPhvf7QdrZbDf8o1TsCM2+jSk
	 iroq3pm53WHQnWnyJA0lPtLvMCCHQ06ew9oFYycnyDrj68PmeVyzQLHvyk0B4SCfkz
	 Te2JCa1VmWwEPxWHXruNfeqqdkzmSzmtVa5yBzww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 348/378] iio: chemical: sps30_serial: fix buffer size in sps30_serial_read_meas()
Date: Tue, 17 Mar 2026 17:35:05 +0100
Message-ID: <20260317163019.792364666@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c3914ce1963c4db25e186112c90fa5d2361e9e0a upstream.

sizeof(num) evaluates to sizeof(size_t) which is 8 bytes on 64-bit,
but the buffer elements are only 4 bytes. The same function already
uses sizeof(*meas) on line 312, making the mismatch evident. Use
sizeof(*meas) consistently.

Fixes: b2e171f5a5c6 ("iio: sps30: add support for serial interface")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Acked-by: Tomasz Duszynski <tduszyns@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sps30_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/sps30_serial.c
+++ b/drivers/iio/chemical/sps30_serial.c
@@ -303,7 +303,7 @@ static int sps30_serial_read_meas(struct
 	if (msleep_interruptible(1000))
 		return -EINTR;
 
-	ret = sps30_serial_command(state, SPS30_SERIAL_READ_MEAS, NULL, 0, meas, num * sizeof(num));
+	ret = sps30_serial_command(state, SPS30_SERIAL_READ_MEAS, NULL, 0, meas, num * sizeof(*meas));
 	if (ret < 0)
 		return ret;
 	/* if measurements aren't ready sensor returns empty frame */


