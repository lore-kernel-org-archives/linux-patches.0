Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6721DDE9;
	Thu, 30 Jan 2025 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246691; cv=none; b=MAVoRTOXo/bpeucJR2svxUrPvqaY0H9qA+cOZ8eeOQl0jG56QgRA0hzkF5RPrrTuasyCPWhDT/j0AJvfUYVckUCWpbIIlNqQQx9R3UmJhUMEFtzXqAKGX2jIHwWg6ahY6FcqvEu41v5u9i+QXl18RBu5W02ri7aq/LjIvmPA0KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246691; c=relaxed/simple;
	bh=yWdKyH0cNQknx3jSzE23xhmKRqbvOdA1u1nTuFBHWjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQxbZuMFk9v/ruV3dBHRWvo5RdFatsaNJATAKd1wsh61EPUAHsqmNrjptycZtqeMdfb+yCQos9HMau61Vy9uezDuzf9LJmfasDr1Z5Q+KM/pzFQ/AmKZgtIYxERZPeiNeUdSUsgakbvbBoxDYRgzywnYamxgesB+PD6ntE/cUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUYPzHuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUYPzHuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60B5C4CED2;
	Thu, 30 Jan 2025 14:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246691;
	bh=yWdKyH0cNQknx3jSzE23xhmKRqbvOdA1u1nTuFBHWjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUYPzHuWs76RS2KoPwnPfH4GCCIEt25uQV0XgtYDi0FdvZPhH7ay92+cDTVME639z
	 a/AdOJbFzXOE7we8Daa2aQNNcQsSlKlMKv4MTli7Dh+qAHOuLchrpfv2RKN7SxXkrB
	 OkcjvW019kQgFuNfs761QlX+B+SzHbyD7+NCn2hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 34/91] iio: gyro: fxas21002c: Fix missing data update in trigger handler
Date: Thu, 30 Jan 2025 15:00:53 +0100
Message-ID: <20250130140135.034225011@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

commit fa13ac6cdf9b6c358e7d77c29fb60145c7a87965 upstream.

The fxas21002c_trigger_handler() may fail to acquire sample data because
the runtime PM enters the autosuspend state and sensor can not return
sample data in standby mode..

Resume the sensor before reading the sample data into the buffer within the
trigger handler. After the data is read, place the sensor back into the
autosuspend state.

Fixes: a0701b6263ae ("iio: gyro: add core driver for fxas21002c")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20241116152945.4006374-1-Frank.Li@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/fxas21002c_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/gyro/fxas21002c_core.c
+++ b/drivers/iio/gyro/fxas21002c_core.c
@@ -664,14 +664,21 @@ static irqreturn_t fxas21002c_trigger_ha
 	int ret;
 
 	mutex_lock(&data->lock);
+	ret = fxas21002c_pm_get(data);
+	if (ret < 0)
+		goto out_unlock;
+
 	ret = regmap_bulk_read(data->regmap, FXAS21002C_REG_OUT_X_MSB,
 			       data->buffer, CHANNEL_SCAN_MAX * sizeof(s16));
 	if (ret < 0)
-		goto out_unlock;
+		goto out_pm_put;
 
 	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
 					   data->timestamp);
 
+out_pm_put:
+	fxas21002c_pm_put(data);
+
 out_unlock:
 	mutex_unlock(&data->lock);
 


