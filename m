Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFDA248BA0;
	Wed, 15 Jan 2025 10:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937769; cv=none; b=QZIamGQBTg/5Z7tvjcv2YIq8v+4I/Cka01nKVlmqtgd5S8MVIesVNn5ych1WbXbXl7jpjM7C0Ket8IyMH1gBkjVmcrEnyMfTEoKaCV/JmhKZORl5+X7Kgr7UjC5VSosR3WRwBK7WPs717dSMBTjy8s3KdfoN/ohP5pgP+kwjcMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937769; c=relaxed/simple;
	bh=DutQSeLd86Mpd7ATy2+w2E0FviEP2rwhnh6ARmobA2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGb3FARdEwXMq+jrBEzO8nRtJHs1d3KU8uXHrhC3ltnDMzvz6+MzuYopPoH7//1NOlVdX855NX76oXFj7n0fKKK9slAOb4RXbYBwElx9ogLJH21buTV/kPyqpk8QXb5APvgelvtxegzRJWbBGWQsHn4gsDtHurl46f7dKnR9aHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgVJVoup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgVJVoup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FEBC4CEE1;
	Wed, 15 Jan 2025 10:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937769;
	bh=DutQSeLd86Mpd7ATy2+w2E0FviEP2rwhnh6ARmobA2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgVJVoupvsxjEw+jDtAPyz4+pIQIooszcsTWjBD7sDxuwUY8mKZURt95UuIQEehTZ
	 HDkr/RxtojYiK1UAZ+3zGFfe8KsAM7xKbTuRmsWTUtz5z81oU5isV5i2B9B+hwJTIy
	 L5CGJlMNzHoDgKRA9CV9/tJYQkWmJLHRLq6WpxY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 76/92] iio: adc: at91: call input_free_device() on allocated iio_dev
Date: Wed, 15 Jan 2025 11:37:34 +0100
Message-ID: <20250115103550.596276968@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit de6a73bad1743e9e81ea5a24c178c67429ff510b upstream.

Current implementation of at91_ts_register() calls input_free_deivce()
on st->ts_input, however, the err label can be reached before the
allocated iio_dev is stored to st->ts_input. Thus call
input_free_device() on input instead of st->ts_input.

Fixes: 84882b060301 ("iio: adc: at91_adc: Add support for touchscreens without TSMR")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241207043045.1255409-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -985,7 +985,7 @@ static int at91_ts_register(struct iio_d
 	return ret;
 
 err:
-	input_free_device(st->ts_input);
+	input_free_device(input);
 	return ret;
 }
 


