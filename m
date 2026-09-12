Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FAF3F1ACF;
	Sat, 12 Sep 2026 07:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197912; cv=none; b=ZG5asUc/DTVwL+JaK3FqoKQh4tBzKQOZGfBQXBRB1MdNeoRNfFAsHnUsmDXkfbQFaY85zNM3vuQLPZfsp/qzvslyhHFTEAA6Q2swqY1sxwP2BXV/q0tpP38z6xPtnNBIPaXu9OupxfzME02C9JayVSSKT7yiNbmmmgU3DxuY6Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197912; c=relaxed/simple;
	bh=s+N0geqbcPFSGOCUYjrNi06hVL0FxQxjnjnraILlaBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1xU9H+3Iv1QyYcY2Pd+7kdGEUYwl7Doo3RZdRnHoiWsL8rAzCuCERlRZMi5QTmQw7dk+3wyhOeDJgXrlIFgZGiAsLwjaXJs2PzM/gPwyECAgIOAegkqmwmpo/9WIpakP5Md+FZYLvloSsv5VPL9iFh/IWpPN6vkx6+D//oQIug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whYG0JEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whYG0JEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA511F00893;
	Sat, 12 Sep 2026 07:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197909;
	bh=XQHkf0TeTGU2HU2IWSGrpUdvnJfWfgFBzeplaEu7Iis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whYG0JEgnOYC6XfwBMU2qY1XQImF52XO4+4STlcoSJzBv1ke/mB/kwvX4MnUVDjJB
	 NUX7GZZkDbJxi0bHKmCQqzJosuAAl/xMpV0lWXEKbx/3eEC2rWxGNtta3tIXexrTgq
	 CQ2cpY9SHtglizJq/1Ofy14W83iTvAuy7fiMLIrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0270/1815] staging: media: ipu7: fix pm_runtime refcount leak in ipu7_resume()
Date: Sat, 12 Sep 2026 08:33:40 +0200
Message-ID: <20260912065655.308220099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit b298b80814dd0fc3cb1c8c0e0082fc14fdb5fecf ]

ipu7_resume() calls pm_runtime_get_sync() before resuming the device.
If the runtime PM resume fails, the usage count remains incremented, but
the error path returns without dropping the reference.

Use pm_runtime_resume_and_get() instead, which balances the usage count
on failure and avoids the leak. Keep returning 0 on error, as resume
callbacks should not propagate failures to the PM core, matching the
behaviour of the ipu6 driver.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index 056af3a075075..48a35bda42370 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2702,7 +2702,7 @@ static int ipu7_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "IPC reset protocol failed!\n");
 
-	ret = pm_runtime_get_sync(&isp->psys->auxdev.dev);
+	ret = pm_runtime_resume_and_get(&isp->psys->auxdev.dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to get runtime PM\n");
 		return 0;
-- 
2.53.0



