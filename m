Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB66EED8;
	Sat, 12 Sep 2026 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224629; cv=none; b=sxE8o33icvLUnxR8of52I6uiw/4DQe5VNnX25gRYqjZ7na97Vupj1cvGiR7gN9CnSsOnlDDSFlWH7DcBSUrqcCaTl+wMBJj1mLdnnCtoGkCl1aPZ++cC8MKy16vNcqACH4JJLc4H2LFzwbR8b5oQwSH5F7i7VpTy4gsVZELs1m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224629; c=relaxed/simple;
	bh=8iSmNsb9XBwWMjyTfWCqKXHGfcMK9Paj/whmkuDMYAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUA/KNVx2If8h+wSApAm47kPf05IjZbxl1ykoQCfLZv2EsbN9Ysws/Wu9nwuSaAvXWBLEVThAonNIOpu9PMOq0+P6FgT1S+LvN3Azov4FnW5Yh3ET0Yd9ZNrjueanpikoJTZwRcjBNEEdeZd9zsLAhFD++xI59Wp8VTyC3wK7+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZltL0/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZltL0/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF4F1F000FF;
	Sat, 12 Sep 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224628;
	bh=xFLFJYg8cbfuV0F1OGINB+N8YwjuP+/BlxMzWlXichs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZltL0/NXw/1qiMdNZuITMVLUiqvrglltVZ0HrQ2OGdrhFTkc1YUGOK5J1sFBPpcd
	 4uJ0soHXbgYViknfpAWyJk6f+p/z02FpYIBOZMTz+7HomCzuXXTOQaxvk3XEBfbO3l
	 bwlcOvnhmDQE7Xz2UL+Gp5/B9PzuSldvD1LVw390=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1031/1424] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:57:43 +0200
Message-ID: <20260912065630.401080436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02ad11611b9c5..dfcb8228ada1d 100644
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



