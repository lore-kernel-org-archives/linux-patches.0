Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3897519DF9E;
	Thu, 15 Aug 2024 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728538; cv=none; b=irT1dfrDfCGsWFNg3u++S0MfKPvzjRjFY8TW7p8gBbCc2vHLWJeLa5sgSjFj19HSm9u9Jnf5qdruWvnGdw7SIq2CtKxUh4vxM9BIrvfvdaOURx6+4+O8X0SXywkxSsw1WcsjtWyXnEzBhfzohyamwFlC728APuZWBf8XQQtvYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728538; c=relaxed/simple;
	bh=BCSanpJWA/pCxi9PbabiM5F8LHY6EC9YeVvwqzTwijA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMeqOEf19tMD5Q3A8Ph/OnPVbHdPXf02RUKoYSd2L83YChFLtxjYtTq+sW7s/WWDbHVE8z2LHTbT2z8kiYBnYLGh2fA4KWD/Rd53U/OIo/iiL0Ahkd8TYVOOtvqu1pzL/eOznL+VLZDjXi90HezxeAaGOzf9zQD5KXgkHkgK2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cp9nKzqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cp9nKzqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EE5C32786;
	Thu, 15 Aug 2024 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728538;
	bh=BCSanpJWA/pCxi9PbabiM5F8LHY6EC9YeVvwqzTwijA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cp9nKzqWUv4s6VVK/Wo/t0FRJ2bfwdegdp6/fUBh947/RxZ39aYcEjyY0Inn94gEO
	 6dYVpRczJJP7uwZyLkgHCHWCdj7WnYs2lpiNInhlvXwMlYDik48uHshm+Mkab8UpFD
	 G1O613q8kQndR7ZeVXBYqGcUZXaJDratZRaoQFkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/196] saa7134: Unchecked i2c_transfer function result fixed
Date: Thu, 15 Aug 2024 15:22:28 +0200
Message-ID: <20240815131853.277056453@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3025d38ddb2b5..d710c00b4dc91 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -475,7 +475,9 @@ static int philips_europa_tuner_sleep(struct dvb_frontend *fe)
 	/* switch the board to analog mode */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-	i2c_transfer(&dev->i2c_adap, &analog_msg, 1);
+	if (i2c_transfer(&dev->i2c_adap, &analog_msg, 1) != 1)
+		return -EIO;
+
 	return 0;
 }
 
@@ -1027,7 +1029,9 @@ static int md8800_set_voltage2(struct dvb_frontend *fe,
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



