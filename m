Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2037A4D6C3F;
	Wed, 30 Sep 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786530; cv=none; b=Ei2RFcNO4DrWEalATYf1fCOzLSzSXkHUqcsMAbszjTJr3O9Ocl2iXjDkcDWajfhcd5padRaDBvTx/iTh4Tf4vo1jv0Yva4IvB4LXlGxK6Qyti+hY+tex8AaxBpaW56dTtWGatwevKKNuj2JZ8egwq3ltr91Jyhr3wuai0zojrVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786530; c=relaxed/simple;
	bh=6vXTT/MHLiDMELfg+anjvRtHL5t4PlfwGOj7HGznFyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSGUj92y2VH4kx3DsPKxxyEjxvpvO0J9bT+wWW32j0629OZ2uUxdn5jUYYOJkhsW8oEnfZ7FNPkFb07yTC+nPMTOl0f0RUphYT+LKEJ6MLnMaJbXuQr3ydo+lxqxMLQ2mr5J9e1hHjC0x6O9qxdGinefR7XYt0O/x87IRQZ/B7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idJc7bO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idJc7bO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1C31F000FF;
	Wed, 30 Sep 2026 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786529;
	bh=k4hJHlJZOvFpe4y4xN+yOZUp/hL9y0df9MWImO1hfhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idJc7bO1TH7J3nm56bIbQDR2fntnPUvssoXjZV42j9H7l8I0EHA95xfZbycsK/UZO
	 CXrP9//B6u6Cdbu6sSeaFifoaJ4l531VQ/uj3RK4eqdDvANT09Qchbqo6rmTyxUq2H
	 EsFEhYL/vboY68ImaBX4o/lhnRyDps7vc1ZKqsHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 895/982] driver core: Make dev_err_probe() silent for -ENOMEM
Date: Wed, 30 Sep 2026 17:27:11 +0200
Message-ID: <20260930152435.968813171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09114e717800b..fde08c9660a31 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -5060,11 +5060,22 @@ int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
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



