Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71E224B28;
	Wed,  8 Apr 2026 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673139; cv=none; b=ho5ucDuIOkLrmKaIks4c979ABKjHyKFcpHxd7DlmfUROl4HpLnAH+y7NJp3O6e4lj0djEVvfED0795AS85wjWKk/KI5MeFLm3KfzW7iIL1Sy0bLbHUB3Vfmdzl9OaX0xfn7Ym32DzF01BRbLHmj89EkAKA3j+zkmpj8n/3w1jaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673139; c=relaxed/simple;
	bh=7v+uiWUVnCNKuiLB5op0U9IoqH22caWB8ctZRCY91dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTqe8uh0wPny5N5lFUhrvXS5anlqqWZzUf+qHCFwGJuhzx3P7bsvabDQiSOeQzMZCX5ualgRfCdaLvLOtYh87Pwc95mcHLgR6YTX8m7v+5caWDrtUm8u35yK2BbCn4UsT2To67Y0kIo5mKya+uold+PAJ9kVrRy1UOXP0jDol4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSWWCmcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSWWCmcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C610C19421;
	Wed,  8 Apr 2026 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673139;
	bh=7v+uiWUVnCNKuiLB5op0U9IoqH22caWB8ctZRCY91dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSWWCmcIZZgOV1aWPxQeuLb6/Hv1LrxB4IMOgXVDlA/pz0wkKXtPczVjs3UWY03++
	 0bgY1dj8c5Sjs67La1ugnjoEpQvhU0jtd+YCwlVDz/uo1Lv8LsMPt7+w8vgwXUnMRW
	 PVs9Sl9nQed6PeRNTfUicujcVY3jZACAxY1um68I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/277] hwmon: (tps53679) Fix array access with zero-length block read
Date: Wed,  8 Apr 2026 20:01:34 +0200
Message-ID: <20260408175937.944568416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit 0e211f6aaa6a00fd0ee0c1eea5498f168c6725e6 ]

i2c_smbus_read_block_data() can return 0, indicating a zero-length
read. When this happens, tps53679_identify_chip() accesses buf[ret - 1]
which is buf[-1], reading one byte before the buffer on the stack.

Fix by changing the check from "ret < 0" to "ret <= 0", treating a
zero-length read as an error (-EIO), which prevents the out-of-bounds
array access.

Also fix a typo in the adjacent comment: "if present" instead of
duplicate "if".

Fixes: 75ca1e5875fe ("hwmon: (pmbus/tps53679) Add support for TPS53685")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260329170925.34581-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/tps53679.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/tps53679.c b/drivers/hwmon/pmbus/tps53679.c
index ca2bfa25eb04c..3bca543817a60 100644
--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -103,10 +103,10 @@ static int tps53679_identify_chip(struct i2c_client *client,
 	}
 
 	ret = i2c_smbus_read_block_data(client, PMBUS_IC_DEVICE_ID, buf);
-	if (ret < 0)
-		return ret;
+	if (ret <= 0)
+		return ret < 0 ? ret : -EIO;
 
-	/* Adjust length if null terminator if present */
+	/* Adjust length if null terminator is present */
 	buf_len = (buf[ret - 1] != '\x00' ? ret : ret - 1);
 
 	id_len = strlen(id);
-- 
2.53.0



