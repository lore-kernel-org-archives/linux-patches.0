Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB891DDE9;
	Thu, 30 Jan 2025 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246697; cv=none; b=b4cIo0xf0eup4sI0YpXDZg8E42f1333T2eaGbobtErfV6bvo5asav6+z2dJfNeCXPRmMMtvhWSzYp/8i8Qo1U83y5GvMm121CPXbmnmHHaoUiJN1MD0G8/ng1Bxl69Bdm+olEAq9i6Hmoj7cTyFgcg3CQRUxZgm6bD01qD4qUyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246697; c=relaxed/simple;
	bh=9DqfUMu/pCYX6O1xoMdJifKxXISFWgTVdVX1Ht3Oa1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tej42fgINzE26h3EwBnL4RWZ2jOWNcFSjwjzSpRmUohqyCViA97iKzUXRYenFSYYd4AbI/2FrrlkJfQxO/jURT74i4H40TYLNt4J/pxZ/WJjXQHFg+iOOAiCSk3UDoQuGQ5Ppk6X6ZSCssweTJsL03rPH8jJRWXJGNHgcXY1qA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwRKtfiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwRKtfiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93D7C4CED2;
	Thu, 30 Jan 2025 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246697;
	bh=9DqfUMu/pCYX6O1xoMdJifKxXISFWgTVdVX1Ht3Oa1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwRKtfiLhIFM3svhDT7hebq+DN93Cc+CfExFDheMmreGaUBDFZwMclnDq7OMC7UIh
	 rEOLp8bJ8Asr2tKXp7w34gQGh75uvZHAQhKzpxj2joWMMX5bHQD0RTGBZSWb3p89QT
	 W442mkMM0oEdITIVJ9xM+fQ2FtKBhuM8VatqR3Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 36/91] iio: adc: at91: call input_free_device() on allocated iio_dev
Date: Thu, 30 Jan 2025 15:00:55 +0100
Message-ID: <20250130140135.114843517@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1139,7 +1139,7 @@ static int at91_ts_register(struct at91_
 	return ret;
 
 err:
-	input_free_device(st->ts_input);
+	input_free_device(input);
 	return ret;
 }
 


