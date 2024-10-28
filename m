Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762C15B10D;
	Mon, 28 Oct 2024 06:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097183; cv=none; b=Vo8J6hZAfotImA+seMntpaoCPwHmwupWfRxmP4IDInhsS/Nspu51M+uJXYVio+iJPgi9owYxaI6f4ub9iLeknCHYtERiIyTk/g0fnnsSwwJOrYDq7srFzwEhTGblmqCjDUX6s3g6eXkLWUHJkfNDeKIu96MxRTKZEJksYEfPeVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097183; c=relaxed/simple;
	bh=/MalBJjyUdC7NnfB94fZHQmM9bBJpOA9HGWJiSgaOsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYwYNXr7aof81YJqWUcyzCxxaDWCwla+4LoqommzW+NCW2SjEYPH34zKDP1GDZt+KJ5ltvjxJtQtjpncX5Y76mXzWmUiyUBBfXptxVXteKCBH1X1y71CDKFJ9PAz3jNmbQHfOSTA1xrNc8S5e2aQFgP6v7vUaplD5N3dUi+hCao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MS5oz5BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS5oz5BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169C9C4CEE3;
	Mon, 28 Oct 2024 06:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097183;
	bh=/MalBJjyUdC7NnfB94fZHQmM9bBJpOA9HGWJiSgaOsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MS5oz5BD3EzmRDHta5LCS7TGeH/xB0JlZcUIlFkjjaO11pi2a4iSfxgEO2uutWEe4
	 SxhPCOTRDxlN25GPDjk0DNHG50KiaNOTHJ4FO8uqUTsCYUVdxelh1Jxq1+E+Q3enyq
	 Cb413QYDfulYdPzWY96uDDGV9wY+Mdk0lSZXBLbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/137] iio: accel: bma400: Fix uninitialized variable field_value in tap event handling.
Date: Mon, 28 Oct 2024 07:23:59 +0100
Message-ID: <20241028062258.776726631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit db9795a43dc944f048a37b65e06707f60f713e34 ]

In the current implementation, the local variable field_value is used
without prior initialization, which may lead to reading uninitialized
memory. Specifically, in the macro set_mask_bits, the initial
(potentially uninitialized) value of the buffer is copied into old__,
and a mask is applied to calculate new__. A similar issue was resolved in
commit 6ee2a7058fea ("iio: accel: bma400: Fix smatch warning based on use
of unintialized value.").

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 961db2da159d ("iio: accel: bma400: Add support for single and double tap events")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://patch.msgid.link/20240910083624.27224-1-m.lobanov@rosalinux.ru
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma400_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index 6e4d10a7cd322..4d91747b20270 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -1245,7 +1245,8 @@ static int bma400_activity_event_en(struct bma400_data *data,
 static int bma400_tap_event_en(struct bma400_data *data,
 			       enum iio_event_direction dir, int state)
 {
-	unsigned int mask, field_value;
+	unsigned int mask;
+	unsigned int field_value = 0;
 	int ret;
 
 	/*
-- 
2.43.0



