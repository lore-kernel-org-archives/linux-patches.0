Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA33A10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B275C433EF;
	Wed,  7 Jun 2023 20:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169561;
	bh=kV3lnCQLNsX1P+lNMdGzqoGUQ+2ziiemz20pKJDmjMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YszjpWuiS5c4JSRcKUmVZadTw8odojrvdYgbemi1s92deK+n88muoo8jE7wQDHjLN
	 bzRq+XVUhtqkOKXaKkUCe1BYmeU2S/ZfNiPmHr9uq/ofEC4T978N25YDv3ww1kCIrG
	 XkDg845Tkq3OC+s+lnyicXs6usryuP4ckBDogRwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 100/286] media: rcar-vin: Fix NV12 size alignment
Date: Wed,  7 Jun 2023 22:13:19 +0200
Message-ID: <20230607200926.326937598@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit cb88d8289fc222bd21b7a7f99b055e7e73e316f4 ]

When doing format validation for NV12 the width and height should be
aligned to 32 pixels.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
index cc6b59e5621ae..23598e22adc72 100644
--- a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
@@ -1320,9 +1320,15 @@ static int rvin_mc_validate_format(struct rvin_dev *vin, struct v4l2_subdev *sd,
 		if (!vin->scaler)
 			return -EPIPE;
 	} else {
-		if (fmt.format.width != vin->format.width ||
-		    fmt.format.height != vin->format.height)
-			return -EPIPE;
+		if (vin->format.pixelformat == V4L2_PIX_FMT_NV12) {
+			if (ALIGN(fmt.format.width, 32) != vin->format.width ||
+			    ALIGN(fmt.format.height, 32) != vin->format.height)
+				return -EPIPE;
+		} else {
+			if (fmt.format.width != vin->format.width ||
+			    fmt.format.height != vin->format.height)
+				return -EPIPE;
+		}
 	}
 
 	if (fmt.format.code != vin->mbus_code)
-- 
2.39.2



