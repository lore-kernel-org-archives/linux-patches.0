Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B974315A;
	Mon, 23 Jun 2025 21:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714953; cv=none; b=hNAgnRZoyjhXWvRPRvwtHt1dEgceA63wg4iKNP3UaAN8pDLgn5MWZqC/I4eABIiYwzHGLtf37QvjBLWzTZZJf606thk8RCIrblgBsykg37mlVR85A4tY0+6i6FM2lhCWEpcGpv37CMY1oqiZzDffkEOOKaGWdAd83ti+uafCwME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714953; c=relaxed/simple;
	bh=Hw/hbhbTYRAc9vdgHBlp43AF3GW29ik/NUAZGKNcmIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG8whhArSkPLbbRsBV47R9aHPpfNj8Y/wHzaj67a6BT6Q+3jqmUrFS/BBXEOBQLp+N0yBHvHBZ+b+acXBQRV2EYSOFKGsIu7d8eYH7qE/UzNQQTjIari6r6lC4LoqiU6BcGCxi4OAQ7x1h/EeteM6PptwkIpvRIUOm1Dgi73MHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0hdt/YN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0hdt/YN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AA6C4CEEA;
	Mon, 23 Jun 2025 21:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714953;
	bh=Hw/hbhbTYRAc9vdgHBlp43AF3GW29ik/NUAZGKNcmIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0hdt/YNJoOo6t7B7RJUi1NIZTJFEVkJJGfdKEjEw54xMI9an40F5B9s/dud8/1lu
	 GjfeA3R5zorzKakG7Aq+f1fTd1UBJhImGTUJhN2JLrEcNUKar4FM7eQZUlp+azKO+L
	 lZy3AcoMW8SaQy3QscndjC2facpI7obYa3f1kDgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Maxime Ripard <mripard@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/355] media: tc358743: ignore video while HPD is low
Date: Mon, 23 Jun 2025 15:07:24 +0200
Message-ID: <20250623130634.052766719@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 6829c5b5d26b1be31880d74ec24cb32d2d75f1ae ]

If the HPD is low (happens if there is no EDID or the
EDID is being updated), then return -ENOLINK in
tc358743_get_detected_timings() instead of detecting video.

This avoids userspace thinking that it can start streaming when
the HPD is low.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Tested-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/linux-media/20240628-stoic-bettong-of-fortitude-e25611@houat/
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 8e9df9007d2ed..1b3441510b6fa 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -309,6 +309,10 @@ static int tc358743_get_detected_timings(struct v4l2_subdev *sd,
 
 	memset(timings, 0, sizeof(struct v4l2_dv_timings));
 
+	/* if HPD is low, ignore any video */
+	if (!(i2c_rd8(sd, HPD_CTL) & MASK_HPD_OUT0))
+		return -ENOLINK;
+
 	if (no_signal(sd)) {
 		v4l2_dbg(1, debug, sd, "%s: no valid signal\n", __func__);
 		return -ENOLINK;
-- 
2.39.5



