Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E221ACEDE;
	Tue, 17 Mar 2026 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766914; cv=none; b=a6WcWWv5N6/edZ6ZqJB4a9UuPiOIMkdiZtj02Dreb+6qR6+0qOl6bIe0zd2A+z7Gkzb6VBvtTeUWsuGU7IOe1p6DwZG8jGr3NauoiLONrjHzpiosgAtZ/5fRspEUoZq4aY8vtkf36CZF9yqLo5Wbw2/nQwZSbnDzqCY9VJEnw0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766914; c=relaxed/simple;
	bh=ZrfB9ATPuk3s3iOK0VEXigWeBqKIaRb7uvQCInLV29I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iI+zHxzx30V4Hri5XiyuTBsYClV3zCTncwCvpnaxb/l7qz0TCKyp5oGzp5u/aF11YV4Vw4cQMxOgGzm/OzFk5ClwCY+WCzpSSfctebPps2LJYKzI0qSt78Gul5+bKPCULD7Gx/Yrcs/t9nRGVkClnkYUvB/JbC10p8hb1ExmoeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTX4uNJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTX4uNJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DF1C4CEF7;
	Tue, 17 Mar 2026 17:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766914;
	bh=ZrfB9ATPuk3s3iOK0VEXigWeBqKIaRb7uvQCInLV29I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTX4uNJqeBoWa1Xkl2Zj04YIkUSpZH5YfUDS8ph6gNic/3wNOjh7E7r1vAxefYzOD
	 L0b2UaCvMCstE1WVgN9as5XwVCfVMYHoQ2wa/coYT7pNYjMMfGewsN3UXDTCzPEAVS
	 xfR4BA3u1An8irlY0cRmoGtWVzKShlJFkJFaub0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 350/378] iio: magnetometer: tlv493d: remove erroneous shift in X-axis data
Date: Tue, 17 Mar 2026 17:35:07 +0100
Message-ID: <20260317163019.863958467@linuxfoundation.org>
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

commit 82ee91d6b15f06b6094eea2c26afe0032fe8e177 upstream.

TLV493D_BX2_MAG_X_AXIS_LSB is defined as GENMASK(7, 4). FIELD_GET()
already right-shifts bits [7:4] to [3:0], so the additional >> 4
discards most of the X-axis low nibble. The Y and Z axes correctly
omit this extra shift. Remove it.

Fixes: 106511d280c7 ("iio: magnetometer: add support for Infineon TLV493D 3D Magentic sensor")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/tlv493d.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/magnetometer/tlv493d.c
+++ b/drivers/iio/magnetometer/tlv493d.c
@@ -171,7 +171,7 @@ static s16 tlv493d_get_channel_data(u8 *
 	switch (ch) {
 	case TLV493D_AXIS_X:
 		val = FIELD_GET(TLV493D_BX_MAG_X_AXIS_MSB, b[TLV493D_RD_REG_BX]) << 4 |
-		      FIELD_GET(TLV493D_BX2_MAG_X_AXIS_LSB, b[TLV493D_RD_REG_BX2]) >> 4;
+		      FIELD_GET(TLV493D_BX2_MAG_X_AXIS_LSB, b[TLV493D_RD_REG_BX2]);
 		break;
 	case TLV493D_AXIS_Y:
 		val = FIELD_GET(TLV493D_BY_MAG_Y_AXIS_MSB, b[TLV493D_RD_REG_BY]) << 4 |


