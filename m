Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EA91DA0E1;
	Mon, 23 Mar 2026 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282980; cv=none; b=skRCeJKTcS3Ii/G8F1hVvolDgbDn/R7rvhD5uqAr9dpYEYMQidhHKw2Pkmx41cv6q9iuBScJaXoiB0uhoqwcgOU1IUbWIeBz37IPN9pDga1gaxPBq9nz0un3+pGZcz4ggOlvNRj59UmCcCFQGHYdd4zq0WTvR1i8GDGbLwRxU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282980; c=relaxed/simple;
	bh=0BJPYY+aAfmlJiDV+oA8NQ1thgdYrIhJzlCIshiGZfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uctbUi+DHKpzvKfqgHNxdhYNvOdmjwd00zkjD6BPzW5x5zbRYb6wzO/AuJtpjr0XEXIOBoX++QLdmP17w2NjbNg5SUnHAjzxD9E2mJBIFJ+LuVXDP/Ma6gh7y/YuhiOH3b7Mn41wFbVz1ghVpQgG7yOh6SsSRhzaPI0PepXPXz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zv4jgMKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zv4jgMKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B778FC4CEF7;
	Mon, 23 Mar 2026 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282980;
	bh=0BJPYY+aAfmlJiDV+oA8NQ1thgdYrIhJzlCIshiGZfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zv4jgMKX7oiTeTIv7uiwob36TuE/1QT74trOBmujnditfEC3AVigeTs37lSxZ1FGr
	 54nAIa7ujRd3pl7mkRjsmJNAaWzgzKs7Q6E1fbri7Hdhjh+DiUlo9ExOtIieOeGo6H
	 NiWwveqdnx7g9KZk24XoodrYytnPePe9uS+JHMCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 356/481] iio: light: bh1780: fix PM runtime leak on error path
Date: Mon, 23 Mar 2026 14:45:38 +0100
Message-ID: <20260323134533.783708870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit dd72e6c3cdea05cad24e99710939086f7a113fb5 ]

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
---
 drivers/iio/light/bh1780.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/bh1780.c
+++ b/drivers/iio/light/bh1780.c
@@ -109,10 +109,10 @@ static int bh1780_read_raw(struct iio_de
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


