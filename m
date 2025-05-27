Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A6227E7CF;
	Tue, 27 May 2025 17:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367495; cv=none; b=mBiIZUOFxZxfRiwDR8rpGxJSYOu8R1M82DI89rdo9u/Lf58wujkEHpkRc5PcL/E3ibbPiiZmC554gtw7eQwP0tkOi7t2/Qe+0zyGHOb478mCC79a12ZZLdsGmzQUlSgkxmEDPqHH8oI6j1qaEBxlwIGLqRfsfFTXsEpkEN+UvTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367495; c=relaxed/simple;
	bh=T9JYsD9vo0W9rZKQZQ3BYkCztc9eth+3VCmltINL+x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0e0kULY/ixr4VGbTVGLMRiZG1eooJ/2ZO2HKa+U3pFot6DkILjVHBF330CSLDJ9+6qOtuj4pYAOTzxOvC8sB8PnMFHmWesWMGA6W/S3iyEFv0xUTowDGok+/1rB+/KQmOOm2llkm6lkc4FvOr2CH9d/W8i+UoBB8sdApkXkaog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9UkS66V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9UkS66V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E18BC4CEE9;
	Tue, 27 May 2025 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367495;
	bh=T9JYsD9vo0W9rZKQZQ3BYkCztc9eth+3VCmltINL+x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9UkS66V53A3I4nxIukixslgD49EtPke7Tz7Y/ZX5te7pPgR6YlkZQGEi0jnWzbgc
	 z+ynALV0sujnnuo5yZ0dUvMrSf5YU45XAOrHnXAOp9T/QqwLV5BrFQT0dTlcvgCuQP
	 oPzRmnw4lDOOOQ5n4N1laZXxJaSQ4uEL9kt6CVxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 406/783] eeprom: ee1004: Check chip before probing
Date: Tue, 27 May 2025 18:23:23 +0200
Message-ID: <20250527162529.637985277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



