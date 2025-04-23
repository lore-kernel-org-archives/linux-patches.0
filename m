Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659A22957B7;
	Wed, 23 Apr 2025 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421084; cv=none; b=Q5lyTnjOx4haG3mhLwdkTPtsA6jsTP+msumx18ZFDWV9XoxYUqKd+om7HHoiPEnqugf1FL6BV81hOfQOnJhkjZbydyOpAMjC6ekoo9GeD9N3h4zJCbyXsPRVjCw8z133B5HSyjTuyTkbbAT3cBR0DjF89x07Hu1w7z+ROOJRpVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421084; c=relaxed/simple;
	bh=mmHOh+a5p6uu7SCPZCEsOL92khD2sg82IUMj0UWqt1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkP6iVPTbSuqOmny+MAD6Qomk1Lj0DRvEd9RChADZhPKYkVrghepzqWhOoU/UsBIDdv9v5uvR4hJKoaeBlLPDum+Jd52OoM587ZUoC6uyYlrEZyj9/GxT9ksapwO5dOP+OY+Ldcv3yt452St/XaRWnZkl4ITkhxdOe9hA7bKILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb5to3ED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb5to3ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91937C4CEE2;
	Wed, 23 Apr 2025 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421083;
	bh=mmHOh+a5p6uu7SCPZCEsOL92khD2sg82IUMj0UWqt1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb5to3EDTeku9tx9koQigpiz/54ldTvHQNeBxsujhGOFK1+2CHFjxp2VZMVaoG0+8
	 WBNF7clO8bRf7TDZ2x9/T6plp0x9cPIME9eTYNKX+D2xVDL2gnEZWjYPV0vtnF7cON
	 gJZZf6gUdqcKCddA3Qtk4M3SXy28IlU5HCUpefvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 140/393] media: i2c: ccs: Set the devices runtime PM status correctly in remove
Date: Wed, 23 Apr 2025 16:40:36 +0200
Message-ID: <20250423142649.159112962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit e04604583095faf455b3490b004254a225fd60d4 upstream.

Set the device's runtime PM status to suspended in device removal only if
it wasn't suspended already.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3683,9 +3683,10 @@ static void ccs_remove(struct i2c_client
 	v4l2_async_unregister_subdev(subdev);
 
 	pm_runtime_disable(&client->dev);
-	if (!pm_runtime_status_suspended(&client->dev))
+	if (!pm_runtime_status_suspended(&client->dev)) {
 		ccs_power_off(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);


