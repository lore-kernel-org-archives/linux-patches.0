Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEEC3F9298;
	Mon, 17 Aug 2026 13:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974052; cv=none; b=jNVrpSCgg+sOZZqZOZAwkkxtjKx0DYu1G6IK7yLTUVC7exrQFoZIcQN4sozVpG8blfdCKO78SNjzV/jFKaxBtlJnCmpAHCVOS3r3jeblhRZHFC/WoAzDcWdqx+URdjjlYG7ZWqAuX3IP2PGMi1ZX2WZi+3lY1iNMunXW8es5u4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974052; c=relaxed/simple;
	bh=7QvPVNyc0EdrvQGGsOC97gvNzHEjDlMM6B30njIbrTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG640/cUhhbZJnWnd0tBCghNsSEYqBt3RoldeY0lAiYmgxhXGN8wpZSjKIcC8Nmuo5we09LedczthkR9VFAAsCsvnizz1et2zVhl3CoHClQu9UpcK5Q80kaG3md86FBCalCEweufnv/VGAAGxEU5sHTY9wQRmhArVczHS9f/JEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbJJRHYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbJJRHYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9852E1F00A3A;
	Mon, 17 Aug 2026 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974043;
	bh=LMSS+82Fq9UjsxQmDdZgDFOpNM6fnidxdVLxxf8CsUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbJJRHYi9BwwATkTYt4EO5hJV6bv8Z0zDbRxwNoE14KrLL84XbRUTc4n6gCRGeq6j
	 08gxcVLfow8HeLoCOIx08VEU5pAh3WMdFWqItwS07DkTK0lMPqkbxZ4ZtvOzsNs6ky
	 c9MbA2H5ioyJZwMcG8DQ0Sip25CsoGgjx9+2p8NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 068/271] hwmon: (pmbus/core) Avoid race condition during probe
Date: Mon, 17 Aug 2026 15:29:53 +0200
Message-ID: <20260817132539.535635094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 71638a456852a18a4578f52d51926ba1d223053b ]

pmbus_write_smbalert_mask() is not guarded, which can cause race conditions
with concurrent sysfs attribute accesses.

Similar, PMBus accesses in pmbus_init_debugfs() are not guarded, also
resulting in potential race conditions.

Add guards to both functions to prevent the races.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 221819ca4c36e ("hwmon: (pmbus/core) Add interrupt support")
Fixes: 1e069dfd96dfe ("hwmon: (pmbus) Add debugfs for status registers")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 5567d37f13fe2..095e128709af4 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3427,6 +3427,8 @@ static int pmbus_write_smbalert_mask(struct i2c_client *client, u8 page, u8 reg,
 {
 	int ret;
 
+	guard(pmbus_lock)(client);
+
 	ret = _pmbus_write_word_data(client, page, PMBUS_SMBALERT_MASK, reg | (val << 8));
 
 	/*
@@ -3662,6 +3664,8 @@ static void pmbus_init_debugfs(struct i2c_client *client,
 	if (!entries)
 		return;
 
+	guard(pmbus_lock)(client);
+
 	/*
 	 * Add device-specific entries.
 	 * Please note that the PMBUS standard allows all registers to be
-- 
2.53.0



