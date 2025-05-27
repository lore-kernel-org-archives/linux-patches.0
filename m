Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244EB78F32;
	Tue, 27 May 2025 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365298; cv=none; b=alKTo1mV4NzSvPccZSdU/vd8NMAzGNa9Ul9iP7imrA3du8VoLtKUQDesMcDkPaNzhWo9IfEYe7PMsnXvrj16F4xvqVIG1R7DgSwtdQBhzreKjyMDTMIvmmh31JN1YwD2F/zkQ/J3WnBAXMq9YZdk6+V5eiH9ZhMsb5tPLdAVSOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365298; c=relaxed/simple;
	bh=hLbM61zMa0q/KLuejOsBvCPF5X8DuvA4gZaLeSMZLJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu6ioeCm6U19PBhaYkmGl73ZRNsJtOFx+Hfmg1mq7gGpfXpIL19gmeA0a/pWW6IKBPgMAE3WgqTv26wO3STyrWfL4rovbbdgAY1XBXpRiJtuw3+oe0GLcFRBjL2sobc1a52O+ezhP3b+byb7kA50xjJL6c+kBm1jmJQo8rX12os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxyk70X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxyk70X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F8BC4CEE9;
	Tue, 27 May 2025 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365298;
	bh=hLbM61zMa0q/KLuejOsBvCPF5X8DuvA4gZaLeSMZLJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxyk70X918LyzB7xkESIDujyWdGtf2sF1D7R1VTJH+MlQ0ZU1LP8kYLyjaq3VGVlM
	 8IYz8glcnjPtvKvAGCXkBHepCRi9FNS1CgCWI9SJ47wI1Tvs69QFtME7hYuqAF4qJu
	 G8+hxVgjL766idZ4p+poRlH7kWB+a6bA9vbE7JrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/626] eeprom: ee1004: Check chip before probing
Date: Tue, 27 May 2025 18:23:43 +0200
Message-ID: <20250527162458.436993675@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit d9406677428e9234ea62bb2d2f5e996d1b777760 ]

Like other eeprom drivers, check if the device is really there and
functional before probing.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20250218220959.721698-1-eajames@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/ee1004.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/misc/eeprom/ee1004.c b/drivers/misc/eeprom/ee1004.c
index 89224d4af4a20..e13f9fdd9d7b1 100644
--- a/drivers/misc/eeprom/ee1004.c
+++ b/drivers/misc/eeprom/ee1004.c
@@ -304,6 +304,10 @@ static int ee1004_probe(struct i2c_client *client)
 				     I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_READ_BYTE_DATA))
 		return -EPFNOSUPPORT;
 
+	err = i2c_smbus_read_byte(client);
+	if (err < 0)
+		return -ENODEV;
+
 	mutex_lock(&ee1004_bus_lock);
 
 	err = ee1004_init_bus_data(client);
-- 
2.39.5



