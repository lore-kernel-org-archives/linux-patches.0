Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B759534751D;
	Thu,  2 Jul 2026 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010299; cv=none; b=R4xa6liYr6ZAyrlfP0SAVqYkRYVWq/TKQ71Z+oRwUd9faiiDoEggKZMshv41UFdXblo4eRvvRUjwpYYFtE57dBnOBOCTWW04uc7HhK2rogKtU9tw4OXP7JHWKzT245q8noG8ChooW6dElISzFPeivTZcqTwA5W/18kUSPxQZXzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010299; c=relaxed/simple;
	bh=/Oq3MqBU+7xFhJM3yhRxv6TobmS91uNmNcF+bJJqKIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaMWsyyNHyJBiJF3V8wBsrg1xlTDbrMU98WvZlhgKNCLB2pD7P5U5q2NBvPcpQEq+fthD3qpRifAyyWv2nel1HQ1701U2n3OxIaT3ZZAFUO/kojUIm3A3uaZ3lp/DOTkw6wEcgNQ2B4LgV7ACX3RwImG1Jb9Io1Z9ZDSndUuUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycxp+azU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycxp+azU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9781F000E9;
	Thu,  2 Jul 2026 16:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010298;
	bh=CFztPrkjnKh1EsOS6/PUpAhxmxyaVqZmQsXrMRbcRe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycxp+azUbOK1PCHdN7yLruu84RWWzFzXsrBIv7Gc6MvUw+HBONcbt+gTnufFTCUAm
	 u7uJm08JVM2yXWuyALPCeRiUvE2hF3QnmWDl6wUzT6uulK7KjUvKyDku+ndfAjbi3A
	 YNUw7tFIeysUcXMQGHD7vgkG3ALP90mYQKj+ZDzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Elizaveta Tereshkina <etereshkina@astralinux.ru>
Subject: [PATCH 6.12 019/204] iio: light: bh1780: fix PM runtime leak on error path
Date: Thu,  2 Jul 2026 18:17:56 +0200
Message-ID: <20260702155119.069507057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit dd72e6c3cdea05cad24e99710939086f7a113fb5 upstream.

Move pm_runtime_put_autosuspend() before the error check to ensure
the PM runtime reference count is always decremented after
pm_runtime_get_sync(), regardless of whether the read operation
succeeds or fails.

Fixes: 1f0477f18306 ("iio: light: new driver for the ROHM BH1780")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ moved both pm_runtime_mark_last_busy() and pm_runtime_put_autosuspend() before the error check instead of just pm_runtime_put_autosuspend() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Elizaveta Tereshkina <etereshkina@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/bh1780.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/bh1780.c b/drivers/iio/light/bh1780.c
index 475f44954f6110..f478f12640d536 100644
--- a/drivers/iio/light/bh1780.c
+++ b/drivers/iio/light/bh1780.c
@@ -109,10 +109,10 @@ static int bh1780_read_raw(struct iio_dev *indio_dev,
 		case IIO_LIGHT:
 			pm_runtime_get_sync(&bh1780->client->dev);
 			value = bh1780_read_word(bh1780, BH1780_REG_DLOW);
-			if (value < 0)
-				return value;
 			pm_runtime_mark_last_busy(&bh1780->client->dev);
 			pm_runtime_put_autosuspend(&bh1780->client->dev);
+			if (value < 0)
+				return value;
 			*val = value;
 
 			return IIO_VAL_INT;
-- 
2.53.0



