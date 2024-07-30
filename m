Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E361A617E;
	Tue, 30 Jul 2024 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357043; cv=none; b=hhulNSJzYYVaJqBPCVvP3zSAl++iq1Q/jgtV0xjQtbC0TipGciPLlsnaPxd7LXhUN8SI85OdWZym3IHDYtr36g2VHWv9uNVYco4trfGCvxxIuMuoSVpjv6PpIx1r60gnNkn1bNLvZIwQXVql5mbawYGbX8OB4dSBwmYfPEWX7jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357043; c=relaxed/simple;
	bh=Mv+eBAAQKvyvtzAEgm6ji71tC1/XLdxV7xz5FwxOb4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYFKUlJOrhvvASLkoS4Nwm3WEFSq9CqTjqwjUqwk4b5IrO8tuBhkd/rITNZF6sVFTsErRqC0P/dpVfWCHGRPlLHUcr1Z1Xwmy9TvF/cL1MOphOP+TsA5DTivGPEfR40PcdbrElHFlZ2QBKLKOTtjq5jy/fgVhrkktquFVzMl1Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fx37oIHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fx37oIHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD41C32782;
	Tue, 30 Jul 2024 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357043;
	bh=Mv+eBAAQKvyvtzAEgm6ji71tC1/XLdxV7xz5FwxOb4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fx37oIHniYxw1PnN4K9GzJv6I44RoAkJg/airQ8zok8qLStHHAgbPAGTxnEvsrm10
	 OES6kJL9s9qqVrxvnzcRnJrETPNEAoaiGmmJEAfgkR6JqYjBjsT8PlA9KTX8ZvBpnb
	 PkCmz1tYnDYUa6bJcE2wMHhbDnIyopGdxUpNcCQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/568] saa7134: Unchecked i2c_transfer function result fixed
Date: Tue, 30 Jul 2024 17:45:07 +0200
Message-ID: <20240730151647.695047289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9c6cfef03331d..a66df6adfaad8 100644
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



