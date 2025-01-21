Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0296D1F0E36;
	Tue, 21 Jan 2025 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482939; cv=none; b=kkPf5VqVrbTEERqXzk6nbOE2Qem2NzvMLssqWQtscoCaE/d5Slhm74/CPweZbgLFcaDl9S08SMkby6msTOh/Q8/SUs3B6NsOZlhceaxHi/Wd23nEOMr0TzWHra2kepnoZhtSMyy0OvQDYNIDcN3zqiGLRYxqdF77DYJ15NDhPBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482939; c=relaxed/simple;
	bh=165tOD89rspRDgJgk4HI2jHZCEYnYz1sBW/mDVY2YRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv+8E8dI57Upu/S03R7LPOZOUF6VeqlfLmzKQ4AwFej1MoQTfCv4enEYl/2/hOGrz7Thrk674Bi5IK+UzHmY758q1mKAuyfNKn1VJTANm6bDQbAB7LdYVEqLSBPq8pE0+Ic6JWII7PMYheiW423+4i9VxV2cJFidGMWLka+oclQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOdCqROi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOdCqROi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24480C4CEDF;
	Tue, 21 Jan 2025 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482938;
	bh=165tOD89rspRDgJgk4HI2jHZCEYnYz1sBW/mDVY2YRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOdCqROicpkWgXgG5Vm3o1ZmZ74HhRizxKcFF/cR4SwiJLKG1eAfM+Q5wRHhnojbk
	 U47Dm0DxPGPa7n4NqSh7uiL5aOeQ0To8VqyNVNSdUKWuFt/7H4db1acqJbO89qoWri
	 q3D9hM0AvE4tv5uajOmE4qyXs8cnKSqqOfD244J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 060/127] iio: adc: at91: call input_free_device() on allocated iio_dev
Date: Tue, 21 Jan 2025 18:52:12 +0100
Message-ID: <20250121174531.977110000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


