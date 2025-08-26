Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AD03570D3;
	Tue, 26 Aug 2025 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217881; cv=none; b=QD9xDVMgKHSfsCNxGS5I31mXxxONBUHe9WyhsudFJ2YRlxnnuGIgrEmAWnv0cCPWcq0vsB8K7J1SHAOmhadID0LpBk5Tr0IX3kkizppqHpmU7rRAxQZoKmSR6aix8DgMBEcqR/hHCt8ozIbXeMtXS/NX0AmoT4zWhfyQmqx8//I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217881; c=relaxed/simple;
	bh=DjEHFVJuYus2T979+yfpG8xNcXfc4nOKPeJrepgUgQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfz4zXCceePtKlFIQESGAKzgeesUYRAMHpHoxK+uLmG5F9sNhIhqOs47QHYyQHl8XIwxkM+cgWVUOR//67P71J7AUIhwztrXFuW1JPnJEF6z/z4DmPD0BrbAEjVp7Z8flbV6PwtlW6GoWfe6wFSGrI6uvdpJNSbrN6pghETbgVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSM6S/m5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSM6S/m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E721C4CEF1;
	Tue, 26 Aug 2025 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217881;
	bh=DjEHFVJuYus2T979+yfpG8xNcXfc4nOKPeJrepgUgQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSM6S/m5c/TGEb8IAwRLFbA4P5MG7kFNjS8h3mUzSMDPIadM0wVLQnHfwPGQ2hC/G
	 /IPX06zEsCTJ1wpsROH8wD3MW0y7eP3yGY6Tf9+xyMfcR3sRaiGGqPoYl/+PQcDxMs
	 a58tDgeBGSblVxRsqfzHJgEf73g05qbmjsy64vQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/523] media: usb: hdpvr: disable zero-length read messages
Date: Tue, 26 Aug 2025 13:08:41 +0200
Message-ID: <20250826110932.133424866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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



