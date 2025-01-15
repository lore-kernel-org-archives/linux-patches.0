Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F811E98F0;
	Wed, 15 Jan 2025 11:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938890; cv=none; b=Vy/9DzsD4Fi29nzzUum+XTGqw5nRlfTDjD5yBtHa0TrKpnWbXWrab0hv/GlhybPq8HqZootpp9iX+YOl4ryyrJNmupnvjlvAiik5P+1owyv82lqqTt9mVCbj1zh8t+Y+F8xVzllEZ+xcBtPAu8Ax8M2X8smzUVPJ3uqN1Pa8MZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938890; c=relaxed/simple;
	bh=wKPfkV5oqc4TDtksOXpQlr7sET949s7A2AVDbBMtpfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4QOMK9oI34FGgtu/ePrpkoL7APrCo9EXSkHDf7IU7ciTjquwnom8BIORBo+VWMXrL/rzjSiD9kwdZskv9I3lmfz3vdXVeRqf+s81z/3QM+UKNlg/IeeCKCI0KVSmTe2Mmft6jYW0XilyLGjBZcaEpuKY54NvA+4honXObhu3jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcVxsKmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcVxsKmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2468C4CEDF;
	Wed, 15 Jan 2025 11:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938890;
	bh=wKPfkV5oqc4TDtksOXpQlr7sET949s7A2AVDbBMtpfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcVxsKmIKE0LzROA4BSl76WNK/C0Jr/1VtR78QspAITvYlx8D7EOOjvd1EU0e2rFI
	 hW5eEYQrseI+MW73bdjnRFkaACcPmOzVw8qYbFvM6K+2pF6iFBzPDnX036kPNWXd9B
	 6iDHsynuS1fZLhCRbln5UbaXkoF6W3W9VIGq+5w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 110/129] iio: adc: at91: call input_free_device() on allocated iio_dev
Date: Wed, 15 Jan 2025 11:38:05 +0100
Message-ID: <20250115103558.735612296@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -984,7 +984,7 @@ static int at91_ts_register(struct iio_d
 	return ret;
 
 err:
-	input_free_device(st->ts_input);
+	input_free_device(input);
 	return ret;
 }
 


