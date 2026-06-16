Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742EE466B5E;
	Tue, 16 Jun 2026 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630700; cv=none; b=XbHsnLFQvGG2H/jzj6bfgiK+Bj+Z3SzHyqI455fK7S1LSIjbJmAKXdJ6ZGWeL5WJxddynZ+WyUqgCuzG6IIKxC3xqxMw3ij7UzPkQ3JW40P/6SxpVi82ouRj3Jswbi5nE9aZXW5xEAmx+VugHY2lpBSi7y0LbbYKkeDkpgSH7iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630700; c=relaxed/simple;
	bh=11V1qkN9sMXXeeF50Iww6YpMg2EObnwl5QIkE0sphFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxYwWS062f24ALe3plpvIcGgYhFW8t31c6Ls+vjokG2WsE0NnmJsgCMeLbmj3p5V6ETjat8obVeR5u8TtzKST9A04pBj4gOvWBK/vPRFw1OSo+w+tvVYV+6d5nEZxseKTH4chPV0sBZnF9E6foF/MsBBSXKJj4r4IVsRAgVAfNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poPosbMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poPosbMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585CD1F000E9;
	Tue, 16 Jun 2026 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630699;
	bh=uUiVzZ0SLKKeqEvTETC58/2wjIBwJzTOiV2gw4lC3+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poPosbMjUT9No/iGRTRgG0u8T8dDyBND75GUR21NaFmTwgh5weWyo7qkYfZZbrwLj
	 KpNWYnSrGx2M40d6si13urjhKauinZjoZNSKuaEYSilarBUBWprHpJS9NyeiRoiDyn
	 ZiJPz1juRJ90agonyNUQu+Esezmo6xxigGYQjGIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/522] hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pmbus_lock
Date: Tue, 16 Jun 2026 20:23:47 +0530
Message-ID: <20260616145129.604266099@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
[ open-coded `guard(pmbus_lock)(client)` as `pmbus_lock_interruptible()`/`pmbus_unlock()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1266.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index 51e76e4413519e..b212aafae1dc4b 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -356,7 +356,14 @@ static int adm1266_state_read(struct seq_file *s, void *pdata)
 	struct i2c_client *client = to_i2c_client(dev);
 	int ret;
 
+	ret = pmbus_lock_interruptible(client);
+	if (ret)
+		return ret;
+
 	ret = i2c_smbus_read_word_data(client, ADM1266_READ_STATE);
+
+	pmbus_unlock(client);
+
 	if (ret < 0)
 		return ret;
 
-- 
2.53.0



