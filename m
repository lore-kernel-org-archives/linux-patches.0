Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BA70838;
	Mon, 23 Jun 2025 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712928; cv=none; b=FBMfQ8SQeXGeG9izpPThphEO+3AOVpcrbQlblF8sbBqakRDX/jR2QIOY5cPEGhJauDdIg2+a3sPOej+XpZ4jCX2FsZspjUCM5NnGi2FmJ1WxjQPuupcgspQNYomwO+GmDSZtuHKrxtc6HF3s+37xr995pHPOZgv7WAQ6Mu3d3rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712928; c=relaxed/simple;
	bh=xczFiNmuqP7KkCjFgLsbzRcvh+aeVHLvY+zNIBAou7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9TTXPdBL8noUBw8L2ctCUkk+WX77qH0YwZc9IgbixwUkNJQjX0yNgX32CiUl3Dqcav0vw6FZeaBMq6AgCJJvAxAeBVVE/4lcdxVJmJ9pXcjtXcIZkEZ1mJDSSuQvhABm2PL4R5FY/ahxUuUJTaSM9DCXx2kj5KOLVjQtEEpEqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSlHCK+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSlHCK+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18310C4CEEA;
	Mon, 23 Jun 2025 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712928;
	bh=xczFiNmuqP7KkCjFgLsbzRcvh+aeVHLvY+zNIBAou7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSlHCK+8VrEAPTNrB27UQQaLXjGsmuUKUYynHUacCS7bHUT39SkU1P2wkTvO7lgb/
	 XoqOynfv9gFsTMUhwA6xswKNBAfEcw6QuKpKAEB1BcST8OW0zPjaNpdu9CZYQUIsBb
	 ADmdwe+abTXHOi5jQy5LMRCzKGZ5qt8nwlzxCrjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Maxime Ripard <mripard@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 301/592] media: tc358743: ignore video while HPD is low
Date: Mon, 23 Jun 2025 15:04:19 +0200
Message-ID: <20250623130707.553673341@linuxfoundation.org>
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
index 2d5f42f111583..dcef93e1a3bcd 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -313,6 +313,10 @@ static int tc358743_get_detected_timings(struct v4l2_subdev *sd,
 
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



