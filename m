Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4E82D9787;
	Thu, 28 May 2026 20:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999754; cv=none; b=fOpYR+1oKBhYTNNs9AmA+P2ofB/7Ir0k1JBYdYdNNLxxlAj2cJKKHp95Ay2gd2VbgKGPTGGzW4jsUDr1XCuw8xuMxiDg7PoFt+YQRBHjfLERcSpBcdsO8ooHcxNMl/4IzjMp9adzknA/0M30gPjE4eJBspYIJGdiWeg6H9koKGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999754; c=relaxed/simple;
	bh=VtojNSpozyzKhxHpKi3hK8aEaeypMnuxZBldLXWNLhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afn7ebZ1+y0fx3DBRxS754ur++ueeYdrTJ6eBD7pv8OXb2alKpbEmtBcyXxzmKgDVm974bSOHJBgpReuVhkSbWV3W5tYSlkku9Xb1px7gtpk461A7h9d0Q05K+spUOGhQ8Kvw8L12HDtNbRB3ugf6vZjrOxBypIrTyoVBSrYUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTn74d0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTn74d0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B51F000E9;
	Thu, 28 May 2026 20:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999753;
	bh=SZFNBVKq6ithVc3FWKftVc6H7pt5dmmcOm1P/QPoVug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTn74d0a5IVJg7tRZXaIftYPxzhxYkm1dUh7HT9GW0AMejbwS3Kwbyk8BFyBQuLv4
	 THlzY8JQmdlgPwdCHBqWPLKn8HU1TEHsXUbE6yEh3OeSGWS7HQADox6DRDmOHlDG/L
	 kDsp7ntsssut1SvQBjkbe3Lb7NbRvukwFbIdIzYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/377] firmware: arm_ffa: Check for NULL FF-A ID table while driver registration
Date: Thu, 28 May 2026 21:46:57 +0200
Message-ID: <20260528194643.604946644@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 0a5e695095c557d2380131b613dea4e8d90371be ]

The bus match callback assumes that every FF-A driver provides an
id_table and dereferences it unconditionally. Enforce that contract at
registration time so a buggy client driver cannot crash the bus during
match.

Fixes: 92743071464f ("firmware: arm_ffa: Ensure drivers provide a probe function")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-1-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index 50bfe56c755e9..6779923e35c55 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -26,6 +26,8 @@ static int ffa_device_match(struct device *dev, const struct device_driver *drv)
 
 	id_table = to_ffa_driver(drv)->id_table;
 	ffa_dev = to_ffa_dev(dev);
+	if (!id_table)
+		return 0;
 
 	while (!uuid_is_null(&id_table->uuid)) {
 		/*
@@ -123,7 +125,7 @@ int ffa_driver_register(struct ffa_driver *driver, struct module *owner,
 {
 	int ret;
 
-	if (!driver->probe)
+	if (!driver->probe || !driver->id_table)
 		return -EINVAL;
 
 	driver->driver.bus = &ffa_bus_type;
-- 
2.53.0



