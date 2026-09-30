Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E15F405C3F;
	Wed, 30 Sep 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796846; cv=none; b=JQIIlEzAJi67cs4CyaW9uanJyTjNki0Y0DcWZ2oLahHKJHnunKCUxxXFUqmSoGxwpK1EvCZ6rJNO9iz6Ir5vR41c1bV5cCAolXoCas7PTVCc7K11kDLaXpUdS314ojOufFbQt77kidnPJ0v5X4CIqwowjcW9+0a2kWxWVVSLXeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796846; c=relaxed/simple;
	bh=fU/yUvDQG9DEh7HtnDiobi7LD/gvc4iWq4zKFGOCUhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkamOpjeW6NyUXBJ9YsaowqEnotEQtaEWK3j6DNrPtJ1YpiULgy2ebgKU+irGJUajHeSpEfU+yundV4+FZIIiabi0jaxfvNhnEWarfc9ObQaeaIp6QMTy2/MWatL+piYf/FnC9lHjsnvGNM8h0puIDqe2cYqW3OxWU/W68FYbSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7tS0O9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7tS0O9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93111F000FF;
	Wed, 30 Sep 2026 19:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796845;
	bh=t9RnVqyYZ2bbljFcCCdg0sxftZRSusU9iajaRGfNGBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7tS0O9EPgEXbdX3c6sQvJASfzh5Kk+aILXA8Rrym0eT4tXlIKHvzcaBo6OpsZS8n
	 iVeQUwHlQ4FB5jAOHgQx417HmljYPltqF89d85Fvd3bcj6htG7k8osPNsByh87+Dpw
	 U7Q9lIZYGDoU3PwF23ICkrwx8W5xiMHiSz8/NvDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1058/1193] driver core: Make dev_err_probe() silent for -ENOMEM
Date: Wed, 30 Sep 2026 17:29:02 +0200
Message-ID: <20260930152457.732962246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 2f3cfd2f4b7cf3026fe6b9b2a5320cc18f4c184e ]

For an out-of-memory error there should be no additional output. Adapt
dev_err_probe() to not emit the error message when err is -ENOMEM.
This simplifies handling errors that might among others be -ENOMEM.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/3d1e308d45cddf67749522ca42d83f5b4f0b9634.1718311756.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4eb3f195ef08 ("tg3: use random MAC address when tg3_get_device_address fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8e17aeabd6e80..c00e48c68a801 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -5149,11 +5149,22 @@ int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	if (err != -EPROBE_DEFER) {
-		dev_err(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
-	} else {
+	switch (err) {
+	case -EPROBE_DEFER:
 		device_set_deferred_probe_reason(dev, &vaf);
 		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
+		break;
+
+	case -ENOMEM:
+		/*
+		 * We don't print anything on -ENOMEM, there is already enough
+		 * output.
+		 */
+		break;
+
+	default:
+		dev_err(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
+		break;
 	}
 
 	va_end(args);
-- 
2.53.0



