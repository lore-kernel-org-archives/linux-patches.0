Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3B0217668;
	Mon, 23 Jun 2025 21:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712871; cv=none; b=JFhsXAWITKTr2ia34qVpxrrxiiz3IKdV+xaXYKqfQk2agIVp7Fx8aFlTJe4SqVCotFbuhv00aTio0t/0YT31/WKMtziHgb9TGBziX+3R8Xbm/3JEA2vqFNk71c0669w0GroAHEh/kOW9y9oi01Nbn/Q6MY92Z7yQ7wIlyzDEfoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712871; c=relaxed/simple;
	bh=kBdey57rEhVp52xGpd5W+8O6SQt12Lsk1FznCGvj8Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIfW8wi1XPvbgYyxTwCcXOFHBlgOHcLIVgf52UObLW9j6nOAiARDP4UVJeJK14UhQHzKPfRmB65iKf2a0nhoEiLiBHH1v7VxnuKuFYL6uYR4zWrym2C7Fs8F2MQbZfFZfQAcPoEoizLy3+n74gGa62nM8JKP6Rd2o/Z9V0O/AD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYScOpyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYScOpyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CECBC4CEEA;
	Mon, 23 Jun 2025 21:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712871;
	bh=kBdey57rEhVp52xGpd5W+8O6SQt12Lsk1FznCGvj8Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYScOpybVsleLTHgrl4gKKGYXv0SDZNormdrdaUHxTm4uXEzPw3lCeo/1SR/oWvSG
	 amDcVZdTE6C5ban39xKMR7fQ6MQfdUj6pm8JYyRR7/es1uo1pbagcMFlv3rxnhMpub
	 8NsRJOwf2kQnsXAPRpf0o5851rR2EUure01GAjq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 298/592] media: renesas: vsp1: Fix media bus code setup on RWPF source pad
Date: Mon, 23 Jun 2025 15:04:16 +0200
Message-ID: <20250623130707.474751478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit b6e57605eff6224df4debf188eb7a02dedb7686f ]

The RWPF source pad media bus code can only be different from the sink
pad code when enabling color space conversion, which can only convert
between RGB and YUV. If the sink pad code is HSV, no conversion is
possible. Fix the pad set format handler to reflect this hardware
limitation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/20250429232904.26413-5-laurent.pinchart+renesas@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/vsp1/vsp1_rwpf.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/renesas/vsp1/vsp1_rwpf.c b/drivers/media/platform/renesas/vsp1/vsp1_rwpf.c
index 9d38203e73d00..1b4bac7b7cfa1 100644
--- a/drivers/media/platform/renesas/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/renesas/vsp1/vsp1_rwpf.c
@@ -76,11 +76,20 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	format = v4l2_subdev_state_get_format(state, fmt->pad);
 
 	if (fmt->pad == RWPF_PAD_SOURCE) {
+		const struct v4l2_mbus_framefmt *sink_format =
+			v4l2_subdev_state_get_format(state, RWPF_PAD_SINK);
+
 		/*
 		 * The RWPF performs format conversion but can't scale, only the
-		 * format code can be changed on the source pad.
+		 * format code can be changed on the source pad when converting
+		 * between RGB and YUV.
 		 */
-		format->code = fmt->format.code;
+		if (sink_format->code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
+		    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32)
+			format->code = fmt->format.code;
+		else
+			format->code = sink_format->code;
+
 		fmt->format = *format;
 		goto done;
 	}
-- 
2.39.5



