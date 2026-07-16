Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5678742255C;
	Thu, 16 Jul 2026 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210467; cv=none; b=lqnQsyrbhAh+QQ+EZ3c05S1IWZmHTuslacd5VvXqeCuMfy/sTrcygXVOCZkoPzKTuU+wBZJDHAyYw0tEz+xcuRDlXNM3qBxtJPWJkEnxrQDKNZrTScnUiwmAVDhAdKNFjwTlIqU/szrMZaKGKb1MsHS4vThE+xZWdizcIke0Flg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210467; c=relaxed/simple;
	bh=T+Sm98oz0H6+sJhBqAH+42O/N8eiT3VT5ysLG+WRAgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+fR0RnVCQagsN+iaYhiTyPeg6BhZIRuAqFUF2kBuPh9aURWRQ4foknPxWMpok8VlCq4/pkxsD3q4FyrDtc8wEFpMBbZopUyw87dTvHumzfjpKdYg+gE2kQz1sXmtN0d8z5b83WZNgP1gMQFa75o6AOxRLAEE/ul1JMlPss9+fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPyw1Ywc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPyw1Ywc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCA71F000E9;
	Thu, 16 Jul 2026 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210466;
	bh=Dj528zfr3c2Vap8NMEA8VPoKXccp4begtjTm/FRb/Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPyw1YwcAGtedR46woBlJt7vSFi5ZqyV4YKLzB6je3xlwEKbCldS9w5htGkEN+8tV
	 uT1mT3whB+Ice9xjLNHZ/v/75ShB7CZW6uUsX7TWCnzbwOermilo5JKyHZpELor4zS
	 n/8VxgAMxLG4h27PDuJ9NVE/LUfbANpfA619WfzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 059/480] iio: backend: fix uninitialized data in debugfs
Date: Thu, 16 Jul 2026 15:26:46 +0200
Message-ID: <20260716133045.988858941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit a6e8b14a4897d0b6df9744f33d0a30e6b92368eb upstream.

If the *ppos value is non-zero then simple_write_to_buffer() will not
initialize the start of the buf[] buffer.  Non-zero ppos values aren't
going to work at all.  Check for that at the start of the function and
return -ENOSPC.

Fixes: cdf01e0809a4 ("iio: backend: add debugFs interface")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-backend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-backend.c
+++ b/drivers/iio/industrialio-backend.c
@@ -155,7 +155,7 @@ static ssize_t iio_backend_debugfs_write
 	ssize_t rc;
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -ENOSPC;
 
 	rc = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf, count);


