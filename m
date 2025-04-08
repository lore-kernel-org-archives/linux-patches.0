Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF57267F4F;
	Tue,  8 Apr 2025 11:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111620; cv=none; b=P7KvBAPvNCJGdQhi0obKzz7J4LnJGv0cPmfvUCEKHcaxlN5fGZSzdp1C3/i9hXi5+k42GsnoLTE72Z7aDId2M/O/+PGrZ5ISkkcp8kcvXZfp5Vkj2UbanGyJnl1r2rfbKIXAPQZ2/EL7XQt/rSEJPuJVwPrR2191CSR8h/8ssKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111620; c=relaxed/simple;
	bh=JJu4dKFnPaL30mcNKTUOZB62tdwuxZQuY6gccnPyuaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2zKLjmlqJ81ZjZulfZ3VLxZhwe/S/euthTMdCbLjZQgdN79PSu4lWMVwJ7jE6QPcvqj3mHxVmox+4W+SiMia6Sqq/yuiFRGQu/jzSdOKjMlZpTaXPJfnkaTMhqd+svxDXUJ55OVIpkTxo9d/kPUKQFyrZb9J86WcXmwhyKh/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJZLCRjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJZLCRjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98B8C4CEE5;
	Tue,  8 Apr 2025 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111620;
	bh=JJu4dKFnPaL30mcNKTUOZB62tdwuxZQuY6gccnPyuaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJZLCRjAwZR7RZDcSB6Zt4LCoJqw7zbby41PsCR7+xDhFHgBLObv0uNo5jpueIgyF
	 /xU0QZWWaiVIFVd8vBQEja55QYsp0nwMyZXG+14xbuV8ZTUAVSo8MBBfJeOXYBgPwk
	 I+FE8c/oy4RnywqrGXoQbgcRY+72+jCggNCMRi3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karan Sanghavi <karansanghvi98@gmail.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 496/731] iio: light: Add check for array bounds in veml6075_read_int_time_ms
Date: Tue,  8 Apr 2025 12:46:33 +0200
Message-ID: <20250408104925.811988213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karan Sanghavi <karansanghvi98@gmail.com>

[ Upstream commit ee735aa33db16c1fb5ebccbaf84ad38f5583f3cc ]

The array contains only 5 elements, but the index calculated by
veml6075_read_int_time_index can range from 0 to 7,
which could lead to out-of-bounds access. The check prevents this issue.

Coverity Issue
CID 1574309: (#1 of 1): Out-of-bounds read (OVERRUN)
overrun-local: Overrunning array veml6075_it_ms of 5 4-byte
elements at element index 7 (byte offset 31) using
index int_index (which evaluates to 7)

This is hardening against potentially broken hardware. Good to have
but not necessary to backport.

Fixes: 3b82f43238ae ("iio: light: add VEML6075 UVA and UVB light sensor driver")
Signed-off-by: Karan Sanghavi <karansanghvi98@gmail.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/Z7dnrEpKQdRZ2qFU@Emma
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/veml6075.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/veml6075.c b/drivers/iio/light/veml6075.c
index 05d4c0e9015d6..859891e8f1152 100644
--- a/drivers/iio/light/veml6075.c
+++ b/drivers/iio/light/veml6075.c
@@ -195,13 +195,17 @@ static int veml6075_read_uv_direct(struct veml6075_data *data, int chan,
 
 static int veml6075_read_int_time_index(struct veml6075_data *data)
 {
-	int ret, conf;
+	int ret, conf, int_index;
 
 	ret = regmap_read(data->regmap, VEML6075_CMD_CONF, &conf);
 	if (ret < 0)
 		return ret;
 
-	return FIELD_GET(VEML6075_CONF_IT, conf);
+	int_index = FIELD_GET(VEML6075_CONF_IT, conf);
+	if (int_index >= ARRAY_SIZE(veml6075_it_ms))
+		return -EINVAL;
+
+	return int_index;
 }
 
 static int veml6075_read_int_time_ms(struct veml6075_data *data, int *val)
-- 
2.39.5



