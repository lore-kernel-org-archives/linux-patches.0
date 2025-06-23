Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7E44409;
	Mon, 23 Jun 2025 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716029; cv=none; b=B+XbUsIPCH5unIU2czoT0EFReXVRiK0Z83bV78u7PucLmkmde1JrSsxEJWgkYZiX7VOWXnn6b+ziQISjWwuo5ImTXkpVg+bdYYQKJq+6JtX8NK0oJjaZioyYNibSbWSsmw+Ms4+RZpdEKJ9cmpht23N1V3n8QvlDnfvWu3rwets=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716029; c=relaxed/simple;
	bh=wuTb0BveLSa3xwhDWy+dcGdgj2vz61HHPaAGhNGAFMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seUiodaaQU4Pu8t2fEc09fyawWMtk9TNbwK1uU+qwX0uScv4bThFdUw2NEjMTX44BtH2xJhNDSMNmVz2PeHDE7ZWMIrjI6zTGHPEzFsAcqyQmSDKwT4NLa361GoXVY89L6LXppe0uVdbULXFQFDYHf60n+nLRy32ONNtIq+KGe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxxwMJfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxxwMJfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014DFC4CEEA;
	Mon, 23 Jun 2025 22:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716029;
	bh=wuTb0BveLSa3xwhDWy+dcGdgj2vz61HHPaAGhNGAFMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxxwMJfHMLierCVTXnZznmUgoPekOOyprs9HmckcW53Mc7QaFhB0xLWQLeVb6boUu
	 xD/IzLAe16HzBF0JCj2EhtYsK2FB9QDdp3rxMGu33zhzhXrEoiUROHh/v6TWNI8T3V
	 FmfTgdUkMxSUw+/jT9rj04PvKmafNNC2YqxwanP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Maxime Ripard <mripard@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/411] media: tc358743: ignore video while HPD is low
Date: Mon, 23 Jun 2025 15:07:22 +0200
Message-ID: <20250623130641.149130422@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6f5ca3d63dbdb..87feada1f6020 100644
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



