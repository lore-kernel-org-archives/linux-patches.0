Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03952236EE;
	Tue, 13 Oct 2026 12:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895442; cv=none; b=TWmoEOS+qXr8oxVY1pu+LInsM4wRmy11+0qfa/lsD3gR7gyLgtKZmxnARODB0smXZOHYLct417+zu8NnaaWwwdRsqxmoH+eWbO+2CFPn/VjO1X0CSRkXEWVjfYauYW0jikxTXtV16iPZDLH3VDdQYrMrKUlDV+KR7xSKAFdnXoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895442; c=relaxed/simple;
	bh=/oG33aczs8/doN5IEgYR7qaMLxV9YCto3nrlUai282Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPmmz/G3cujhvkGWCJIDiCbyoqEEpZiVK5a4U/mcTNZN/tpHTAN2A3sQXM9WKpiJgSYBOKeDpiPN5L3N2uVQaGH2Gi/vo0xSkzdofkL5TmaAYZawpSAex5hdCgajhkSE6T1X5Bc3atHD8IfDwu8JhKy+0WrAKR/ww/iwUOJdDP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKU9rO9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKU9rO9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7F71F000FF;
	Tue, 13 Oct 2026 12:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895441;
	bh=nMU+KPKk1l+mAftooNcMPNJ++9bixjaJG1EK6XYICB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKU9rO9OuNFBu88m/pDrroFjTu4uWwFwucW2/fbbL8bAqRxvPltWJGh7FC6yBzPUQ
	 0Y2TUag4nPgzaZpeNH5ByptRdpUJfj2grcmOEEyOtWPxxhSQ/tg0rGz4m4AQYA92fr
	 LjfK5tAeOotMu/StgEedK0q3PnQIvToEmNqnxG84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 232/497] iio: accel: sca3000: fix frequency divider condition check
Date: Tue, 13 Oct 2026 13:36:39 +0200
Message-ID: <20261013112913.405375262@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit d380bf5f94a892e546d9a94e8557ad866b043a2a upstream.

When setting the sampling frequency, the check for `base_freq / 2` is
followed by an independent `if` statement for `base_freq / 4`. If `val`
equals `base_freq / 2`, the second check fails and falls through to the
`else if (val != base_freq)` branch, returning `-EINVAL` erroneously.

Fix this by chaining the checks with `else if`.

Fixes: e0f3fc9b47e6 ("iio: accel: sca3000_core: implemented IIO_CHAN_INFO_SAMP_FREQ")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -652,7 +652,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


