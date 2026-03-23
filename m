Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1B3C145;
	Mon, 23 Mar 2026 14:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274976; cv=none; b=EMxfMy7Mg3tN60+4x5Fv8IpsPtREhfuZadAJbvlwRMoaeOGHv48hdIq0I50BHLCQCC2z/1apA4vGTIL5p+s1D+iQ144/5NroW5J5vUOClXPiGWa/peJ3L5ZUz/w8z44Zyzkey8ic7cdtm+HRjrGulBPE4IPnIqWDyMJ6D9oqM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274976; c=relaxed/simple;
	bh=6BcDBpZ+6je4hqORrMrey82icHS0YHRqka8KNPUo0xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW8hGZyj83c9NT7pTtgF26Txi5vL/qStRawCJslkAYSVO1M+YqfAGZ8bCk7AQfjbydYxRzyrp7+pnd9FI04EwaryyDFsYxy0LnMtZUDHDI0vtLckHQDjgOZPuJrHGkVW2qmWymAbTFfc9YxB/M76V4B8ZZgJcgcZCSXFNS/8WzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4Wfuq1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4Wfuq1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF9FC4CEF7;
	Mon, 23 Mar 2026 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274976;
	bh=6BcDBpZ+6je4hqORrMrey82icHS0YHRqka8KNPUo0xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4Wfuq1lLTMze+jcHavABRjNF19HZ5EJDl1nXv1Yx3CpzPxOjhYnb6QK/S0mclHBr
	 FIPMUze3sb/+5qbICgW+7HWBnVMvSmGZECiDx62n8BhZFOXyFBPOnSi4sD3t2b4lCq
	 /RDq8GyYP0zsg34EkIRaHP8szaGCo8uz3jyFpZGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 180/212] hwmon: (pmbus/ina233) Add error check for pmbus_read_word_data() return value
Date: Mon, 23 Mar 2026 14:46:41 +0100
Message-ID: <20260323134509.441774434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

commit 32f59301b9898c0ab5e72908556d553e2d481945 upstream.

ina233_read_word_data() uses the return value of pmbus_read_word_data()
directly in a DIV_ROUND_CLOSEST() computation without first checking for
errors. If the underlying I2C transaction fails, a negative error code is
used in the arithmetic, producing a garbage sensor value instead of
propagating the error.

Add the missing error check before using the return value.

Fixes: b64b6cb163f16 ("hwmon: Add driver for TI INA233 Current and Power Monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260317174553.385567-1-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/ina233.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/pmbus/ina233.c b/drivers/hwmon/pmbus/ina233.c
index dde1e1678394..2d8b5a5347ed 100644
--- a/drivers/hwmon/pmbus/ina233.c
+++ b/drivers/hwmon/pmbus/ina233.c
@@ -67,6 +67,8 @@ static int ina233_read_word_data(struct i2c_client *client, int page,
 	switch (reg) {
 	case PMBUS_VIRT_READ_VMON:
 		ret = pmbus_read_word_data(client, 0, 0xff, MFR_READ_VSHUNT);
+		if (ret < 0)
+			return ret;
 
 		/* Adjust returned value to match VIN coefficients */
 		/* VIN: 1.25 mV VSHUNT: 2.5 uV LSB */
-- 
2.53.0



