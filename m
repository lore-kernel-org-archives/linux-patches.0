Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0B42BC56;
	Sat, 12 Sep 2026 08:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202716; cv=none; b=f8bLCoy1THCtLnhAG+072rOHy7NAOTSaxKDQoGmIrxT34vHsuKza7MGW45IhBUh85x2A/YXFjpEBvsN34LCPROcLCvNa6w7ybOX/48ZL7rzn/kfHxZ85b3nxhxuaHKEpRH8oI5UOmwd1VSkmXrAkLbiC1iloPb30Y1rTQy0twDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202716; c=relaxed/simple;
	bh=PbYfm1PYt2hgMp1J9Kd3Py7pU+fNZ6KaisqM1dOxF/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8miXygkZ5GIRTdK3tuY/UTJT6JtensKCWwPG+XOaP8Tyy3/45TIiVKh1XVSc2XRf0bgLTJdTeg30tEU+V43VUfF4sBm3KZ/75ua/ZkDvZm8uUnR38pqV7Ch90SMfcUPI+J/v0+XQJQLeT+X0jRF2ESmZIQmsqruoO32vEj1vpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNsDRxct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNsDRxct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A761B1F00893;
	Sat, 12 Sep 2026 08:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202714;
	bh=EhA9V7NBvLtTBdOQJWqByLlIM2SqTA9kIXstjLf8RBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNsDRxctrl4WKHDoX6exjbu9GBUem+dZo1yXCQ5SyHO1vwkFJj4lSRgHE6v3DBWUI
	 HfbmraYszW3bDds4q3B0opZfQWTaImhoJ0eYjudBMcu3k1/DlppX1ecsiUjmt98zIe
	 qpOruCp/1CsTtL3Cs99CAXavwXfPrDilwE5enV78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1260/1815] iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes
Date: Sat, 12 Sep 2026 08:50:10 +0200
Message-ID: <20260912065718.595778237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 579c049b4cb6fc72ce2c505fc5334540be0efcd3 ]

The IIO core does not filter duplicate writes to the event enable
attribute, so writing the same value twice invokes
write_event_config() twice. Enabling twice leaks a runtime PM
reference, preventing the device from ever suspending again;
disabling twice underflows the usage count and triggers a
"Runtime PM usage count underflow" warning.

Bail out early when the requested state matches the current state.
While at it, switch to pm_runtime_resume_and_get() so a failed
resume is propagated to userspace instead of silently marking the
event enabled.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index 05773e24931be..708a770065296 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -342,6 +342,10 @@ static int gp2ap002_write_event_config(struct iio_dev *indio_dev,
 				       bool state)
 {
 	struct gp2ap002 *gp2ap002 = iio_priv(indio_dev);
+	int ret;
+
+	if (state == gp2ap002->enabled)
+		return 0;
 
 	if (state) {
 		/*
@@ -349,13 +353,16 @@ static int gp2ap002_write_event_config(struct iio_dev *indio_dev,
 		 * already) and reintialize the sensor by using runtime_pm
 		 * callbacks.
 		 */
-		pm_runtime_get_sync(gp2ap002->dev);
-		gp2ap002->enabled = true;
+		ret = pm_runtime_resume_and_get(gp2ap002->dev);
+		if (ret)
+			return ret;
+
 	} else {
 		pm_runtime_put_autosuspend(gp2ap002->dev);
-		gp2ap002->enabled = false;
 	}
 
+	gp2ap002->enabled = state;
+
 	return 0;
 }
 
-- 
2.53.0



