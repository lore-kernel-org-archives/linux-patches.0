Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA6D30E853;
	Sat, 30 May 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162391; cv=none; b=rUBKBtfjvoOAE44mRXO19s02B1M70oe6OJbs7FG/217SO+9FcEsmM9NwrYurmODoejBHsHBceA/6kk9yftijL78z23+HkZeynUrwGHAGwUcNixbTJb3i/uxtJjraz7lgbhHjX0ql21302SFVi6LfOmErYKmEobxGo5V//ogF60g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162391; c=relaxed/simple;
	bh=skqgQQnuG8dbSYbXvoMke6/jiKA3lTEvrBo7ZdH0JN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W955VMsGO1quXm+d5VCY1cdly02RexGohhPc/co7QR9nnfI3BbenOE6o4VdTFNIiEaGNCeydn/ZRLbiBcbqpZfKtFQkJfB5NdmTY6+CUMDWJerZrV+ZpaksawVyUw+TE+dYPFBjM2gPWWVsFcIX5z92QAPOYXo1otGx59xdpxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpldd44X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpldd44X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF3D1F00893;
	Sat, 30 May 2026 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162390;
	bh=uX/iARVBZEquKCqMdQsK+BkLCf9C7DPeA+KOdNwJDyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpldd44XYY1H8eqBgNNheH3H5CAlqfmxUtZabBvsDpCq8LaB09NqANeU9GKsnC0hm
	 ao1g1/P+783mZPB6n2BdRraSgj+ZMLkdWxYBv07ylZmIlg0VkZvMWXts5m2EyXY9tf
	 oj1ZgsBU11rHV0/NpTW4jT9DqlZaQZY6567grc6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 900/969] firmware: arm_ffa: Check for NULL FF-A ID table while driver registration
Date: Sat, 30 May 2026 18:07:04 +0200
Message-ID: <20260530160325.564236617@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 5bda5d7ade42d..4ef02f0125ab9 100644
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



