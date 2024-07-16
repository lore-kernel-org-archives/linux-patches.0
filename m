Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CBA19B3C4;
	Tue, 16 Jul 2024 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146218; cv=none; b=ItYa+uUdXzSpccNIEMA8TvIoMhAsj7ELMVZr+1l+Ifz1JxUssxA02Lai5Zf4qKTS3Yw/IjPEDyaKxxzCobGMqBiaOF2KUtbcodGrLepRm08DpXjVTlrWa/qyczYnLcHRocX2RxuKyirsgbtu2pqGIEe+Nc43vaVaUQCZc8x0WVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146218; c=relaxed/simple;
	bh=UlX1NHUhg53ZyTWsZADYxD9mN+XmLhBpRAnu1wYhNcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJNbb8ZEOvhka/a2aFrcJCiNa8ERaXKwJ65ogdxDzt7OogBH8gp1O6L/7kEwQ0aA0n8cfQHq69imlzOJ/vRC8bW9GffF2BVey83GeAhD42MJtDIBbojMDpzJ7BFDcAgj72Z4AV4AGjd/Difa87Rv3aj/79Lo0O7ROlQmE+DvOqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRn+ssOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRn+ssOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6748AC116B1;
	Tue, 16 Jul 2024 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146217;
	bh=UlX1NHUhg53ZyTWsZADYxD9mN+XmLhBpRAnu1wYhNcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRn+ssOtwOWGfLAPE2YVL+82959ObAEyLCUK7Km3pdvIdCBfz7vpLIKIo0COvzlQ7
	 4LRCbl9RePVY6A/cBKhb5i7mcXRINMPcMh8ggDDS7LHr+qsZs+Y55KIvq16cGcdBJ6
	 9pgtFHPHE7OM6oA8YxT8uUpVYGtZbImwRXMPjPoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 063/144] media: dw2102: fix a potential buffer overflow
Date: Tue, 16 Jul 2024 17:32:12 +0200
Message-ID: <20240716152754.970365182@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 1c73d0b29d04bf4082e7beb6a508895e118ee30d upstream.

As pointed by smatch:
	 drivers/media/usb/dvb-usb/dw2102.c:802 su3000_i2c_transfer() error: __builtin_memcpy() '&state->data[4]' too small (64 vs 67)

That seemss to be due to a wrong copy-and-paste.

Fixes: 0e148a522b84 ("media: dw2102: Don't translate i2c read into write")

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dw2102.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -786,7 +786,7 @@ static int su3000_i2c_transfer(struct i2
 
 			if (msg[j].flags & I2C_M_RD) {
 				/* single read */
-				if (1 + msg[j].len > sizeof(state->data)) {
+				if (4 + msg[j].len > sizeof(state->data)) {
 					warn("i2c rd: len=%d is too big!\n", msg[j].len);
 					num = -EOPNOTSUPP;
 					break;


