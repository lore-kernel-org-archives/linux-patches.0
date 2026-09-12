Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E55D309EE2;
	Sat, 12 Sep 2026 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243249; cv=none; b=EBZwNP45k8/Ivt1Qm8uFFdVsk6w5D1UCZuBrRozGGQ6af87cmyVAp+lfcJr9Uth5duq0e3NUcJhIpDEe6K9zsk8DK/dZTR82/Iqey9TkV0lnN1gOQ4itjUoXecbiknc8B/KXY7/wddHxCaFrOq4htKD2gp6e2jDEFotrgu3EriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243249; c=relaxed/simple;
	bh=SwZ5VmP4XQu/ueEn4xp0STSYfleDiEjsUQ+eDH4jJdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl8/TUADDlkwWJpChondE2/Z+FzvhRXqEc22UWF7kmEzukKJhdxdPK/539wrRSW5mqrlnOyNhxJbkdBqwqENK49ek/8fQndlbqg50qSMd3zPbtfamDsUfCxsPe7kCUOqZddQ3kVud7ETpSolBu6EznL3XTYCbZ0lZhLBrXZJh/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8WLJ7aT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8WLJ7aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E906D1F000FF;
	Sat, 12 Sep 2026 20:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243248;
	bh=eF8VI+BzC9K0rKG+uw8mNcKQZcgmkXCPE/Pv469Cgeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8WLJ7aT64wGzYwi6OyMhu33KdC8cW2JTxWPBd1ShhDK8d+vzCMfExePQ+ljByTFT
	 9WkkDrB27RakcihTN6wvjCJjWmtykvD3NU7rLCUqjSJ4/W1Hj9wYzBFv+QFOo71FR1
	 DY1XDKIcLFsoLmFXxDbB+T0j1+FDTziqM/LnHYgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 652/798] iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes
Date: Sat, 12 Sep 2026 09:04:40 +0200
Message-ID: <20260912065532.055887380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7725d0ef8a721..3d1ab38799c43 100644
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



