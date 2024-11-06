Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907E21E0DB1;
	Wed,  6 Nov 2024 13:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898831; cv=none; b=b21LiM4rsM86QfKA8LQwRqR0LwFnzBry4YF9vEZLcDRaYqJePu631GdS5cqannS6XZ838Jj3pnScipIkoFOoGDph6bdRGu7d/YTnLDz1EagRGLF0IDOlFuBsMPvUgMm0pRzztEWpRTIqYSSGgBpfM7CLOGGFE1OaxIvYWVUWE1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898831; c=relaxed/simple;
	bh=fX4DqWs7BgLWt83JFt3vTqURaJqYAp9+83IK1D65Lys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV35jexS/rv9/5eWKXQfRI/lTyZvH7ZCkmhpD6gwNkfFt4xUZaHbLo9PFYghRpAWB1xGctxkb0iyJ+jQjhNvpzZ0VxvliKHumwN9EE/QfGZb6aD8f1SQqgXIUzd3hNX5e0X8QhqF5ksTuhoGI7LTVwLogKZ1xijFsVe1FuoEqTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVoGSe6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVoGSe6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDE9C4CECD;
	Wed,  6 Nov 2024 13:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898831;
	bh=fX4DqWs7BgLWt83JFt3vTqURaJqYAp9+83IK1D65Lys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVoGSe6VtKWjSviqznN5xSvZOM7i0gQwXSUkzSiriQlWtXE03pmzGmT1JvUywHFi9
	 qvjvq+L9n6h6Mw+1rg2i+VZDnI7wzFWdksKwk61cZr6ftdipShJDzsTUw92pnSqYG1
	 CEz/cx68MKWy5UrK8r7dlwXSBVjeSIXMQD0pIM7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 370/462] iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()
Date: Wed,  6 Nov 2024 13:04:23 +0100
Message-ID: <20241106120340.665010891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3a29b84cf7fbf912a6ab1b9c886746f02b74ea25 upstream.

If hid_sensor_set_report_latency() fails, the error code should be returned
instead of a value likely to be interpreted as 'success'.

Fixes: 138bc7969c24 ("iio: hid-sensor-hub: Implement batch mode")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/c50640665f091a04086e5092cf50f73f2055107a.1727980825.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
@@ -33,7 +33,7 @@ static ssize_t _hid_sensor_set_report_la
 	latency = integer * 1000 + fract / 1000;
 	ret = hid_sensor_set_report_latency(attrb, latency);
 	if (ret < 0)
-		return len;
+		return ret;
 
 	attrb->latency_ms = hid_sensor_get_report_latency(attrb);
 


