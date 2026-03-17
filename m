Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482AE3A4F46;
	Tue, 17 Mar 2026 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766910; cv=none; b=P3074+mzWAjHwWiS8SE//nGI6t2iFG++qJrEaxYyEbsc9FQXaEMApvmfmJ0ExIB5agduwSqEh7l9JwBT0dVGApWzxZxMWjUwtWNFgnYfUEcWZAGf77xmcC1h1MKpm0i8PGtdHiBuT0oUHN1LF5iVn7m6Py1yrO55DB5ImjvbGGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766910; c=relaxed/simple;
	bh=iiL4IbO5dp02fUSs46CquWXuTQU4CseQlo8UKisEHQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qE3W04ep54EUseRn2OIMGN2wFTDZ9YsLOWlbEAfr9zFGWrfbP9eL+GYqCktDOglnWGHC4pz9oJvkEZfPI9oDO0D84/F79HX5HK0Weatr2WWBtb83hQhKydVQQWl5+d4qk3cI9OAqIQIGxw1Lkq8AesCmIdRZPGYd9dY48b5lho0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+PgOE9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+PgOE9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74B8C4CEF7;
	Tue, 17 Mar 2026 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766910;
	bh=iiL4IbO5dp02fUSs46CquWXuTQU4CseQlo8UKisEHQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+PgOE9I0pIdgu8br8LqCDeLOJjTnpcCrklccRUGJLidne4G2rmEsGiwfuNfZNQjp
	 py31WdZGlPALXxVJp3b4qMzBC5NLvQ7Ys5e8tCqCE6c/4ymXMYGy3FceKtoLViv5Y8
	 uLAFSbu7+sXDrbjWbX0iCrwRcY3PNizRQz87op0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 349/378] iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()
Date: Tue, 17 Mar 2026 17:35:06 +0100
Message-ID: <20260317163019.828182316@linuxfoundation.org>
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

commit 216345f98cae7fcc84f49728c67478ac00321c87 upstream.

sizeof(num) evaluates to sizeof(size_t) (8 bytes on 64-bit) instead
of the intended __be32 element size (4 bytes). Use sizeof(*meas) to
correctly match the buffer element type.

Fixes: 8f3f13085278 ("iio: sps30: separate core and interface specific code")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Acked-by: Tomasz Duszynski <tduszyns@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sps30_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/sps30_i2c.c
+++ b/drivers/iio/chemical/sps30_i2c.c
@@ -171,7 +171,7 @@ static int sps30_i2c_read_meas(struct sp
 	if (!sps30_i2c_meas_ready(state))
 		return -ETIMEDOUT;
 
-	return sps30_i2c_command(state, SPS30_I2C_READ_MEAS, NULL, 0, meas, sizeof(num) * num);
+	return sps30_i2c_command(state, SPS30_I2C_READ_MEAS, NULL, 0, meas, sizeof(*meas) * num);
 }
 
 static int sps30_i2c_clean_fan(struct sps30_state *state)


