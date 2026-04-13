Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B30A225A38;
	Mon, 13 Apr 2026 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097816; cv=none; b=ENZVrLTgBIZ74vbeMf4xhxIZ+xtkJmbqBxuzESxcLgdt1ozuRj21WMCI937AvKp/ez0LVETqOHo0NmOSfMwN2A6HxSTKpS9hHIvMnJzwPPClnLgKBl5gyqjuFpOceTtfUt1AdI5Nt5A3oLjxhwuov2fwUhAiUUoAB7DMTDQ1GeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097816; c=relaxed/simple;
	bh=ifEU3FVjuBwTPEP7nRx4zbB8WQxXflBk9yE5k2jXBM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHz0DDX8wNsBMY60qYG3gXzfkHkKfrSTFe95XAC2sjh9o0J1X/ccrgkPOHOK2mCKQM6kti5Z38rzEubOT43v1aigabrzGA7PX3QJJmC2XyENJ9srZlzH/U5ZzGRrSxgL44FVCOizY140isiXZEDaYqrpuJmvGhV91VMkgqzrIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlHmYtS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlHmYtS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A20C2BCAF;
	Mon, 13 Apr 2026 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097816;
	bh=ifEU3FVjuBwTPEP7nRx4zbB8WQxXflBk9yE5k2jXBM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlHmYtS2AEavuYpSEbcvGaOLmWQuAue3Za573ZBVR9PwViDnm1KGbTK5hBYYoWe7X
	 fOMkKTSmSNdDs2HgK6REXbicVgDTZpbIcLdGPpdCD2ze4x4u3YqO0SaKUs1pp9hm5c
	 cnMpW3DxVsYnSH9VvVSrRC6d4WxIn2vz/kvwwLoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 283/570] hwmon: (pmbus/isl68137) Fix unchecked return value and use sysfs_emit()
Date: Mon, 13 Apr 2026 17:56:54 +0200
Message-ID: <20260413155841.092664895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 86259558e422b250aa6aa57163a6d759074573f5 upstream.

isl68137_avs_enable_show_page() uses the return value of
pmbus_read_byte_data() without checking for errors. If the I2C transaction
fails, a negative error code is passed through bitwise operations,
producing incorrect output.

Add an error check to propagate the return value if it is negative.
Additionally, modernize the callback by replacing sprintf()
with sysfs_emit().

Fixes: 038a9c3d1e424 ("hwmon: (pmbus/isl68137) Add driver for Intersil ISL68137 PWM Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260318193952.47908-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/isl68137.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -80,8 +80,11 @@ static ssize_t isl68137_avs_enable_show_
 {
 	int val = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
 
-	return sprintf(buf, "%d\n",
-		       (val & ISL68137_VOUT_AVS) == ISL68137_VOUT_AVS ? 1 : 0);
+	if (val < 0)
+		return val;
+
+	return sysfs_emit(buf, "%d\n",
+			   (val & ISL68137_VOUT_AVS) == ISL68137_VOUT_AVS);
 }
 
 static ssize_t isl68137_avs_enable_store_page(struct i2c_client *client,


