Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60991C5799;
	Sat, 12 Sep 2026 18:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239530; cv=none; b=os0JJ+AKDfG849t5cGXrOqjFNr08B1BNLosIbySTVczyBOyc6q358MBdQUOWGaXlOWVFHAafU/4votdhTANQCbmO/rTB4+S4QKOesaqwivbCsttNvcoKxSdWzQe+rSidGrTYUJYi9rcVCcQdUBx9gYxYuacIyYBKKPwB6oRg35A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239530; c=relaxed/simple;
	bh=HI/nkoIdoQzNYBwac77GoeqxUCZezZ9Xm885BCLUE3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIog55yxtOsfZbCB+nrUlcngCA6mgqVVhk0ll/HUGBk6z17qs0SFXRqR1u5wZqf9BWM2ExKep+6w5JQrF11mNsRUlQLVPm17UqQHAJd+z4M+QqeyAtNhOG4m0ExWuPU0Oz4snn/fkG8DS7/e8nImwDi5xjnniy+RX9XwTJF7eug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKY0Qr+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKY0Qr+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BC61F000FF;
	Sat, 12 Sep 2026 18:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239529;
	bh=DHGSwjj2cTvy1wnP3OUVet/Cyp6UtkyOu+6fGeiOE0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKY0Qr+pNN6GX+JryU8vz15rcx0aFAda3vi6U/ViNPNRPZBwNTvJPnG08RyTSFn3o
	 ioMRy02eOGTBEDjzUJhnEc3Kk8LLFF6WuOfF2SgGndq18v0qs4koEO0O5525mq+GB6
	 76YwLWLDfnMhc3UgH+K4YBRqxVxopfgOWqoK3B64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 684/935] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 09:01:54 +0200
Message-ID: <20260912065542.531099196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index d696d19e2e8e9..40a0b52638c1b 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -800,7 +800,7 @@ static int tsl2583_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static const struct iio_info tsl2583_info = {
-- 
2.53.0



