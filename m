Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9E19DFA4;
	Thu, 15 Aug 2024 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732113; cv=none; b=azpYj8uBtFheLaefgL0IH+/HZsR4AKc5ZzpYUCSzalqXbzehjKG3qmFMjarV2IIe6331bfA/Wy2xaKMqg0NDXJ1ZiJKN65zroxVplc0SPoBzpHR37XaZLRyW2YnetmpQxTjkvi9CVk6/PoBejQjki5wX9LcnPsBrneGzR/fbA5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732113; c=relaxed/simple;
	bh=bav8GNLeO7SiEDTw0BCq4WGtvKpqUwkjyriA8nXSTwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MN0LpSA/WB6fhsv4hdq9XmiBQ352e37VC5JjkiHUhEFHUwmJf0KTHyF75Tn7Hzp/9Nn2dLeSm69bBlO4t3NM+vusETP8+o5fROQPZJ8CXp8nzzGQizeDL5I0WG5uD0wRYlu1piv9pZOUmn/aO76UIXURFGWKKCfrGa2Kvwj9ecU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZP5uddp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZP5uddp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00837C32786;
	Thu, 15 Aug 2024 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732113;
	bh=bav8GNLeO7SiEDTw0BCq4WGtvKpqUwkjyriA8nXSTwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZP5uddpVJsoLDbllFcFakwF+QeIIQ3XSCmO4ktm0AOAaSIo/kMsEkuFPqbEeRGCO
	 GglLUcv99g+1i8spie7EdGdZlY8h2kAl6XqZZIfWCRHsv4RppONNAiABa/0Ule8UrM
	 nF9uLoAVz1NY1k+gCj56VwpR6eV0E4CVcwxyfyZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/352] saa7134: Unchecked i2c_transfer function result fixed
Date: Thu, 15 Aug 2024 15:22:23 +0200
Message-ID: <20240815131922.219641232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksandr Burakov <a.burakov@rosalinux.ru>

[ Upstream commit 9d8683b3fd93f0e378f24dc3d9604e5d7d3e0a17 ]

Return value of function 'i2c_transfer' is not checked that
may cause undefined behaviour.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2cf36ac44730 ("[PATCH] v4l: 656: added support for the following cards")
Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-dvb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index f359cd5c006a7..c786b83a69d2b 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -466,7 +466,9 @@ static int philips_europa_tuner_sleep(struct dvb_frontend *fe)
 	/* switch the board to analog mode */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-	i2c_transfer(&dev->i2c_adap, &analog_msg, 1);
+	if (i2c_transfer(&dev->i2c_adap, &analog_msg, 1) != 1)
+		return -EIO;
+
 	return 0;
 }
 
@@ -1018,7 +1020,9 @@ static int md8800_set_voltage2(struct dvb_frontend *fe,
 	else
 		wbuf[1] = rbuf & 0xef;
 	msg[0].len = 2;
-	i2c_transfer(&dev->i2c_adap, msg, 1);
+	if (i2c_transfer(&dev->i2c_adap, msg, 1) != 1)
+		return -EIO;
+
 	return 0;
 }
 
-- 
2.43.0



