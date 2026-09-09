Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8357267B;
	Wed,  9 Sep 2026 14:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963821; cv=none; b=XL8zKxOXJILsi2fVlRuf13Do+xUjUK3B04U4oP4HPWMpU8k3+HXG2zdhIa3sinLqrHNH8DJ3Vy9ROI2Cgob1v0Wep8ZQ0L6q/HHrmuV/aNqa/4rY9iOc3jRxe7ME5VtPJ7u8NrUt9VOsQKDX6hJukCr+64RhCNo4tPkZNN7uiNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963821; c=relaxed/simple;
	bh=VEPSCHIyV2Hjp9csgbn/7Ky9HHkkWPeTiXby6p1YHNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JENTi8Cf2N6sQsNhpQ4ENRsRxsnCWm3larN6zWW/d2h0RWptBt1K+Bq8/MCXUBYxAAR8aglBKct67qpQa4ZH7a5Y1omgDbe+2WqJufMeiPMLV3z6rjETADqLYSsW864PBTLbNms1y9xsqpNyAThVqq9jwqYpW1jGDh3/X0jKHwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeYBwOS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeYBwOS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FB31F00A3A;
	Wed,  9 Sep 2026 14:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963819;
	bh=E7hRclW+qRhVdEbntgqsT1XZ6c/3tClWkR4nITeGfLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeYBwOS8voQxbNQziY33xpN4l4L8HsKMwME7VIvBzeNf69Wyd2s1KP2EUq4pxf7Nc
	 CUXZO3G6A3k+eDVv4kTvYuZRLyQyfBiIDHNvGU+LALr8Dtwsz0eo6aEABdB44y8Aql
	 C5aGqe2CwGlAf7UtDlm9IRprH4F42WykFRFArP8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 209/583] iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable
Date: Wed,  9 Sep 2026 15:38:14 +0200
Message-ID: <20260909134245.385966371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit bcd3f72e26314edfce7eaf8d7160b3119c7b7fed upstream.

atlas_buffer_postenable() acquires a runtime PM reference with
pm_runtime_resume_and_get() but returns the result of
atlas_set_interrupt() directly. If atlas_set_interrupt() fails,
the runtime PM reference is leaked and the device can never
autosuspend.

Add pm_runtime_put_autosuspend() on the error path to balance
the reference.

Fixes: 0e4f336f50de ("iio: chemical: atlas-sensor: Balance runtime pm + pm_runtime_resume_and_get()")
Cc: stable@vger.kernel.org
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-sensor.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/chemical/atlas-sensor.c
+++ b/drivers/iio/chemical/atlas-sensor.c
@@ -413,7 +413,11 @@ static int atlas_buffer_postenable(struc
 	if (ret)
 		return ret;
 
-	return atlas_set_interrupt(data, true);
+	ret = atlas_set_interrupt(data, true);
+	if (ret)
+		pm_runtime_put_autosuspend(&data->client->dev);
+
+	return ret;
 }
 
 static int atlas_buffer_predisable(struct iio_dev *indio_dev)


