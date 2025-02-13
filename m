Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFB226B0BF;
	Thu, 13 Feb 2025 15:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459814; cv=none; b=kjTYhfSdXpv0hkbb04urGbzSnaRlwNYnR/hcDP3bX/NmtObj7lHgdiKbT6U9DTdzsUoypnBZDcK+PV9WVhG7cVThcYmvCWpoNfo8wlC8VKkuPg9VWZ98/4wXaW6LiZWTTDbWOVDeqaQ1aPUNXpINddYKygaRQBk3n3DfSiOJ1cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459814; c=relaxed/simple;
	bh=Ap/YiH+XQX+lU/shdhooxjUdJcsV2Dg2YfIufWb6ksc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpUbc7NhTzUuTHN0F4s20bvOMM0Pu/9sBgUOUhQvKnNVL2mlkPnJK0yX/LLcq+HE2rDheDy+dBnzZbK7dVlUnGkuQj6n5l2Rg6n62BlFS9r0TS3H3L3klsOchA9GsmCjxU6osBP2F0NTQSjNy807JtCLZxecMARG+b8d+oo8dNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASnRMO1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASnRMO1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83582C4CED1;
	Thu, 13 Feb 2025 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459814;
	bh=Ap/YiH+XQX+lU/shdhooxjUdJcsV2Dg2YfIufWb6ksc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASnRMO1heX8lZrsxB/UQgfiKBN8UKEetAxoYDLfU2C8qJuXytwQmZLFedCkj1HvbX
	 lay1mTaUvJL+P7Q+oBPOdy61e9VDLexhhpYc7z1OKV5dOutu6TUxKKSPWt2BAhNYVM
	 K2RiVNBXi2wUl/UTIh5t4amysm1Gr74nS5r/Liek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.13 344/443] iio: chemical: bme680: Fix uninitialized variable in __bme680_read_raw()
Date: Thu, 13 Feb 2025 15:28:29 +0100
Message-ID: <20250213142453.897348240@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 20eb1fae4145bc45717aa8a6d05fcd6a64ed856a upstream.

The bme680_read_temp() function takes a pointer to s16 but we're passing
an int pointer to it.  This will not work on big endian systems and it
also means that the other 16 bits are uninitialized.

Pass an s16 type variable.

Fixes: f51171ce2236 ("iio: chemical: bme680: Add SCALE and RAW channels")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://patch.msgid.link/4addb68c-853a-49fc-8d40-739e78db5fa1@stanley.mountain
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/chemical/bme680_core.c b/drivers/iio/chemical/bme680_core.c
index d12270409c8a..a2949daf9467 100644
--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -874,11 +874,11 @@ static int bme680_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_RAW:
 		switch (chan->type) {
 		case IIO_TEMP:
-			ret = bme680_read_temp(data, (s16 *)&chan_val);
+			ret = bme680_read_temp(data, &temp_chan_val);
 			if (ret)
 				return ret;
 
-			*val = chan_val;
+			*val = temp_chan_val;
 			return IIO_VAL_INT;
 		case IIO_PRESSURE:
 			ret = bme680_read_press(data, &chan_val);
-- 
2.48.1



