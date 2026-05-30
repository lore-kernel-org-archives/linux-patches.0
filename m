Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28E3AB285;
	Sat, 30 May 2026 18:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165012; cv=none; b=mAoBJnHhyOaRHyPVxxV87Ced9QGO/d/UppMopwjrV73xgdLz6KJDdyec8isiMS0+hS2ey5QZatUq/9J8D/+RFojhFzj8yvop5nEgnVsj4KiW5GR3TK0/VD3tVMOb9rfFqh6ZA2tG/xv6bP5jVYQ/zUge7OT+SG+bvvgbN5nW5P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165012; c=relaxed/simple;
	bh=zr9zFGWn7Wu4FMcjWsAyMN2/XQOpf4DaOOZOrxpidMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BS0K0SIG+JTLTGwry6pTh1P0ts7WczQtN62hxv6SVuKXdDXa0IqQG8ZZJmnIPS+VAyDgK1geLBueYbq8vV5OlPeNNkhHQZVED2Y0LlHD3IHTXoDtLgpObq0YBrVoOfzLRZhVghtXOn3rHHFNRt8kTLvvggtd/cqr0DWkzmcu+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byh5Gh1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byh5Gh1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001211F00893;
	Sat, 30 May 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165011;
	bh=VDPzRJRAZrmvR2jojwv53uBWd9wWBSg3SYHbvcm3wsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byh5Gh1P5nXWincxilJJFaWuYGWvxz9wA/RHWzPeiPjXtpG+uro1DJRuDZ8oBVPGJ
	 o6ckjWikQci/oEjmnYL6Lj6Tq8Cp2gwYrDIejxNEZ9qOr5ACmKjPI7eymDDvA1PPDV
	 m99ltP9vflhrZExI9N4ehFCZDGmPJvRt03UCQhDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 725/776] firmware: arm_ffa: Check for NULL FF-A ID table while driver registration
Date: Sat, 30 May 2026 18:07:19 +0200
Message-ID: <20260530160258.558804179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27820a59ce25e..93962334b45cc 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -24,6 +24,8 @@ static int ffa_device_match(struct device *dev, struct device_driver *drv)
 
 	id_table = to_ffa_driver(drv)->id_table;
 	ffa_dev = to_ffa_dev(dev);
+	if (!id_table)
+		return 0;
 
 	while (!uuid_is_null(&id_table->uuid)) {
 		/*
@@ -107,7 +109,7 @@ int ffa_driver_register(struct ffa_driver *driver, struct module *owner,
 {
 	int ret;
 
-	if (!driver->probe)
+	if (!driver->probe || !driver->id_table)
 		return -EINVAL;
 
 	driver->driver.bus = &ffa_bus_type;
-- 
2.53.0



