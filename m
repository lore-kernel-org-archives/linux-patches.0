Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B34D9540;
	Wed, 30 Sep 2026 18:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793976; cv=none; b=t4qV1tRBu+BxRhnGxRft90dI4NicGtD1lOLwIY0ISI18m4CYWDdL9BcXvMldBY/5MHt6ffNfuWrQsHigvl0pJR9B0tMlplLpXRev2sQ7QFvDxDG9pyWaCQ1/PKRgK48Gx55bIbfLVL52Wc4YIX+UWfDupxz0UDSXcHiYzC4+hgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793976; c=relaxed/simple;
	bh=09f07e2fKxu5B0S7EWan8dXPu7//Q7s+5u+wBukG4h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iy4iiFk68Bwg7cSa722kzgtH886GTfMbqtQFF5/5GDnHaKBhQ6CKFN3UoB0+2C6OOklkyd7Fz7x/V92u+7DCfNKLe7eWfCzQBkw03gyeRqgtVYzkyKIpHTCSxiefamgX0l062u7AY3J3Y/HuuaTv+YNDf//gIozqKPScceOALaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5iB2C6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5iB2C6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B361F000FF;
	Wed, 30 Sep 2026 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793975;
	bh=vU+7NPBXW+GcklHdYBk7501DaGjg4F2/FxtroOTssI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5iB2C6zFB0SzGTd/vyA1xKPZROwOlVIzinqb5gUURK4a1eVRwu8GTHLzt3R2nVgt
	 5ls8UpWeUVcT0KlemNXm+5TU3Y/6LM2R123giBR+PH7JYyE9Ozkt4qCkuRTWpoF42L
	 /d0m53Ds5DOpupa6kjjibIQ5qwmvhWYi+AN3CEPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0046/1193] media: video-i2c: use vb2_video_unregister_device on driver removal
Date: Wed, 30 Sep 2026 17:12:10 +0200
Message-ID: <20260930152435.307038549@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit 56384b486b80ce4a2bc93689aae49995f908f90d ]

The driver uses vb2_fop_release() as its file release operation, so
vb2_video_unregister_device() should be used instead of
video_unregister_device() during driver removal.

This ensures that the vb2 queue is properly disconnected before the
video device is unregistered.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 15a7fcf0c3a70..7a975e2eab00b 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -911,7 +911,7 @@ static void video_i2c_remove(struct i2c_client *client)
 	if (data->chip->set_power)
 		data->chip->set_power(data, false);
 
-	video_unregister_device(&data->vdev);
+	vb2_video_unregister_device(&data->vdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



