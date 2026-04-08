Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC603537DF;
	Wed,  8 Apr 2026 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674747; cv=none; b=vBI8D8+JWZUge6pSxShONyQ0qtu5NkVh5yZsP4RcciXdETFBdhiLf2Ws9ttSLXGVb0rd07BLlOS3LMEsXyYOy1V5ZKg6YQVcGFQL+46BQlhPfJrCARziViKjM4UmGcFKPdyfkp+1oWOY9BI79se7qoRw/oj3jjpR90YMMD3rSwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674747; c=relaxed/simple;
	bh=syY8TBSTTkjjl1nel26r9jPQU4C+bi8RsnnQEXKeCMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp7I3CX1NYa3B1XpCboDrlzDNmhC/wQGtT7KlchiejQDrFx5LGIg1gmYe2yO4VUuVYlMCiuL8GNk8UGJ6zEnube3xq81gkjUn3GwGp6JpUp3bkp5TqixJlUZXTZQibPnf79BqP3GmBHbJyu3unX5O1fzfNgaTAm5iwqIKKoPwCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqFdxnrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqFdxnrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEC4C19421;
	Wed,  8 Apr 2026 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674746;
	bh=syY8TBSTTkjjl1nel26r9jPQU4C+bi8RsnnQEXKeCMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqFdxnrYM0XmjcMa+ZxeJ8p/8hczk54gvQVYuCTQilNffJA7qEGmloy4bnahmgQrR
	 clFAPqRH8MK7Ek5BOsVGf1DLPodF58swGOsfaHWZnY62l/JSgR1R07+1qgYeUuTm6h
	 +5TK9g42OBQHfRkTS6kNQXuzvM6TUUbB42CbbX9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 218/311] iio: adc: ade9000: fix wrong register in CALIBBIAS case for active power
Date: Wed,  8 Apr 2026 20:03:38 +0200
Message-ID: <20260408175947.544036241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>

commit 86133fb1ec36b2f5cec29d71fbae84877c3a1358 upstream.

The switch statement in ade9000_write_raw() attempts to match
chan->address against ADE9000_REG_AWATTOS (0x00F) to dispatch
the calibration offset write for active power channels. However,
chan->address is set via ADE9000_ADDR_ADJUST(ADE9000_REG_AWATT,
num), so after masking the phase bits, tmp holds
ADE9000_REG_AWATT (0x210), which never matches 0x00F.

As a result, writing IIO_CHAN_INFO_CALIBBIAS for IIO_POWER always
falls through to the default case and returns -EINVAL, making
active power offset calibration silently broken.

Fix this by matching against ADE9000_REG_AWATT instead, which is
the actual base address stored in chan->address for watt channels.

Reference:ADE9000 datasheet (Rev. B), AWATTOS is the offset correction
register at 0x00F (p. 44), while AWATT is the total active power
register at 0x210 (p. 48).

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Reviewed-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -1123,7 +1123,7 @@ static int ade9000_write_raw(struct iio_
 			tmp &= ~ADE9000_PHASE_C_POS_BIT;
 
 			switch (tmp) {
-			case ADE9000_REG_AWATTOS:
+			case ADE9000_REG_AWATT:
 				return regmap_write(st->regmap,
 						    ADE9000_ADDR_ADJUST(ADE9000_REG_AWATTOS,
 									chan->channel), val);


