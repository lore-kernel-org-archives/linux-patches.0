Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DCA3A7F4C;
	Mon,  4 May 2026 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903900; cv=none; b=MM3/ozn5z/5xFtHHxp7pTZlq7mzGBrOLpGfYmg160ugNU4zHG5QwaN8PwQYiMTqQhzc44WIJ4Uq+Bdnhiunr01l0gFiw9GzaYLdeUEjqDR3B6a3ed6vGNtDu7QWmqdXnPejybkfFIL6tyWSwmMKAFHQLiNwlcO7t9+52AVyGhQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903900; c=relaxed/simple;
	bh=kB59HT8GKbOkwh7f4/qI9IWf7SdguP3hKqpfVJ06Lzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHuCKp7Fqmh0+5ACZI8BfOdj4zsYcVIXUqXQCV4Vse7bFongj3le1ymVKe97P7LXMox5yNX6w2JHwxGNaS8TUAHpF8prbG50QPcH2EKgZdsplWwDt1wOsItS81fwb7fuNxDDguQY+wjzpjoVY2yrv6/7qTgt6c9xsjJYGlY99BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kraawu2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kraawu2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C18C2BCC4;
	Mon,  4 May 2026 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903899;
	bh=kB59HT8GKbOkwh7f4/qI9IWf7SdguP3hKqpfVJ06Lzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kraawu2yfmqfJfuZ1QIDwnfhGLEd89yiF9H0O1FMnMoNV4xgar/CJKXlfYuqCm0Ez
	 m/akZgbEzrraZIzxreaaIx1lsra7DfnBxEClOmCoJ43Jtut9lMJNtdoDefA0bWLg2d
	 koZJa6S8TcloJW1K3XMXrhp+pXcFVr12k21fK0bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 106/275] iio: adc: ad7768-1: fix one-shot mode data acquisition
Date: Mon,  4 May 2026 15:50:46 +0200
Message-ID: <20260504135146.849909331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

commit 8be19e233744961db6069da9c9ab63eb085a0447 upstream.

According to the datasheet, one-shot mode requires a SYNC_IN pulse to
trigger a new sample conversion. In the current implementation, No sync
pulse was sent after switching to one-shot mode and reinit_completion()
was called before mode switching, creating a race condition where spurious
interrupts during mode change could trigger completion prematurely.

Fix by sending a sync pulse after configuring one-shot mode and
reinit_completion() to ensure it only waits for the actual conversion
completion.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -389,12 +389,17 @@ static int ad7768_scan_direct(struct iio
 	struct ad7768_state *st = iio_priv(indio_dev);
 	int readval, ret;
 
-	reinit_completion(&st->completion);
-
 	ret = ad7768_set_mode(st, AD7768_ONE_SHOT);
 	if (ret < 0)
 		return ret;
 
+	reinit_completion(&st->completion);
+
+	/* One-shot mode requires a SYNC pulse to generate a new sample */
+	ret = ad7768_send_sync_pulse(st);
+	if (ret)
+		return ret;
+
 	ret = wait_for_completion_timeout(&st->completion,
 					  msecs_to_jiffies(1000));
 	if (!ret)


