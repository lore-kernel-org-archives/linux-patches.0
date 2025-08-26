Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2DC34AB15;
	Tue, 26 Aug 2025 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216424; cv=none; b=EmP1qvjiQ20houuPoQgb1hdbRnKF3NVNF4iFVihDGYBfeQTL+CCE5zUqppRx+LMCGAZYcg5E/GEpwPNGsjPD7FyIPwxK0qh6q89CqbALOme3wvOrFe9Zdiq/oHhCEx9n/Grdopf8Qf6utWli63xbLhfTQju+upWc3uU8Yu/ergs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216424; c=relaxed/simple;
	bh=BQlWdGaG/cOlPGHOGWzsWIJUx4c3f1Kf7u/JKgGSW40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et+escWFvAKQ54VGgUhi0PNVbw72HhNi2H1tGgpHNLvFsIi45WRHrkoAYmkUFZFHPtYqemqEY2YSwRKHAz23jeSJph+kM22TubTYj8F+EUCjIXfJN6a67FMN15gOiH69olgR27s3DFDF2RCmS2y2q+022o/PQbho3N42o89Yoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jwir9Kd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jwir9Kd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A213DC4CEF1;
	Tue, 26 Aug 2025 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216424;
	bh=BQlWdGaG/cOlPGHOGWzsWIJUx4c3f1Kf7u/JKgGSW40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jwir9Kd89G117GJbudufsnOxM0cTxEwxFOn9O7XU246uOpOs4+GpFc4vmV3hNIYKG
	 qpcPLXbvlsXIE9E/9PvOl9FBIk9DLTSR6kOj0GcLw4BibsMquUEV8Nbgu5l1eSQlT+
	 9f7ORGp3F/pA9hYn6AkGc4h7Yt0aEjOQoOLU9lbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 407/644] media: usb: hdpvr: disable zero-length read messages
Date: Tue, 26 Aug 2025 13:08:18 +0200
Message-ID: <20250826110956.540482190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit b5ae5a79825ba8037b0be3ef677a24de8c063abf ]

This driver passes the length of an i2c_msg directly to
usb_control_msg(). If the message is now a read and of length 0, it
violates the USB protocol and a warning will be printed. Enable the
I2C_AQ_NO_ZERO_LEN_READ quirk for this adapter thus forbidding 0-length
read messages altogether.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-i2c.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 070559b01b01..54956a8ff15e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -165,10 +165,16 @@ static const struct i2c_algorithm hdpvr_algo = {
 	.functionality = hdpvr_functionality,
 };
 
+/* prevent invalid 0-length usb_control_msg */
+static const struct i2c_adapter_quirks hdpvr_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN_READ,
+};
+
 static const struct i2c_adapter hdpvr_i2c_adapter_template = {
 	.name   = "Hauppauge HD PVR I2C",
 	.owner  = THIS_MODULE,
 	.algo   = &hdpvr_algo,
+	.quirks = &hdpvr_quirks,
 };
 
 static int hdpvr_activate_ir(struct hdpvr_device *dev)
-- 
2.39.5



