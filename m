Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95CA1F8907;
	Tue,  3 Dec 2024 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240395; cv=none; b=opMTmMtLMgXETvfK+u+vd4MX1LMKFfMpIMoij5pyz7LYJiLJXb37VhJ6lPaH+O2tn8FOqkDl7QUpcKvkUznGjYAmrbfqmc1cmjEPqisoO3ZwvUWo5f5amq1HV4Ca2vNUKSxEBGdLJg8mqczcSEdk+lGL/9oxne7IienxPj2itT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240395; c=relaxed/simple;
	bh=lEy/bsCUsjWOFm+GLefXxzxfuwAMYnkYMhAsvoSHhAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fizBNVYRFuB1+KadIPVqwsVinJ6hSwHGpDDlLAVwWu+CE2X6yTbJtZiGK7WHi+qhRlYLsHWS9KKy3TmYtS/P9L4s7Kc4rgbeFgPp9Ff3WPnKB0AEMsC4d450+YYSyvTpxC5EzxF5OOfdAL7sHt66jMcyqplrbnkroxW0y261iaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Isn+SKdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Isn+SKdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6005EC4CECF;
	Tue,  3 Dec 2024 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240394;
	bh=lEy/bsCUsjWOFm+GLefXxzxfuwAMYnkYMhAsvoSHhAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Isn+SKdgu5xfCXt4MycN79r9ScuUwMtMSgRwAHK3UXAU5efZ+om6nqY7z1viLxPpr
	 J/G1/A1Qd6/Aik5cKdu7nZ1km5WYCI+hA9fJoGJ/6h1fzDT0uEyJT4yggfDX7eITz6
	 htVCVMA/C10VKrYq3cu6p0dBqZ8Fq7iKpYKNOdkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Julien Massot <julien.massot@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/826] media: i2c: max96717: clean up on error in max96717_subdev_init()
Date: Tue,  3 Dec 2024 15:37:30 +0100
Message-ID: <20241203144748.541484485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d56786977ba11ed15b066495c1363889bcb1c3bb ]

Call v4l2_ctrl_handler_free() to clean up from v4l2_ctrl_handler_init().

Fixes: 19b5e5511ca4 ("media: i2c: max96717: add test pattern ctrl")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Julien Massot <julien.massot@collabora.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max96717.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/max96717.c b/drivers/media/i2c/max96717.c
index 4e85b8eb1e776..9259d58ba734e 100644
--- a/drivers/media/i2c/max96717.c
+++ b/drivers/media/i2c/max96717.c
@@ -697,8 +697,10 @@ static int max96717_subdev_init(struct max96717_priv *priv)
 	priv->pads[MAX96717_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	ret = media_entity_pads_init(&priv->sd.entity, 2, priv->pads);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to init pads\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "Failed to init pads\n");
+		goto err_free_ctrl;
+	}
 
 	ret = v4l2_subdev_init_finalize(&priv->sd);
 	if (ret) {
-- 
2.43.0



