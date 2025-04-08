Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4BA267F65;
	Tue,  8 Apr 2025 11:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111657; cv=none; b=dDzT4SMY2J2aff6HWpLze3giwxoIXfSto7H6XulrnDOU2UEJPKRuicZ2NAhWMh2hIwwf2teEjs3Fpp97kjNHL+Jw5GBIIBfAMs5Qpzxj75Jw/vDgIOBrR1kPTq5DdkbNHxHK0aqUG6CBxS6yNLYXvmoN4qTHIEmvkrdS7P941H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111657; c=relaxed/simple;
	bh=9fGzitvoiZIoAo3/6fJr8hvcd+3QBfz44g11BF2dccA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0kLvit6z19LWFrv9fPD4I64Xq7ZIULbiZu5HONf2/XeDaXD/Z05xCLmfNv3gTzHbbzHv2nQoxoTPiIKxmJMzQzgCRTVh94dE9RPxR4FX4ei7KGNggbg7kKrgiHOfVKIUalOHSrJ1KMBgkswxe8XeKmIRbj97bUqXdjmknIi+UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMVoe2mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMVoe2mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478DAC4CEE5;
	Tue,  8 Apr 2025 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111657;
	bh=9fGzitvoiZIoAo3/6fJr8hvcd+3QBfz44g11BF2dccA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMVoe2mUojW8mB/ZUyQMECymy+xacyVxJtXP7998OMpr1E8Znr94Cux95LtkBOlLf
	 Lsp/15ZXJh2sOQ/vKTSYq6P8usKdzx+YTfHRxmGwMuBIKR5X56XXms+zJpt0aVJUFK
	 N+IWgITGvsWZxtI62wKl6r4seavcX99Rd/TYPRRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 471/731] iio: accel: mma8452: Ensure error return on failure to matching oversampling ratio
Date: Tue,  8 Apr 2025 12:46:08 +0200
Message-ID: <20250408104925.234376434@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit df330c808182a8beab5d0f84a6cbc9cff76c61fc ]

If a match was not found, then the write_raw() callback would return
the odr index, not an error. Return -EINVAL if this occurs.
To avoid similar issues in future, introduce j, a new indexing variable
rather than using ret for this purpose.

Fixes: 79de2ee469aa ("iio: accel: mma8452: claim direct mode during write raw")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250217140135.896574-2-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 962d289065ab7..1b2014c4c4b46 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -712,7 +712,7 @@ static int mma8452_write_raw(struct iio_dev *indio_dev,
 			     int val, int val2, long mask)
 {
 	struct mma8452_data *data = iio_priv(indio_dev);
-	int i, ret;
+	int i, j, ret;
 
 	ret = iio_device_claim_direct_mode(indio_dev);
 	if (ret)
@@ -772,14 +772,18 @@ static int mma8452_write_raw(struct iio_dev *indio_dev,
 		break;
 
 	case IIO_CHAN_INFO_OVERSAMPLING_RATIO:
-		ret = mma8452_get_odr_index(data);
+		j = mma8452_get_odr_index(data);
 
 		for (i = 0; i < ARRAY_SIZE(mma8452_os_ratio); i++) {
-			if (mma8452_os_ratio[i][ret] == val) {
+			if (mma8452_os_ratio[i][j] == val) {
 				ret = mma8452_set_power_mode(data, i);
 				break;
 			}
 		}
+		if (i == ARRAY_SIZE(mma8452_os_ratio)) {
+			ret = -EINVAL;
+			break;
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.5



