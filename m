Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859464BC010;
	Sat, 28 Feb 2026 17:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301343; cv=none; b=jwiU3QqrYQtjf08qitQACB32OYKzqoA8JmIofVxLfZ9FkjpI3hqHG/BySAMK37DGld0GANvS3EPz4QyxW8Yso3PKnFmE/uyGvOyRIs0kf82/sXwjW3P/+zx9JfFbg7uqQdBJF2x1KU7eTEhHrrPe4Vz89cWjXvMm8G9nxDSITJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301343; c=relaxed/simple;
	bh=C61+88oPQ2DdJ12m9Oocrh9SBD0mftXNOwo8mXk41Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc08VbgXIaRFTo3ftBi9efVEVEpY1jDH27Y1GaEqeOY7O7Rw8kuiS79IwYguWbyK3dWScIVMIplL2IQa0J19ulHpJ1aE8kMceukXyaE4Js23lmEMF7+J/o483N7sHESkYiJhER6jNuT4UVGYnwIiPxq6Ua0CknsgYv4TSroLV2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jK3D1puT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jK3D1puT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE535C19423;
	Sat, 28 Feb 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301343;
	bh=C61+88oPQ2DdJ12m9Oocrh9SBD0mftXNOwo8mXk41Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jK3D1puT7HB3YBZj6zK5ZpDO/emn5136lxE/C0234vcicjl/NdfKsdQDJ/ihnMZLu
	 LJhBEoYx3WD6eDTG/PNFMpz92ccQX5svL4BJYvthDaM2RCcMzcgUHJgQGDHxemaCs2
	 O+XZRx7OL/bHuPe81sEQ7pdLNvb0hrCZTk0Dx+vbEZo3o+EjN3kD+TOyplVabwa22W
	 DlFfndHaegeSOx4A4qpj3ELHWwS0DCwjH8FM7+VOW6W/UNzfzeqU7c4tyx8+MT0tCV
	 8t+C3k2rF4sSBZR9NZBy9yaZulj+OMiyFzv7sl/7QXOplqX7E8jNJbBlvp7TkelcEW
	 7MyA0VNSy+lOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Xiaolei Wang <xiaolei.wang@windriver.com>,
	stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 530/752] media: i2c: ov5647: use our own mutex for the ctrl lock
Date: Sat, 28 Feb 2026 12:44:01 -0500
Message-ID: <20260228174750.1542406-530-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 973e42fd5d2b397bff34f0c249014902dbf65912 ]

__v4l2_ctrl_handler_setup() and __v4l2_ctrl_modify_range() contains an
assertion to verify that the v4l2_ctrl_handler::lock is held, as it should
only be called when the lock has already been acquired. Therefore use our
own mutex for the ctrl lock, otherwise a warning will be reported.

Fixes: 4974c2f19fd8 ("media: ov5647: Support gain, exposure and AWB controls")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
[Sakari Ailus: Fix a minor conflict.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index bf5b0bd8d6acb..5fb10e02ba6e2 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1291,6 +1291,8 @@ static int ov5647_init_controls(struct ov5647 *sensor)
 
 	v4l2_ctrl_handler_init(&sensor->ctrls, 9);
 
+	sensor->ctrls.lock = &sensor->lock;
+
 	v4l2_ctrl_new_std(&sensor->ctrls, &ov5647_ctrl_ops,
 			  V4L2_CID_AUTOGAIN, 0, 1, 1, 0);
 
-- 
2.51.0

