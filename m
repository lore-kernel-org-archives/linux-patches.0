Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E7F390C9F;
	Sat, 12 Sep 2026 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242980; cv=none; b=ipeu7RqpIsPviv0QkPWWagZj6JftRNNf6vnSKzUeINU+/FjDo3q7KzPy5FSQ3FT+9OCbwlVVQ6nl+JsHfPe3Y7oirDH3CfHOK6zgNO7UxZGgcXO1Z9je18RDEZ/NKEDLoO4cGTztdzjoOsnpE7+dPyEYN6aq9QWL4uElOkWD7JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242980; c=relaxed/simple;
	bh=/SIModl9li1N3akfrnNWoO3DDXAOkKMmaULcsCEnGH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHq2qU18xvhqoEfSQEzn7vomW3/XExEts7hfJa0ETf93dIk+7JIzRNbzoZRafeSr3y8CTMEypwL0mdifLPYJrBap9+yLLlZXggPkxggNi8U78YWWYA/4daYg423zieBsvwkH9zzchypYq3o1ERXAuF4Zy9rhmysN/bqLs5mYOg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viEoZgYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viEoZgYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB81F000FF;
	Sat, 12 Sep 2026 19:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242973;
	bh=sYrzRbDoa4y/Q7H4J5BbZu7thToYdEqEMwPUWU5jqVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viEoZgYuPMO09g7grU1fgjVpKO6cO+oJ1h8dSeUoo0lva2kK4I5l+gfHmTaVRHYzx
	 daMXtVAT+jgaVP8fYVlmnw3FplGPwkwyeNUj0wyY8gDQdN+a7owxCaeyIxZLHwuzWU
	 MoOkG2KF6UmdUMsN4eh1L6og0cZnBd3EykSdHp0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 591/798] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 09:03:39 +0200
Message-ID: <20260912065530.670235277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 55b75622829779223b9e32aa9600a8651d3e2df4 ]

isl29028_write_raw() returns the value of pm_runtime_put_autosuspend(),
which is 1 if the device is already runtime suspended.

In that case write() on the sysfs attribute returns 1 instead of the
number of bytes written. Make isl29028_write_raw() always return zero
on success.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index 74e75477660af..15cf67b5e8549 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -416,7 +416,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
-- 
2.53.0



