Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4997730DED1;
	Sat, 12 Sep 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221630; cv=none; b=GesBCjgUqBzdS8c+5Xz4CX+s+Azp6E7NwTAPB3lYXh/c7qMZH3LXX0PGUSIW2rU+tWx7s2Han+uLTLpedN0WGLcOHj4tKbFP7dWeO5E0xORj9jErD318KFms5niWVYJms9ZTvMKGmYxQjcLA6y33KOi4JbjA3TYfJNycc19KMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221630; c=relaxed/simple;
	bh=m7w3FIDfPdFlSXj8A9OyNtW9E1R1zNZBlixgPIAS/3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU5UOLk6cOjJhFuQQhrcPsXbT8SEIfo6EHkFafwcnAsHAODUg4eA7m4/Is5umBqZghpmjqgAEvxFpBEUIisfJBO7jKDtuZYr+JGKU7ZLx/h00ChhQ34mIB7glL+y2c+2bP9/CLc3vucMoffJe+aa78z35xMw8sj7/yozqtEP7Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCzlyA1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCzlyA1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679951F000FF;
	Sat, 12 Sep 2026 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221629;
	bh=u94DRgLaAz5O8C6KwpJBBOHqsbpkYN3z1LdsqS+dkyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCzlyA1HwSI1yrRuU/D5UfA+O20O1ctfaXws2aawyJi8c3p30zStOawmFa54M08my
	 CufuPvQ9ebHEcEDw7cXNtTjajxxF8Mh5cTESaD2gVsTwpX2O1SXABvx8xmV/Xf06ig
	 LcIjxfClEiQk6O/2YPmSY975RpkxCGnAMDzK+mBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jonathan.cameron@oss.qualcomm.com,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH 6.6 0421/1424] iio: pressure: mpl115: Fix runtime PM cleanup
Date: Sat, 12 Sep 2026 08:47:33 +0200
Message-ID: <20260912065616.710701527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit 0b5e142ced4bcf20532da051934bd694d1bbd470 upstream.

mpl115_probe() enables runtime PM when a shutdown GPIO is present and
then returns the result of devm_iio_device_register(). If registration
fails, runtime PM remains enabled and autosuspend remains selected.

The same unmanaged runtime PM state is also left behind on driver
unbind, as the IIO device registration is managed but the runtime PM
setup is not.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically on
probe failure and driver unbind, and check pm_runtime_set_active() so
setup errors are reported.

Set the autosuspend parameters before enabling runtime PM. Once probe
has completed, the driver core queues an idle request for the device, so
an explicit pm_runtime_get_noresume()/pm_runtime_put() pair is not
needed to start autosuspend.

Fixes: 0c3a333524a3 ("iio: pressure: mpl115: Implementing low power mode by shutdown gpio")
Cc: stable@vger.kernel.org
Suggested-by: jonathan.cameron@oss.qualcomm.com
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/mpl115.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/iio/pressure/mpl115.c
+++ b/drivers/iio/pressure/mpl115.c
@@ -205,9 +205,9 @@ int mpl115_probe(struct device *dev, con
 
 	if (data->shutdown) {
 		/* Enable runtime PM */
-		pm_runtime_get_noresume(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
+		ret = pm_runtime_set_active(dev);
+		if (ret)
+			return ret;
 
 		/*
 		 * As the device takes 3 ms to come up with a fresh
@@ -217,7 +217,10 @@ int mpl115_probe(struct device *dev, con
 		 */
 		pm_runtime_set_autosuspend_delay(dev, 2000);
 		pm_runtime_use_autosuspend(dev);
-		pm_runtime_put(dev);
+
+		ret = devm_pm_runtime_enable(dev);
+		if (ret)
+			return ret;
 
 		dev_dbg(dev, "low-power mode enabled");
 	} else


