Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8972426D26;
	Tue, 31 Mar 2026 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975262; cv=none; b=DhrkK+IlfjZ3R21ht6Xib3kbvMFolPtAXikmAtdrMwQ3aSd/MXE+0cBNTfRVY4m6nqWR/qzTO2LR3FEKylp18Cu2Hk+oQFiMzA6ty5ebQO/qkEi3SmcxUbnkBxGhn14sx63zS2kGUN4MlxPn1Bm+agnJnsKl8UYhvU/lHAGaXKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975262; c=relaxed/simple;
	bh=Dea2W5bTg+3QmNJ/gVpH/uQY4zX1cWX6RjkADMUHgto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pce7quyqZ9VqDqpqQn8n3/cmdO2D45JzrGISozc1r043ZGP/P4r6YxAwTTF6IPynEVvF3gudUbKRXe5hPdiYD/Ao0nJgPPEVPRj4+10wTRBGhpiu0jjNl6PrGfUicKpP84N28eD/fnU52T9BdtGRooBszkp4UlsUT7LnJRgxbB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnJ+ldLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnJ+ldLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBACC19423;
	Tue, 31 Mar 2026 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975262;
	bh=Dea2W5bTg+3QmNJ/gVpH/uQY4zX1cWX6RjkADMUHgto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnJ+ldLQWoiMDeWDS3Gog3ith2zv1Zy5NNNvEPD0WMrnMcFBnNXmCu+g1damnz0SM
	 plQAKbcMxUu/HldbcuHvHaIhpF7H97gvYCs0Bg7TVwYZSRlyY5f1Izw12igS/40ecg
	 M8WhIG3ppFv/9mOhlocwUbFhMs8yBiUXKIKycf7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.19 225/342] hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes
Date: Tue, 31 Mar 2026 18:20:58 +0200
Message-ID: <20260331161807.247726441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 3075a3951f7708da5a8ab47b0b7d068a32f69e58 upstream.

The custom avs0_enable and avs1_enable sysfs attributes access PMBus
registers through the exported API helpers (pmbus_read_byte_data,
pmbus_read_word_data, pmbus_write_word_data, pmbus_update_byte_data)
without holding the PMBus update_lock mutex. These exported helpers do
not acquire the mutex internally, unlike the core's internal callers
which hold the lock before invoking them.

The store callback is especially vulnerable: it performs a multi-step
read-modify-write sequence (read VOUT_COMMAND, write VOUT_COMMAND, then
update OPERATION) where concurrent access from another thread could
interleave and corrupt the register state.

Add pmbus_lock_interruptible()/pmbus_unlock() around both the show and
store callbacks to serialize PMBus register access with the rest of the
driver.

Fixes: 038a9c3d1e424 ("hwmon: (pmbus/isl68137) Add driver for Intersil ISL68137 PWM Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260319173055.125271-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/isl68137.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -96,7 +96,15 @@ static ssize_t isl68137_avs_enable_show_
 					     int page,
 					     char *buf)
 {
-	int val = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+	int val;
+
+	val = pmbus_lock_interruptible(client);
+	if (val)
+		return val;
+
+	val = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+
+	pmbus_unlock(client);
 
 	if (val < 0)
 		return val;
@@ -118,6 +126,10 @@ static ssize_t isl68137_avs_enable_store
 
 	op_val = result ? ISL68137_VOUT_AVS : 0;
 
+	rc = pmbus_lock_interruptible(client);
+	if (rc)
+		return rc;
+
 	/*
 	 * Writes to VOUT setpoint over AVSBus will persist after the VRM is
 	 * switched to PMBus control. Switching back to AVSBus control
@@ -129,17 +141,20 @@ static ssize_t isl68137_avs_enable_store
 		rc = pmbus_read_word_data(client, page, 0xff,
 					  PMBUS_VOUT_COMMAND);
 		if (rc < 0)
-			return rc;
+			goto unlock;
 
 		rc = pmbus_write_word_data(client, page, PMBUS_VOUT_COMMAND,
 					   rc);
 		if (rc < 0)
-			return rc;
+			goto unlock;
 	}
 
 	rc = pmbus_update_byte_data(client, page, PMBUS_OPERATION,
 				    ISL68137_VOUT_AVS, op_val);
 
+unlock:
+	pmbus_unlock(client);
+
 	return (rc < 0) ? rc : count;
 }
 


