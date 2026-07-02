Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26ECA33F583;
	Thu,  2 Jul 2026 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009588; cv=none; b=B29Dl3fHIcKl7qeHR4tcFWOOZo3ve9z2mwRdta7tKZ8iS4xpZbRiPQix4AS59t5sfqefmvTdY5RkKUyvoa2oflcHuIPfib18KbyCJD4eH70QuC93Ztz6ZNObQg+5/6uldgJjIZ8Fwg8tcO7W9/udpK3+LlvXaumEzDtxjbVdfVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009588; c=relaxed/simple;
	bh=n6zQEogycyk/IxqIANvq14BSpnicqj0IMQexe7poRRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZVRePfDpi00zbnO9BDAL3vkxCBAp9xtS9OYiXkc/f2B5Fn8zfBLKO5c3CehJ7aLaKZyFQ+1yxGQ8rpjKPY6HTt/Axv4R7+ruBm12joy5P4YKMdOqkNaDxhKYUA5iKFZMoBe/Rixz6kjo+gAsjdZHWUAlKjk9DgUkwvniUy9Lk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIvJprRS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIvJprRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA911F000E9;
	Thu,  2 Jul 2026 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009586;
	bh=RWdoM3vgQY8qzs3k+5y1N9nw02/J+YhZxpfZT45RyVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIvJprRS85sZwOOc6o/7NylX0Ztu1kM5Ron6l2QDDcbQ/k52xeneVg4UkpK4nccAc
	 nZEDEfdBCCn1A/OKD98DF42i4nVzDjmOROUajZolAQwIObKs2+w+xrLFrdfqD8rgEA
	 LJYWiioC7u2ScGOaV0V2tkmCXaRy8jGBKwHjFhi8=
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
Subject: [PATCH 5.15 12/95] iio: light: bh1780: fix PM runtime leak on error path
Date: Thu,  2 Jul 2026 18:19:15 +0200
Message-ID: <20260702155109.464736317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abbf2e662e7dbc..e0a72ff2ebf8b1 100644
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



