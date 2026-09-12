Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF2274B46;
	Sat, 12 Sep 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225125; cv=none; b=MCE7SymdcJ00BgWX2FOH9AHEMymPoS5SAgH7TU1KrzyCt1gYd5dRt3Kb7ZAwV9Ep9c3+DKhys5NDU/RQOc3HNGDUzqm28HK1D3rkqrmkyurXWk0YfPwthzRET+6dQ6EbyVotE/NrCZ15aJ3LWzlRZKIuX6ONTy0CCSiXi3ADBcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225125; c=relaxed/simple;
	bh=k+j8YKM/9wFCrTYE3SuMygbLq7PlJzGLxk1sSwLiR6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1gp5sm6krb0pBrQgQ2VPnjDGH9nMrRS6nKBt/NZ89V4qAtPv9dvuda14Kzbdvu8rNDMbe5dlPZ9iNWROoBBCcN00gA1bz4+2CEjPDZmM9IPfyaZJipNpvxq6TPZqExMexwHkm/fuJiankfDC5IPJR7t3cONYnhPeZlQvVzO7UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nK2/fA1h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nK2/fA1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244211F000FF;
	Sat, 12 Sep 2026 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225124;
	bh=Z1gAqNktUXmepYFEM60faum65hdGOr3p+scL/qD2El4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK2/fA1hj2oS9qpawbaGr20MW705Yi3asmTZR2H5D0BZzO7EWNC5YWifxS3eVpkRW
	 iiC5NUSiSkuyZoGjHU4D9iTZJrx6yqRd4cgg8HPHcKZmubNpyoiOVcTH6dugqzDvKe
	 KftVofhZdzqO488MpyPNt+acDem0q9zbKIRQDr9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1132/1424] iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065632.650427002@linuxfoundation.org>
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
index 96c9644a85408..13ca9d5acb052 100644
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



