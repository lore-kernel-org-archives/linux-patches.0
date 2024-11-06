Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8BF1DED49;
	Wed,  6 Nov 2024 12:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895629; cv=none; b=lSPks8l1C6iw/p/8U6MSnUVoXHLXDjpcqvua7QCPo/85qCWz0lD5eStIpcXqGI1Yzzf1KOQYkaeuUYK+7fc+oDklCdhxDodYpuPfDiuuqJzeFYhZK2NSxKMs3g3EeU9bw9wwS3NGPGzvl/HmMIY1z7NuvL6dCmG+gvbHfCb6ZMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895629; c=relaxed/simple;
	bh=ONPSKili+C1gZk4r5L3j0SNOLqvUBekc+8fL0PWEYV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnhjqQQOyrxIBImax36X7fh+ihL08BPw7T+hm3cV8icNkOK4Q+W0Rp1h3d0HqEiP0ZOMAbeQ+rZMQXILyjPlF1hKY+6U+ul4zEYl2W6ihttL1xF3bgyUDmW6kDFe5OkT9K5gJPcEugmj1P8m2xGcz61vGqZvRCZiyV6GoPHFPOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpbhckhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpbhckhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4610FC4CECD;
	Wed,  6 Nov 2024 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895629;
	bh=ONPSKili+C1gZk4r5L3j0SNOLqvUBekc+8fL0PWEYV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpbhckhIhyj9jEoB7JeyYDJyu1Qgu3RiO7QerbYH5vI9GGbpOIrP/+SFVDZJTvLmk
	 xjosQA172c6K1iudn5iyPpZpYs5eDb7p7h3iBXbyvW01VjpGBdZeLVzsSE4oAuiNax
	 K4KUDqvDgJexBb+p0CIzh5aiQN5/EyDqV/kJc8Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 281/350] iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()
Date: Wed,  6 Nov 2024 13:03:29 +0100
Message-ID: <20241106120327.798126873@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -46,7 +46,7 @@ static ssize_t _hid_sensor_set_report_la
 	latency = integer * 1000 + fract / 1000;
 	ret = hid_sensor_set_report_latency(attrb, latency);
 	if (ret < 0)
-		return len;
+		return ret;
 
 	attrb->latency_ms = hid_sensor_get_report_latency(attrb);
 


