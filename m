Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C11FE47B;
	Sun,  7 Jun 2026 10:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828384; cv=none; b=nDKeKfBJC9vIVdhg+yqrkVYmtf8Ut/gJVYd+4EpIERohBXFbYFkLlW4dkSOxMLBKR+CFIS+PgnrahDbL6hWeSHAgM1+W4kD57DPC8Al+Ktp74c55aAb2+R4E+r+k7BKnR5TUpSlTPJ64L3dS6A475CdNyTqW9cUOlcNpyhb2Fm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828384; c=relaxed/simple;
	bh=M9j3WzclR2cYXIuBVOYNd+05bl2X0ZwjQPIhrvK5lag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzYOkuUeDDY01vBQowKAqd6U61CyHP9oXqVBYN6/dqA2o9IJhfSJnjNqw6WjOpjVWm0xMtvfkpKQdQR7ldoYoonsLfSnOXdNdc0Il8yGTcOmNSDYweGeV4s0HrXhuMeHly0ucQdan4/Pu7j+4Cq58t6szv2i4dieRq6uFMNlXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8Afq3Sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8Afq3Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44091F00893;
	Sun,  7 Jun 2026 10:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828383;
	bh=OFqK6/M4kRIl/343VxubFKHJDcnVvF4APlDqXZkVpJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8Afq3Shg+yBw/yEC79l8vjFl9Qz6oMTRHp3+/t9zwOHGE0kWsN1custDJNmm8X/Q
	 9MYzFHSKEZ4mjZjgvf4DX80cAwff3bM6zcP11FaiQGm2WLlgxbEbQBlst/FRM/pUVe
	 9vNlYI75bv0dqOHd9+aZULGvLLHVjFwBz6OleJi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 177/332] iio: dac: max5821: fix return value check in powerdown sync
Date: Sun,  7 Jun 2026 11:59:06 +0200
Message-ID: <20260607095734.565535323@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit d0a228d903425e653f18a4341e60c0538afb6d41 upstream.

The function max5821_sync_powerdown_mode() returned the result of
i2c_master_send() directly. If a partial transfer occurred, it would
be incorrectly treated as a success by the caller.

While the caller currently handles the positive return value of 2 as
success, this patch refactors the function to return 0 on full success
and -EIO on short writes. This ensures robust error handling for
incomplete transfers and improves code maintainability by using
sizeof(outbuf).

Fixes: 472988972737 ("iio: add support of the max5821")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/max5821.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/dac/max5821.c
+++ b/drivers/iio/dac/max5821.c
@@ -90,6 +90,7 @@ static int max5821_sync_powerdown_mode(s
 				       const struct iio_chan_spec *chan)
 {
 	u8 outbuf[2];
+	int ret;
 
 	outbuf[0] = MAX5821_EXTENDED_COMMAND_MODE;
 
@@ -103,7 +104,13 @@ static int max5821_sync_powerdown_mode(s
 	else
 		outbuf[1] |= MAX5821_EXTENDED_POWER_UP;
 
-	return i2c_master_send(data->client, outbuf, 2);
+	ret = i2c_master_send(data->client, outbuf, sizeof(outbuf));
+	if (ret < 0)
+		return ret;
+	if (ret != sizeof(outbuf))
+		return -EIO;
+
+	return 0;
 }
 
 static ssize_t max5821_write_dac_powerdown(struct iio_dev *indio_dev,


