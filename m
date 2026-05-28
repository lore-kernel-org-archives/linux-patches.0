Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F162F9D85;
	Thu, 28 May 2026 20:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001358; cv=none; b=AkRIrHs2Bvhei1Vm10oazLUgt0V6amfqb1RcInuQZ6ec6egjU2S/DCBsmG9pr9UF3FYyGWSegKHNJqiHBBXgH9dIHv+StfdZfwaBVIdMhDq0d8kTF/e0Ck1lnfaVxg1yEE5HsVPEb1O/XwPLUtlxs6oClC/wgHhG0YCK41De/fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001358; c=relaxed/simple;
	bh=/GmQOk1jBYhOvsoge1CT5YWWO4aT1akMENOyrfgYRto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aytrIKPopzOo4NSNbHRIiWXfnOKR7GOhb4F5+fUysuUWDp+9qENfAXgHaqWx4rCjuXV217bBFFx1j7M3uZsLWYezWQlqZSUcAo1cJiQ+riljLNUHUDRzto8sf3sz2E/gPHy7P7lwkDgP8X+eAGt3j/M08e7Rzw3cHFS4oFKsj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxgY/BgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxgY/BgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48BD1F000E9;
	Thu, 28 May 2026 20:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001357;
	bh=bfoc6Dc0K/oSC5kIOZFYcC2+o0z7DEMRjiCuIZVUSmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxgY/BgL24rsHJiUUHv6CWGysNOocOropwratW14OHhKAzX0RNKfLKNKgVuCTyFcG
	 dTMYAD9ZC2+g2QJSJ0gIuOFbi/DV1yvWIjYeTYLzFOvOOtenGMuKkW4MGyM4FwODKW
	 fhNBy7U6uw/v2SFBPMDCIrF1h0xkNc4+plf0PlPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/186] firmware: arm_ffa: Check for NULL FF-A ID table while driver registration
Date: Thu, 28 May 2026 21:49:38 +0200
Message-ID: <20260528194931.581046137@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index d885e1381072a..31e61602e7702 100644
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



