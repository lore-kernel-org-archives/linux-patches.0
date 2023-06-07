Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0892310FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F06C433D2;
	Wed,  7 Jun 2023 20:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169532;
	bh=qygkCaueoV0Y08cF/1bEx58wZi9wpmzZxDqhrtlsgaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqJth4uTRSB11wFO5Mxj1nkxqgV2KR2VVEzwgQGUqZ6E2wIfZhXnqNFY3oKLwg1Ge
	 dYn6sadfClB7Mwc4wE1Iea9l4Y+YUkFrBdAZIGnK7FGVz1md/uJblflEqvYzWQN2uX
	 NiMh9tlfpGjoyv/pQjpnTiK+Nq4Gv81JIZNcmg1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 099/286] media: rcar-vin: Gen3 can not scale NV12
Date: Wed,  7 Jun 2023 22:13:18 +0200
Message-ID: <20230607200926.294596849@linuxfoundation.org>
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

[ Upstream commit 879c5a458e532b95783ce27f704d1b21573066f7 ]

The VIN modules on Gen3 can not scale NV12, fail format validation if
the user tries. Currently no frames are produced if this is attempted.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
index 98bfd445a649b..cc6b59e5621ae 100644
--- a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
@@ -1312,6 +1312,11 @@ static int rvin_mc_validate_format(struct rvin_dev *vin, struct v4l2_subdev *sd,
 	}
 
 	if (rvin_scaler_needed(vin)) {
+		/* Gen3 can't scale NV12 */
+		if (vin->info->model == RCAR_GEN3 &&
+		    vin->format.pixelformat == V4L2_PIX_FMT_NV12)
+			return -EPIPE;
+
 		if (!vin->scaler)
 			return -EPIPE;
 	} else {
-- 
2.39.2



