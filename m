Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4228C42AF9A;
	Sat, 12 Sep 2026 10:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209621; cv=none; b=XSArqAIUlnpJFAqtWhoaIH6U0OTDFXtmx9s6khm44oqCT97+UwonG3yF3qpC5HMjzLyZ9/hdNaU0CE7kgCKxBY0XkHWZXkLH968L9autiAdvpm1eDRbeYOy/37zmmSxWLCR78mLvBq84aA30TxqDj3xCsmfGfucTiMbAfRr31cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209621; c=relaxed/simple;
	bh=xKtnuydI31O5XnmuRpFXeFiwi8tG4V8uHjXXk1igzN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4FcMrLrFzQy+Rk3hsCS/FlTfqn8PcWzV7pmiLYwJg3ObaeifIG1A9Q0zWZl9sYSNwS0SFBS5T1yRh5Oenl060uxiqmCjDhd5nA6rELgEV7R9rcAI+dR6Wa+5oboGbKoILk6hheD0hcKkoFvxcO5jChlYvfWErJbNQq55qT0n4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkTO43/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkTO43/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A0C1F000FF;
	Sat, 12 Sep 2026 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209620;
	bh=ZekOc4g6+WIoxu40pH1VKfNfu8wzk5mbxKOqzaOyNyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkTO43/j5IjJ7zjbDOHqEfrNN8GUkoPPv9hrTjr3wjAKCUkK/2GPZ8SpbGrSY7imo
	 bZCcaUzQdqIeVoiaqEQCLpPsHI/gTJRX0H7zQo4VWmCwqiOSleZAlSeQYyXhzS3olO
	 2bYKOW7vf/jVfHIEQqpTdnOUjxI6B1TWMVQaLgT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0857/1518] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:50:26 +0200
Message-ID: <20260912065642.837339602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 42e8791841e0677418a3ccc97fa5c22a1455f417 ]

tsl2583_write_raw() returns the value of pm_runtime_put_autosuspend(),
which is 1 if the device is already runtime suspended.

In that case write() on the sysfs attribute returns 1 instead of the
number of bytes written. Make tsl2583_write_raw() always return zero
on success.

Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tsl2583.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 8801a491de77b..15693bc3e8e85 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -794,7 +794,7 @@ static int tsl2583_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static const struct iio_info tsl2583_info = {
-- 
2.53.0



