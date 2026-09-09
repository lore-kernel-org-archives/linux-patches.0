Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FD4372EF3;
	Wed,  9 Sep 2026 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962397; cv=none; b=tayan5/+tE9igsAmaJ55mLgpn68IF1Ova13fYNP7EgNmN6OrOwYisSghJRMr+o/oyR4yRf58b1zFJyM2A4I8A9Ii3ijj8eVN2a9M2N55r6J8TJvUh47HHkidUWGYtmuGYdIcaHr/h3ei3FIwrxP5KqK/qK3nAXjoNe84eG3Fg54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962397; c=relaxed/simple;
	bh=/VLyorIfKxY/IlnwaqU+qLZi5GsoNKvP3+KKfMug0sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4/XKZT6e+MOY540drsUWxoAeEaDhhihPKnmG4s8Ed4CyeCkjiKbVQeVsu6iNW2371EXxKvhvl7/PHeWobaviGALN2bhtRs/e0EWohgrnJTvDugB5S/XnwU3/B/b3LTRhK9inun67Iw+7qA2DLb5tC9L6Xz7xt7lPn3AVnb3FqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9uHg5jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9uHg5jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367E21F00A3D;
	Wed,  9 Sep 2026 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962395;
	bh=0Or1i7CZiD/DWY+lqBTEiZmnCeAGZMobP907Tr7aJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9uHg5jg6RiqOgQeBNImsQHuZLk/Vfh5ITk2uNDBevnHIEPB58Hj8oTtYlzWuLvXj
	 66npNR/wK81PkHQeY8LObarWLWDhOYbzR58YvPNvfNR8qFBmlvY2WI/Ynu5g+MXjio
	 /y6U8pW8usCnbOxnQRWj3HpgkEyuNcWldKhPzMa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 276/556] iio: light: apds9306: fix PM reference leak in apds9306_read_data()
Date: Wed,  9 Sep 2026 15:39:16 +0200
Message-ID: <20260909134240.335590330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit d378fceaafd79e0dc59d3546bda251a3058062c0 upstream.

apds9306_read_data() calls pm_runtime_resume_and_get() but several
error paths return directly without calling pm_runtime_put_autosuspend(),
leaking the runtime PM reference and preventing the device from
autosuspending.

Use PM_RUNTIME_ACQUIRE_AUTOSUSPEND() and PM_RUNTIME_ACQUIRE_ERR() to
automatically handle runtime PM reference release on all return paths.

Fixes: 620d1e6c7a3f ("iio: light: Add support for APDS9306 Light Sensor")
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/apds9306.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/iio/light/apds9306.c
+++ b/drivers/iio/light/apds9306.c
@@ -469,9 +469,9 @@ static int apds9306_read_data(struct apd
 	int status = 0;
 	u8 buff[3];
 
-	ret = pm_runtime_resume_and_get(data->dev);
-	if (ret)
-		return ret;
+	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(data->dev, pm);
+	if (PM_RUNTIME_ACQUIRE_ERR(&pm))
+		return PM_RUNTIME_ACQUIRE_ERR(&pm);
 
 	ret = regmap_field_read(rf->intg_time, &intg_time_idx);
 	if (ret)
@@ -535,8 +535,6 @@ static int apds9306_read_data(struct apd
 
 	*val = get_unaligned_le24(&buff);
 
-	pm_runtime_put_autosuspend(data->dev);
-
 	return 0;
 }
 


