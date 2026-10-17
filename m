Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3CA38654F;
	Sat, 17 Oct 2026 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254440; cv=none; b=I5pfXJBD1WF5CAYt5STKn9njoVTi5t+4O+uxFX1B1lURp9QnuwhY1zdy6PmSRkDrxqdmKzu/h0hpNTIg1nZJy9YH4eZDu3uvIaUhvDvLPxF+yOYmXiBfX0/ZrTLwnl4XPj0cZfHl3FsQcAqisR90PNKANBXlq87BSoyGOxW/064=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254440; c=relaxed/simple;
	bh=Sm5kVpwwjCIVeBWBNMjB93ECCaxh2mIrjGJaamPBJOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfOfRWHQ3rOQoW6MlhA6Nlq94XOqfP9fSA2ZJz4BfkuSvB+EHet2ZK/lQf7hG1vkiZV5BpFmsPHOt0LyOmQIYDFh0VQovYmTr3ajZZPNGAskptVoZV5tdw1g6UXydXNkBfbZ8jXD95JDmn/1jiFKllEHkY823Z8E4gYSkIItoRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUPSr38B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUPSr38B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB45C1F000C4;
	Sat, 17 Oct 2026 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254439;
	bh=OiybZHMHJ+mi6ew5RFKDnrmEah6DJ8QBiYBCN9IcywI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUPSr38BJzM4StYzhiWmW1UAO39VjTFdqys80rdYcSZ7jTs7geqCYdOu7VPOPw+6m
	 d9zl5PFAslfU/upFM2riIbeyxn/EBjSSmCJgRzG/X2Gh0HDORCxe+8MNx3UmHJiYjZ
	 lsD7GBKz9C7kDeK5TC4tHNXFB+05P1gEqAP0CdJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/869] hwmon: (pmbus/core) honor vrm_version in pmbus_data2reg_vid()
Date: Sat, 17 Oct 2026 17:54:48 +0200
Message-ID: <20261017160048.604632463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 828cd614e2af053ca5e1d6da767bbd8a1b5cabfb ]

pmbus_data2reg_vid() hardcoded the VR11 encoding regardless of the
vrm_version configured by the driver, while pmbus_reg2data_vid()
already switched on it. Any driver that selects a non-VR11 VID mode
and exposes a regulator (or hwmon vout setter) sent dangerously
wrong codes to PMBUS_VOUT_COMMAND -- e.g. an nvidia195mv part asked
for 200 mV got the VR11 clamp to 500 mV encoded as 0xB2, which the
chip interprets as 1080 mV.

Mirror pmbus_reg2data_vid() so writes round-trip with reads.

Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Assisted-by: Claude:claude-opus-4-7 [Claude Code]
Link: https://lore.kernel.org/r/20260620-pmbus-data2reg-vid-v1-1-5518030432c4@nexthop.ai
Fixes: 068c227056b92 ("hwmon: (pmbus) Add support for VR12")
Fixes: d4977c083aeb2 ("hwmon: (pmbus) Add support for Intel VID protocol VR13")
Fixes: 9d72340b6ade9 ("hwmon: (pmbus/core) Add support for Intel IMVP9 and AMD 6.25mV modes")
Fixes: 969a4ec86ca5f ("hwmon: (pmbus/core) Add support for NVIDIA nvidia195mv mode")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 024d197817375..5061717389dbd 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1086,9 +1086,24 @@ static u16 pmbus_data2reg_direct(struct pmbus_data *data,
 static u16 pmbus_data2reg_vid(struct pmbus_data *data,
 			      struct pmbus_sensor *sensor, s64 val)
 {
-	val = clamp_val(val, 500, 1600);
-
-	return 2 + DIV_ROUND_CLOSEST_ULL((1600LL - val) * 100LL, 625);
+	switch (data->info->vrm_version[sensor->page]) {
+	case vr12:
+		val = clamp_val(val, 250, 1520);
+		return 1 + DIV_ROUND_CLOSEST_ULL(val - 250, 5);
+	case vr13:
+		val = clamp_val(val, 500, 3040);
+		return 1 + DIV_ROUND_CLOSEST_ULL(val - 500, 10);
+	case imvp9:
+		val = clamp_val(val, 200, 2740);
+		return 1 + DIV_ROUND_CLOSEST_ULL(val - 200, 10);
+	case amd625mv:
+		val = clamp_val(val, 200, 1550);
+		return DIV_ROUND_CLOSEST_ULL((1550LL - val) * 100LL, 625);
+	case vr11:
+	default:
+		val = clamp_val(val, 500, 1600);
+		return 2 + DIV_ROUND_CLOSEST_ULL((1600LL - val) * 100LL, 625);
+	}
 }
 
 static u16 pmbus_data2reg(struct pmbus_data *data,
-- 
2.53.0



