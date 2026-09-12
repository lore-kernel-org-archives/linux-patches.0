Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EE928E0;
	Sat, 12 Sep 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230707; cv=none; b=oEQy94JOw/MTWEXBIEh0PgBWEctlInvMeY0XgNj7JfRMGBzTXWY8IjAvh3uOttGInYYpF44dAzj/JaBRvFWk9Z5uLkuiPBn0MAXvElTKaBBrsmByDJPli0FrU/cgByZgfZ8zlhDBbhvMFkC9c4IYK4i9Do2YsuvJpUzIphfP168=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230707; c=relaxed/simple;
	bh=wZ4IdTKc9/G/szIN2W2ynn1SIBZKnsn4FnZWyPTT4Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STQZTxzQwpLf9uQX5qsipG9TTBjBDK09Y7zHWFYfGvEKmc/g3bCisGbexLx7uKuJlns3Jc7YiYDrWunYuNs1YomIznsaulwQFF9cG0RYgE30UA//1MNL5Pe1gbqBNQ4NriutIM5CTFGOX7IuZQfYGHq6Oc5sEvaRpRNPq6yZC5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtlYBZWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtlYBZWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A171F000FF;
	Sat, 12 Sep 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230705;
	bh=4qshCCsLvnSZCM6VMEUkV5Pl+eRwIbWqvc9FqCqRbIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtlYBZWxoo+znqdiiNTTIyTmY5lCHDlpT1Qun0RJUIOJTM946hueiyJ2vwJLoRLuc
	 V/y8IFsEJItreetVI8uqeZFi67E6pdM7EyNmeyBMxd6xxS7mJT+FJnrHPShzEHWmb3
	 VJ7lwUV8An/0xqmQROdm+t0DAYEM044TsBzATqHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0849/1191] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:59:37 +0200
Message-ID: <20260912065607.325298638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 7bcb5c7189224..688f2ccd06f71 100644
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



