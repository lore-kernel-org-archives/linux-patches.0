Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9D41A795;
	Sat, 12 Sep 2026 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237803; cv=none; b=WLh6AS/3wPhjLM1wDP/w5Szy0RH7g3SGKjDv/kfY7LR5CFqEpp+HbwQxaVzVoOw2HBr6Gw9JMrOzsGZ25nK+KtFGImDzsQ329naVA47bQEiz71QEZNQwHZ7FYiS93wsAVcDBQu49C5eJu/Wa0UFjR+oO+cT+m16RoTseKunE3lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237803; c=relaxed/simple;
	bh=ghei0E+EW5R5tEqWJ4c1fwBRZBFXm1RO5r5o0rvXmC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxCqolO2BdsGzcyK3LXf693mFrAlRYGACCOfT/2j2xDpM49vhI8not8Qm+fL0UKGOFej9zX6yIK01K8Htp5b14r/u+9oqV6n7QvtdVdDBh7Y2Zk+rp/BAExOM4C+2VwbagHrKwL0deFHrDd4qOskMmNPOl6TnHD/U6WTP6UVTq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSyodOCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSyodOCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224361F000FF;
	Sat, 12 Sep 2026 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237801;
	bh=qVO4j3uNCb41MoE037CWuogDv+QY7hw8MJeAErqx8yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSyodOCO5zby+EnW4pcc4VyCG8EL5QqEYpG3kEdZ6sYEkRh2mqqx6zd4emzmrDWR8
	 1ZSGeaf8ui4OrsJvsKw9dD6S3GADKSQhSTwy/iTsC2av+FP1M57SgsuD+HPWSDOcml
	 BCqAJWNIJXqp7NadOyDzkwUqm49K6qPmWXt7vSfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 332/935] media: vimc: fix pixel format lookup in enum_framesizes
Date: Sat, 12 Sep 2026 08:56:02 +0200
Message-ID: <20260912065534.417949851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arash Golgol <arash.golgol@gmail.com>

commit ad4c65fa30cfb00e2e06adae9a8eb407086eaa66 upstream.

vimc_capture_enum_framesizes() looks up the requested format using
vimc_pix_map_by_code(), which searches the pix map table by media
bus code (MEDIA_BUS_FMT_*).

However, v4l2_frmsizeenum::pixel_format holds a V4L2 pixel format
(V4L2_PIX_FMT_*), not a media bus code, so valid pixel formats end
up being rejected with -EINVAL.

Fix this by using vimc_pix_map_by_pixelformat() instead, which
performs the lookup by pixel format as the ioctl expects.

Fixes: 09c41a23a2e2 ("media: Revert "media: vimc: propagate pixel format in the stream"")
Cc: stable@vger.kernel.org
Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vimc/vimc-capture.c
+++ b/drivers/media/test-drivers/vimc/vimc-capture.c
@@ -176,8 +176,8 @@ static int vimc_cap_enum_framesizes(stru
 	if (fsize->index)
 		return -EINVAL;
 
-	/* Only accept code in the pix map table */
-	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	/* Only accept pixel_format in the pix map table */
+	vpix = vimc_pix_map_by_pixelformat(fsize->pixel_format);
 	if (!vpix)
 		return -EINVAL;
 


