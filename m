Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250D628FD;
	Tue, 26 Aug 2025 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214612; cv=none; b=WQfmJpFwsWtn3SJqHDty2TF7d1uoyLgiomIGxRIRHlBAwHX6BRLuGdcNfPc3qDRmaUpaExt5m2wLxezdRoAx/S/ygejKA3fkR3pc8XuC8Wakt825kGXXPAtPl2pGoenHQQGa8GW5XwS0JTQwoMAcYpOeMzb6Y5m9BhGakLpvMiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214612; c=relaxed/simple;
	bh=it1E0wnhqoXT4MYn9zZAMX2HDOh0ANsgNK8riaz4sZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaVROhyW29RWj94K0ALPnM12/kue7nHpUYuP+/YSRRlIP9wi1vBrC78C45+8I6DCsOzck45AOpJ79pFjtwX+utbwqjR7vOYKdv/4aud1mb8wG/sCU+N7mPI5Wls1YV4/7dIy8ACQPe8bLeKj//SmRKMT5o5UEn61aScf67HnGo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uus6FkV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uus6FkV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB92BC4CEF1;
	Tue, 26 Aug 2025 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214612;
	bh=it1E0wnhqoXT4MYn9zZAMX2HDOh0ANsgNK8riaz4sZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uus6FkV3jBc2ketSWFAvQ2fdEaAl7CHhdI7rD6VFOqj4+PbINT6cMsJ6uUeL6B2Cd
	 hvuBniDacKpUEQd7Wiu/+KEVaSqbJ0Cveu1qxoc42QwG9E0JyAUqfy9S+vTr5lV2cR
	 FEPGFPL/54XJv7Mr8djqMaMLEcZeMYqwi9Trug7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/482] media: usb: hdpvr: disable zero-length read messages
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826110935.803215441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



