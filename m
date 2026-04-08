Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DB7B67E;
	Wed,  8 Apr 2026 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672349; cv=none; b=bj3QC6RfFAjY+X+udRujJh0sL5KiW3KS7SCjOXf6j0IKdy2y1hGppaCpWgPHum2y2Knq+RKmAGpoxRNub7rlHttmnzoQTjrGhq5F6GvkDnXHmMYFS6lKQrB9pkmn+obOTUXsalQGylyjVJX+qRUE/Mg6h0NROwsApdEgzlVJIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672349; c=relaxed/simple;
	bh=4k6KRG+cUobYdv34MuRGwzUNpFQfCaG8G5SfY2rhGAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mas3pvoXtrKUB1KWWGKZs8wTtoZnn3EImo9aylNKGLj8PA+U1DP/NMltRq3LS3FTXIysuAAj5Z/8plpEZkhTeLfV7g9yulwugQgDp8uqt1gQNYld8giC8u7RYT20ZzJD3OePKw8xRJZ2M4u98UNOOOF5cOz/ZM6gvaPJTGu3iuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+BZ15Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+BZ15Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B08C19421;
	Wed,  8 Apr 2026 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672348;
	bh=4k6KRG+cUobYdv34MuRGwzUNpFQfCaG8G5SfY2rhGAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+BZ15ErLu7+yHe1/H74y0KblKKwRncf2FPAgnSKPd+gWrW0ndlAkUhMxqzHRkvau
	 o6DdC1wYUTMsW9dpXZzhtatWzHso1ILBUkWWPv5m1cHk/tJyhHzNFYtClkq9xuB7kK
	 P2gaxY6O4kxEgbTJCNo1nBXbhjPq4Fm5AsRZVzJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/312] hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes
Date: Wed,  8 Apr 2026 20:03:22 +0200
Message-ID: <20260408175944.402460955@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit 3075a3951f7708da5a8ab47b0b7d068a32f69e58 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/isl68137.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -78,7 +78,15 @@ static ssize_t isl68137_avs_enable_show_
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
@@ -100,6 +108,10 @@ static ssize_t isl68137_avs_enable_store
 
 	op_val = result ? ISL68137_VOUT_AVS : 0;
 
+	rc = pmbus_lock_interruptible(client);
+	if (rc)
+		return rc;
+
 	/*
 	 * Writes to VOUT setpoint over AVSBus will persist after the VRM is
 	 * switched to PMBus control. Switching back to AVSBus control
@@ -111,17 +123,20 @@ static ssize_t isl68137_avs_enable_store
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
 


