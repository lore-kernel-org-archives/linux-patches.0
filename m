Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD82D38B7D2;
	Sat, 12 Sep 2026 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208205; cv=none; b=pAriDpS97F5SQ6/Yt9RpdoOmyUXbCvKJ/jSshiJB8cVQFxvEFDm16++Eggu+boZiyy4s0ePgisDCSS7bGq8H52oDS1GoEqUoA4NURHmI/9QegIijLN/o29OJ4SdHQZeWRme2+4GZPGp1x0MXgL6ETDYb/X/uhEemLoyrjgZQLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208205; c=relaxed/simple;
	bh=4Q90H/18GCqUD7tt9OZPxZ0rhcZ3bFQ3gXoJMJaIgbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr+qikAPe+nUGnGXSLcxVnVvE9it0Ui2i9gMkTXfwPIo/hKUIemInCAvccr/DZBq78+e4VY5W2T4fX6wxjvfZpjXBBTG01vlspS1iCIYIIVa3mtYgHQWKqCdlUbjzpjItvh+RcazATOVCf6zKyzT1/+BPuFRXCup85YGNRpjBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz0BsOfS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz0BsOfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076A11F00899;
	Sat, 12 Sep 2026 10:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208197;
	bh=vL/K6icuiWbIvkCQihy+kaBD5b8nu8GuFg0BbtCchV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz0BsOfSBTLafekg0hW4OU6Kp84tFPZIrrgst6yEUkr2oI61pzUIxzVrhoNKVqAL2
	 Oadx2aJsLHM/IvggknfTMXZaV2t87NhhIxd8pz6V5qdrd3lQmWVvTtwlt846XjEMUM
	 XQm0sqfugxxJCXSsl7tK9+oSDNJi7RJ++fgqBoxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0552/1518] firmware: arm_scmi: Unrequest devices if driver registration fails
Date: Sat, 12 Sep 2026 08:45:21 +0200
Message-ID: <20260912065635.926271664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 9f7cd6a62aa754ed6b48cbd5d50de40add1bcc86 ]

scmi_driver_register() requests protocol devices before registering the
driver. If driver_register() fails, those requests remain in the global
IDR and retain pointers to the module's ID table. Once the failed module
load releases that storage, later request matching or SCMI device creation
can dereference the stale pointers.

Unrequest the complete protocol table before returning the registration
failure. At this point table registration succeeded, so every entry is
owned by the current registration attempt.

Fixes: d3cd7c525fd2 ("firmware: arm_scmi: Refactor protocol device creation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260722173521.2184378-2-sudeep.holla@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index dabde487e7420..290047b46d51d 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -398,10 +398,14 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 	driver->driver.mod_name = mod_name;
 
 	retval = driver_register(&driver->driver);
-	if (!retval)
-		pr_debug("Registered new scmi driver %s\n", driver->name);
+	if (retval) {
+		scmi_protocol_table_unregister(driver->id_table);
+		return retval;
+	}
 
-	return retval;
+	pr_debug("Registered new scmi driver %s\n", driver->name);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(scmi_driver_register);
 
-- 
2.53.0



