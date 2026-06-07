Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB161E98E3;
	Sun,  7 Jun 2026 11:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830192; cv=none; b=eEa5kVsX+EeBi1sFYQITbrpRliVvbywcMSe/BQz17YyNIya8jnNTE3no/mluTrk+jzVdN2SgaSliy9lgPeRlQ5M/8AIKbHt0Ii6MZYk88G1OHdPFJkZs+xbJ6UruYfIBNvl2FKBy+zEUZ4vKmaSYpoWzvFxPyJU4JNPsQow8qVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830192; c=relaxed/simple;
	bh=JJD/DI1szPy+lVnc7EF8fHmpy35pQEh5pzKs9q3qYp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stVspBOZ1yX6SVRvWZHQvqBEczxgI3DPR/hjMG9OGZZnVSnWVr6BkNxPiDPwb0ee8owAT/DIxDiGCzKgFGZXZV1PT2QHX7brWfs7aj/3Q/8XQktZBB0o1GyweMEfycNMf5Z5Mmuvaige2AAZFLu8E+Exw4LkgLKaX8kDPaMUivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU9sT6If; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU9sT6If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9362E1F00893;
	Sun,  7 Jun 2026 11:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830191;
	bh=eAYEfRIf0cCFbw5PQONhJuhYkkoPf5o4jea/1oMczYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iU9sT6IfIfU2gYiPODwYVpGY9wPXaLWhFqhT0I8dSGyqdaSMV2mheI/49KL9+mNnd
	 vcRf31VycAd50Ln9VHosp89Es8Li2wJIP8321LmGCVUitBymGvzHE9qkgFfxNCaK5U
	 2D5Z75qRP5i/C5rH3267NSoEZXz9coToIqoMZers=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/307] hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pmbus_lock
Date: Sun,  7 Jun 2026 12:01:39 +0200
Message-ID: <20260607095738.844064996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

[ Upstream commit 4e4af55aaca7f6d7673d5f9889ad0529db86a048 ]

adm1266_state_read() backs the sequencer_state debugfs entry and
issues an i2c_smbus_read_word_data(client, ADM1266_READ_STATE)
against the device without taking pmbus_lock.  pmbus_core holds
pmbus_lock around its own multi-transaction sequences (notably the
"set PAGE, then read paged register" pattern used by hwmon
attributes), so an unlocked debugfs reader can land between a PAGE
write and the subsequent paged read in another thread.  READ_STATE
itself is not paged, so it cannot corrupt PAGE in flight, but the
same defensive serialisation that applies to the GPIO accessors
applies here: any direct device access from outside pmbus_core
should be ordered with respect to pmbus_core's own.

Take pmbus_lock at the top of adm1266_state_read() via the
scope-based guard().

Fixes: ed1ff457e187 ("hwmon: (pmbus/adm1266) add debugfs for states")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-8-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ replaced `guard(pmbus_lock)(client)` with manual `pmbus_lock_interruptible()`/`pmbus_unlock()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -328,7 +328,12 @@ static int adm1266_state_read(struct seq
 	struct i2c_client *client = to_i2c_client(dev);
 	int ret;
 
+	ret = pmbus_lock_interruptible(client);
+	if (ret)
+		return ret;
+
 	ret = i2c_smbus_read_word_data(client, ADM1266_READ_STATE);
+	pmbus_unlock(client);
 	if (ret < 0)
 		return ret;
 


