Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0523AFAEA;
	Sat, 12 Sep 2026 19:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239885; cv=none; b=rms4jRXpMaukPmbkgqly1SRTTssMtStyTXms9xAbr/iTBloD5VrahgGHU7+ztX83t5j440D5TXpq0HxnEiHFsALQ595LB1SBwLCkO4mPRQgTwwIZVphFhP3Z//KDt1FDiUOetoM3yJ/9bT4WhAyVKKzgi9Be4Bx4EPuyJlfEXv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239885; c=relaxed/simple;
	bh=qdHma/xd9l9y5ds4aA8mPOywK1U4jhHu033FU+MZ/J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGuHClh955TaUP6ykPcu2q3jmXCTaP+IBE105DqsN8LJ6X5Y8f8oIBa/K/r5f1wtytT7iHhwEIb3AwSnyfaboKwPN9KwPb1VJ8zniqQ5WyBvzPJcoEc1kCpFqop/t1Vf/4JWMO5UUi4MIf8dDG5bVES9DMSLW7U5nrGPyVTjRN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PT4UcjAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PT4UcjAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D891F000FF;
	Sat, 12 Sep 2026 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239882;
	bh=0r3CcjUkvCce/W9lLIPvAf19ox+hTA++yOLbXGCzUsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PT4UcjAV57nLLihoquUAry0m0WKbH6K5/RrmK5lUFbDQDc+uOAmNzi/Scm3ZzRsmf
	 OTY6Ukzv08Cj5pXlCe7qiVVnuBeWKa3GBSOohD+R7hhkx495uRdpqRomHCwjZi1m6y
	 ioQ4EA+MDHUH6LD/zSxzmA8ipuI+Vv3VTtzYaJQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 754/935] iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes
Date: Sat, 12 Sep 2026 09:03:04 +0200
Message-ID: <20260912065544.126780238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 46a5367f7ce9e..430edce1057e2 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -343,6 +343,10 @@ static int gp2ap002_write_event_config(struct iio_dev *indio_dev,
 				       int state)
 {
 	struct gp2ap002 *gp2ap002 = iio_priv(indio_dev);
+	int ret;
+
+	if (state == gp2ap002->enabled)
+		return 0;
 
 	if (state) {
 		/*
@@ -350,14 +354,17 @@ static int gp2ap002_write_event_config(struct iio_dev *indio_dev,
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
 		pm_runtime_mark_last_busy(gp2ap002->dev);
 		pm_runtime_put_autosuspend(gp2ap002->dev);
-		gp2ap002->enabled = false;
 	}
 
+	gp2ap002->enabled = state;
+
 	return 0;
 }
 
-- 
2.53.0



