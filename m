Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C74FD294;
	Tue, 13 Oct 2026 12:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894758; cv=none; b=AH5og5WJG4p+0w4SMq6ieU9lh2klLYZMQI+UG9z7adJ+z1LnSFv+HIswGofwUFwCgUrezAVw5lyNZ+LuWF5m1DNZB3epH0DkLkv824tT+T3rEh3L9/jhewHMnUiCJCFBdV/thhnlm2QMZE3cLgGNORLWJYQCmTB6B+AZ2re5pBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894758; c=relaxed/simple;
	bh=a6zr1CRkRyJpmxD9WBsqimawzyc+OnbDswnyosvAyG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FC7rIQSd+6dvpy5NWg6CJnKtiS5t43Jka43QZDUV0aMEJdTeI6B3uOrdGd7mk6w+LsjQGxWMkwK1500oKOUTxQcp3GZH5G4nUtHEUjdabYnD7NMX3HE9OuR0zQh5StHqtQEcnaHW5KpeH/WjEHk0Ek2XWVEAajh/Man/X39d3s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHZjoo7c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHZjoo7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BE61F000FF;
	Tue, 13 Oct 2026 12:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894757;
	bh=hg/rT9AJWD3wWngurTRAowD20uhXkEV6wn8hFfLomls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHZjoo7cY23uylujVUXoH2OCdjRryhRiptzhSpcIDpu8ETv7+rIjMXSo1QpqB5OP8
	 e4imB4n+7T7ylkjBq8CyWKyL9Uz2GrypX3h3iJ/RiTcxfP6VCh3NNcVf4Sn/ncJxPL
	 czIs/zM/heWEyOsGBukcPz/G6DokAukyOpFAwFAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/497] iio: accel: kionix-kx022a: Fix array boundary check
Date: Tue, 13 Oct 2026 13:33:34 +0200
Message-ID: <20261013112909.004767426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 0e65412aee4f651d2c9785f542a13e4b44002a75 ]

The driver performs a sanity check for an array size, when converting a
register value to an array index. The check incorrectly accepts the
sizeof(array) as a last index, when last valid index should be
sizeof(array) - 1.

Fix the check by bailing out when index >= sizeof(array).

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index b6a828a6df934..db78a1945956d 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -626,7 +626,7 @@ static int kx022a_read_raw(struct iio_dev *idev,
 		if (ret)
 			return ret;
 
-		if ((regval & KX022A_MASK_ODR) >
+		if ((regval & KX022A_MASK_ODR) >=
 		    ARRAY_SIZE(kx022a_accel_samp_freq_table)) {
 			dev_err(data->dev, "Invalid ODR\n");
 			return -EINVAL;
-- 
2.53.0



