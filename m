Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580EA24677F;
	Thu, 28 May 2026 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998480; cv=none; b=F7/3C2+P49eKLt1kSArxU6O/uUqYeJZ8vXA2OMGxvqajoB9rcP+VeJ9uqV12fxdbdIz6AwKWs9ctSyrIb8UpxT7HG8cnFT7sDCZk9jOvONksh6Ujvo+QnnEpkcyLKdR4IQuPAQFaJCGkFDjjTSuu/OCpmjDhZg0wy7qryN0a8CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998480; c=relaxed/simple;
	bh=jIy/dymjatvXnlNnUGg7yGA6Du9r9JhOJ8b5fyxhwug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyYYPQjN3/WdrtadBjVmO3/cN6UNvO5KoYPzXleXSJXAGy4I4KiWmLiCfCT2Rx5hTq9jLP83iH3vXbSuNB0l6JnOOg2xeRBx8w6b//qxVROWOb4jCmKRfpkHwxigvHPZkPq8xKeQ72asILr+Ty3I9W8F86T7vETOCqap/09Hqqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrHFZ2pB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrHFZ2pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B600B1F000E9;
	Thu, 28 May 2026 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998479;
	bh=mlgyvslLOhOb+MBkfMZSc9RpKmexfaDhkrvo3hZWts8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrHFZ2pB+KBLBMFUOWTh9EN14m2j2Acx3RLFpr79JomCxMeYhscnWXvGmG4BP8V5d
	 DGd+9vz0bu+8wRrDIdwIbDWUBG+WFCJ3e/8Cx1BNQmPefZUUbKnc6q1KpHYtfokmb1
	 u0VdB5cieftcDdus94q03/1EycXp/e0aexYBdJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 187/461] firmware: arm_ffa: Check for NULL FF-A ID table while driver registration
Date: Thu, 28 May 2026 21:45:16 +0200
Message-ID: <20260528194652.489272355@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 9576862d89c40..601c3418e0d92 100644
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



