Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03E7364059;
	Sat, 12 Sep 2026 08:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201582; cv=none; b=CJZMKMtfnzmH+9ydLuoCe/CdJnFmVaWXTEKv5Ed0RuVSRAGbII95prkr0ctnOJ+75J3bmmm8tMPvIlTRtUAKWcHAAHMOzY9NXWMWI1tboNFgi9XzuPAHKe+c9oYynz+0QCxtLr80XRNU/knT3UW1J6C6yZ0FGN/QOZLKQmnexnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201582; c=relaxed/simple;
	bh=3Cci2nBtMz0UOdgDOn1KB+h+hwyOPno4uQM/Rr5SdnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck+fW9ZWkYg6/slMQ5+erGNlq+0TBOuvqdZ8eytsrkeBkTMfJD/u8cn7wOiqXObCC0VcK4b08f1t5ZuzX0ZnB1PFZ/5CPGNeBiE8xAAbdHr2q7xY1uEqn4/u/kGy9FeS9y6j4p/yZFJb2Y73e5dhoExSA6yKwRaKd2dhEjvpUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHB+kBTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHB+kBTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B585D1F000FF;
	Sat, 12 Sep 2026 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201581;
	bh=2ju474I1yp8F6+PHiUcCsLBJhu+4KoetvzJ8vOCJ4Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHB+kBTjUDWScd76p6lXaJUMb4UO8G+Fco9bUdQYYmj2nwjOmG56RAN3aGoI9hXVc
	 aRKVyEqnd9nie2+86ZOxFF2T0MMxfDbBsILLVRB4XaL8WjVnYuGlOpsv4ONI2fWU4f
	 jumn20C4jGDHBTY8amj/YSNR9Y62CG9g8IhltARE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1025/1815] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:46:15 +0200
Message-ID: <20260912065713.081445733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a0dd122af2cfb..3b2c74d80e25c 100644
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



