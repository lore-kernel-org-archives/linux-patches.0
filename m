Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591100;
	b=hsoRIYnMAOdEydZCNN034AlAbCFVQpuLxpgKs3S7RfhgrGF1nx+PKJqW/Z9yXTBoXrsb
	 bGjivG4Aaa3FOXOCC1IMHP17go036R3V1XqdFuAj+RSrK/2u7a2E+sRETV7l+GY7HG7/u
	 xeRaiIuHJyEFHVRLuW8M1e34J0k5VpOHOAsxvKfAsYG1Y8Z42rHZ7jFhC+OHOvSGgJ957
	 khI1sv56LV54Pwibh9MLwOE6VQB9E071eMBKnAgpctDc3Krp66VLAWFbNBvcs5ro3YHQ7
	 absPXBXuukbRNvX2SCj85QfTpIZe3+1jQi9qU6cRNn+jQvy5PKPjdD14xaHwlw5aH2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5I7DvLEGdF5Jjfn5Qb2a7FsabQj95JSbAQoylXnm414=;
	b=ZpPRs+ce4dtBfNv5SO47Y+LVmXBai8Akbpso9sLh+quUeWiJZ7KAn2eYWA0eCCQrPEvJ
	 a5tXQg2Y8ZuTcF+HMABoHEjG2GE/VfXKLbI5e9YihPJ/WyLsu5n8ZQGRBzt7Zyb1pwY4o
	 qqmW4Fdi+ux7bWaKEoZbzt1VTVqPO5ygktx57Dqb/0feAQyJw+1TvneO2q7ov/SgFxf8u
	 sWhDrsMwLrLuFfvKbN0M2l1dNkFUyo5woJtnqGBui2/zDYEoWGkiwa2OmYyIc7k4d+ddr
	 hiKx2DEe1gaVXtSamC4xGKAi5t8YX/MmZmoO1ljEEKoMA/CbIdSkWPARr16n3IztyCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JN6M5+ds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1A2606BD08;
	Fri, 13 Nov 2026 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JN6M5+ds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995501F000C4;
	Fri, 13 Nov 2026 17:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591099;
	bh=5I7DvLEGdF5Jjfn5Qb2a7FsabQj95JSbAQoylXnm414=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JN6M5+dsTb8wizFKUJV2OPp6CXV56af+tU++qZw/NbmXBjY3OfPzV/ZFq3ID1fEH8
	 hdiQMcse19bhkygx7uWT/xeqcUcjxNfRDx5O+c0KNnmqzloXexgKshsgyiMz7Qc5VE
	 tZW4jWTcZ3Sc6ebpYy64yVbejP3+vAHcGtzb4u7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/670] hwmon: chipcap2: fix command error diagnostics
Date: Fri, 13 Nov 2026 10:46:50 -0500
Message-ID: <20261113153820.171966786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d0a03e1a2d9bd53b94fe6dff7a1a8058d25be82d ]

The command response field only contains bits 1:0, while the
error flags are stored in bits 2:5. The existing diagnostic
checks test the extracted response field, so they can never report
an error flag.

Test the full status byte for the error flags, and check the
configuration-load flag instead of RAM parity for the last diagnostic.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-1-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index d9adb9e1f9ab0..0c66a0af36528 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -164,13 +164,13 @@ static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
 	case CC2_RESPONSE_BUSY:
 		return -EBUSY;
 	case CC2_RESPONSE_NACK:
-		if (resp & CC2_ERR_CORR_EEPROM)
+		if (status & CC2_ERR_CORR_EEPROM)
 			dev_dbg(dev, "Command failed: corrected EEPROM\n");
-		if (resp & CC2_ERR_UNCORR_EEPROM)
+		if (status & CC2_ERR_UNCORR_EEPROM)
 			dev_dbg(dev, "Command failed: uncorrected EEPROM\n");
-		if (resp & CC2_ERR_RAM_PARITY)
+		if (status & CC2_ERR_RAM_PARITY)
 			dev_dbg(dev, "Command failed: RAM parity\n");
-		if (resp & CC2_ERR_RAM_PARITY)
+		if (status & CC2_ERR_CONFIG_LOAD)
 			dev_dbg(dev, "Command failed: configuration error\n");
 		return -ENODATA;
 	default:
-- 
2.53.0



