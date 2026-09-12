Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364D133F368;
	Sat, 12 Sep 2026 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224021; cv=none; b=eJ5+sa27i0yYNPxAq1J+2Nv7YzuXKtG8s2MR6wZGYby3TJOEz8oj66VGTUQ81TtqKkFOp75HJqeBxyJqsjlLQUP6csVZQUsrA0NC4xqwSoLk9DBb/ayhIIz01iszfZRL3p4QaaY3Do47ugS3b9RHhgRLqhD+KNmgxuKS2jZV8D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224021; c=relaxed/simple;
	bh=s4iBnDcbQqx6ik4hb43uampdEZkiN+JOjDrfZr+Buqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ugssh3nHUSjGz5iA1j2VF7+Mf7GPzy9Kmuf5tqRua8eEche+/Hq0nqGZk2Mnp9RAT2mzehRivYudcyuT73R/EtWtGPlS3Yjd0wXLyMLMrkq4a5z8DlNrjyPLFjz/cOb1dE9dG4L2vSx+iTnn7p1y+Lw2hCDrcT2+FCmpOa1mLr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izfyAMF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izfyAMF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105B11F000FF;
	Sat, 12 Sep 2026 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224019;
	bh=LvW8lWqGxMCKkcdtewWLHEF5Mmw+/q45nkEiqCBZPO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izfyAMF5g5e7dLzvTFfvoTmbfX/wvN5wxq3LJP6e1gdIT4RDVVy7yvZWh4kGFC2vV
	 9MakO8c6N9Dc+Bfb7ABfFs86bl+BC3NL0Xom7rh/1RnUWp0strbcdvl7yleSJbK7YG
	 80CyVBJC4QjObmchT2/ch3Fv4yo2iYyCH7X4esw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0864/1424] firmware: arm_scmi: Unrequest devices if driver registration fails
Date: Sat, 12 Sep 2026 08:54:56 +0200
Message-ID: <20260912065626.667431047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a3c3a3d6581e..8d7f90594ee72 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -305,10 +305,14 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
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



