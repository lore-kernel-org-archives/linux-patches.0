Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C725293F4;
	Thu, 17 Sep 2026 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661177; cv=none; b=XNS6XqAUFlio6Kt02Z+RtDe62sHApIWvExJ3TeGjqVzva0UgQpuMr0g5bkL1rUR4rOzyMwRoHHQQtQvQ5RK7av9VaJkfUEJWGDaLiiDbJ/ZGBqmx1pZ63r2G9x4F5JrIVrhbp/uyxm2o5R0mNSBbomYqlRGys2NBOnyrH+dYTA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661177; c=relaxed/simple;
	bh=eVZv99EnOkL7Pn9jatgZna6AdNi2nlTc2ciFH7CWeFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laIJHyDMydDTLbPE8Ufl41Ol/QV81RccOHmXNnxSk9cAL+8Z49HcgKwPFsYEw7JQlXdPKwdwTcjlCCYXkRSz62i6YE5BrAC7dKcJYb4qO06cZDojL10pP/eRZK4chn5obgUwGIUfbgPBvptw1r2B54ZmcSKnVo9/cBDq7Vhkt0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzRvl1NU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzRvl1NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89141F000FF;
	Thu, 17 Sep 2026 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661176;
	bh=IcLQjBOfVRlf8j2KU2kpvtrN8pvEuaNPCBcVwHEQUXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzRvl1NUVVPq65GrZztvGUSqSM2JFbrBacatQZ8T8YXxEPjQFFrCJOoeXL4x8VCkG
	 PKXQ0wEExFJeAJoaVUeioZr3egvNAjIiD2N9aOQ/MlIOpW48VeqR8sfHiRpw5tr+yV
	 PRcwAEkJYrQ6/F6QyFqUjCD2LN+z7kkKq79lftns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0107/1250] media: video-i2c: use vb2_video_unregister_device on driver removal
Date: Thu, 17 Sep 2026 15:58:22 +0100
Message-ID: <20260917151554.900224300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8909b5173eb42..20889f94610cb 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -892,7 +892,7 @@ static void video_i2c_remove(struct i2c_client *client)
 	if (data->chip->set_power)
 		data->chip->set_power(data, false);
 
-	video_unregister_device(&data->vdev);
+	vb2_video_unregister_device(&data->vdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



