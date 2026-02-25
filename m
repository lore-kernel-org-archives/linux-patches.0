Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA11D5ABA;
	Wed, 25 Feb 2026 01:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983193; cv=none; b=fXEwz4XN71BtrzsFWlPFKA4XL7H9krKA9ResYDFu056LcpYR2b2qtny6iQlWVZthIGIuEtJ3SYWiQhq8vmZTU58XbcKT5M3DSue4k1J48DFOYN/On1dxMj/LjEYf+IHH8NigNSK8YeWDkQIYMKcybeIiTwtf6rtSt+gih8hwpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983193; c=relaxed/simple;
	bh=SGPbNC5E3oqPC4SJjv1OfABXEGBHKbDJ/7UlhaM2Pvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cx6ruJatcP+CGBNUxLkQruLdRhWEI7dy9kZWGD2DneO/P+UXr+VUcVdpCFknv/gTK2XcZ+xh/jeGW2nEszacV7IEyuoj/tyVNby34n//6H8/YCiLCEeq674iAMEddcVp2bX6UzfBAkNJle8vHurimuQwUUMzClcsLmgz8Ctpb2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUcaVh5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUcaVh5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738DBC116D0;
	Wed, 25 Feb 2026 01:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983193;
	bh=SGPbNC5E3oqPC4SJjv1OfABXEGBHKbDJ/7UlhaM2Pvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUcaVh5ONUQRe80PTz7LfTzZ556I6R/XWJWKs4ytKvY5isJk6Y1mTSj9R3ozwKt8K
	 GTtV0NZRXjQIbpS3MgE6wVFHFqJaY75IG/9dUI8ii8B2eKhiYEJ5XhUeFWf1MHEVIO
	 8IfGi++plCDMFbUQsPYM85qysFAP+akDJiOz1Hb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 341/781] mctp i2c: initialise event handler read bytes
Date: Tue, 24 Feb 2026 17:17:30 -0800
Message-ID: <20260225012408.054786875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 2a14e91b6d76639dac70ea170f4384c1ee3cb48d ]

Set a 0xff value for i2c reads of an mctp-i2c device. Otherwise reads
will return "val" from the i2c bus driver. For i2c-aspeed and
i2c-npcm7xx that is a stack uninitialised u8.

Tested with "i2ctransfer -y 1 r10@0x34" where 0x34 is a mctp-i2c
instance, now it returns all 0xff.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20260113-mctp-read-fix-v1-1-70c4b59c741c@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index ecda1cc36391c..8043b57bdf250 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -243,7 +243,10 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 
 	switch (event) {
 	case I2C_SLAVE_READ_REQUESTED:
+	case I2C_SLAVE_READ_PROCESSED:
+		/* MCTP I2C transport only uses writes */
 		midev->rx_pos = 0;
+		*val = 0xff;
 		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
-- 
2.51.0



