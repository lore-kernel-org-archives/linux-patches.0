Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DCF70838;
	Mon, 23 Jun 2025 21:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712846; cv=none; b=rEsDqC+2wRpZV4qwyasgBfyDZVTugE3CIv3Bg3rsIifvE5/lQshLCj+K8c3WnPQ/05M5styb/ePHuiHKS7olPgPga/3k0hLekUTUlbT61G1jwQNVlORUDqjcmHaSztQpzNHdVZuW3lFzHs7hcj254MnQaiqQVGxST7Folpeldfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712846; c=relaxed/simple;
	bh=EqjGMtmbx1Bb8XxdZXkBj4hdSEr2l8AbKHTGLTp9Ics=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ0zf7RtIDfopWM8EF11TdnBuFcTZQLk10s2YHIZr/wt5lhmjjsDMNmoPp3Rh/vVcXShW/3r7pyShlAhft/sR0cZPZUYDfQ+5bXr/xt1bZelHQkydfzTcZVLNCKyajHdJxlh2Fd/xYGWCQfOZwfWp3XQhSm7n7tVlAppOpUOx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JARMZwja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JARMZwja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E118C4CEEA;
	Mon, 23 Jun 2025 21:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712846;
	bh=EqjGMtmbx1Bb8XxdZXkBj4hdSEr2l8AbKHTGLTp9Ics=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JARMZwjatEtkX7WVLRjaj1ROd1Auj6LXWVWnr7wq/608U8TMck8s3ixqrZVymsWYG
	 f61LJvzWCr1+b1A6NDe34ezkB5/bTwxOLIPeYPPvlqZGeFy4YNyp70Yj2Esb4VAD25
	 wcfJFVmd7P6YiOYgRnpTY/vwHPpqevhtEKbin6Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 034/290] media: gspca: Add error handling for stv06xx_read_sensor()
Date: Mon, 23 Jun 2025 15:04:55 +0200
Message-ID: <20250623130628.024615929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 398a1b33f1479af35ca915c5efc9b00d6204f8fa upstream.

In hdcs_init(), the return value of stv06xx_read_sensor() needs to be
checked. A proper implementation can be found in vv6410_dump(). Add a
check in loop condition and propergate error code to fix this issue.

Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New subdriver.")
Cc: stable@vger.kernel.org # v2.6+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
@@ -520,12 +520,13 @@ static int hdcs_init(struct sd *sd)
 static int hdcs_dump(struct sd *sd)
 {
 	u16 reg, val;
+	int err = 0;
 
 	pr_info("Dumping sensor registers:\n");
 
-	for (reg = HDCS_IDENT; reg <= HDCS_ROWEXPH; reg++) {
-		stv06xx_read_sensor(sd, reg, &val);
+	for (reg = HDCS_IDENT; reg <= HDCS_ROWEXPH && !err; reg++) {
+		err = stv06xx_read_sensor(sd, reg, &val);
 		pr_info("reg 0x%02x = 0x%02x\n", reg, val);
 	}
-	return 0;
+	return (err < 0) ? err : 0;
 }


