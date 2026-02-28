Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D11C421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301165; cv=none; b=AmE0OP77WFQRMle8Ky3r5j8tMjcAM1Cz4oiJpGgEZSJ06eK1+CuNT8SuiQhc/PDZfGKqmWxaC4Im0Hph5RPj4vIgooI+m4mWeXoVIEYG6fJKzMvys3NtpO7c1WUQGaV7uT0i21UYpLDnFYs/V65LEsNZ0aCPpR/s8V2/r2KDA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301165; c=relaxed/simple;
	bh=QlgXHxLPUtH2sx/OHkgS6SP38Ze9WrPDAlWUKD10jUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6dfEo1PRqvnaf5S8Iyf4B2l9Wonqi2evc8yvmfSvMisNUPBK8q3+bhVhTUnLkUd/FxOQYP1gxS1VifDyt3nz/58XHyWfDuZf+g96YDnwHwVM+XOYRK08QxrVk920MYLCT0vaM2j1GtYL+a0vRV2ymGSVmU6ej1eFaQ/m33Wa34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Celnbbym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Celnbbym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45218C19423;
	Sat, 28 Feb 2026 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301164;
	bh=QlgXHxLPUtH2sx/OHkgS6SP38Ze9WrPDAlWUKD10jUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CelnbbymAD5xM30Z01za1P6PJuaTleJaq1dcy/nI/ZsGf9qZckb8LJE51rpZdtk+5
	 aD/PGxZ+4F4EZwZA9yl6leYRkaRkREDRGWj67tMDOI6PG8ZSAXxLUKCQWzYTuPxXNB
	 vRpCHQe+9GU9+A4pUMSzbPe+hhWT2yCG0s4zrHfHZBNo6IYXOvwk0DCms8Iwi3GchT
	 0ARhrrlgzl6qLG1qommP4M2xiy6BrBfGzl7xCnJ515u7fiikaXtQyD5Pa6BeLoSWl8
	 dBrjcKh8RoyTNL0WbJF2Q4apWIdrKdlbCiWgvczAzhfHKEYcO+JIfHNtb/FagevDvL
	 etSg0BLqOSAkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Navaneeth K <knavaneeth786@gmail.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 330/752] most: core: fix resource leak in most_register_interface error paths
Date: Sat, 28 Feb 2026 12:40:41 -0500
Message-ID: <20260228174750.1542406-330-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Navaneeth K <knavaneeth786@gmail.com>

[ Upstream commit 1f4c9d8a1021281750c6cda126d6f8a40cc24e71 ]

The function most_register_interface() did not correctly release resources
if it failed early (before registering the device). In these cases, it
returned an error code immediately, leaking the memory allocated for the
interface.

Fix this by initializing the device early via device_initialize() and
calling put_device() on all error paths.

The most_register_interface() is expected to call put_device() on
error which frees the resources allocated in the caller. The
put_device() either calls release_mdev() or dim2_release(),
depending on the caller.

Switch to using device_add() instead of device_register() to handle
the split initialization.

Acked-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20251127165337.19172-1-knavaneeth786@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/most/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/most/core.c b/drivers/most/core.c
index da319d108ea1d..6277e6702ca8c 100644
--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -1286,15 +1286,19 @@ int most_register_interface(struct most_interface *iface)
 	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS))
 		return -EINVAL;
 
+	device_initialize(iface->dev);
+
 	id = ida_alloc(&mdev_id, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(iface->dev, "Failed to allocate device ID\n");
+		put_device(iface->dev);
 		return id;
 	}
 
 	iface->p = kzalloc(sizeof(*iface->p), GFP_KERNEL);
 	if (!iface->p) {
 		ida_free(&mdev_id, id);
+		put_device(iface->dev);
 		return -ENOMEM;
 	}
 
@@ -1304,7 +1308,7 @@ int most_register_interface(struct most_interface *iface)
 	iface->dev->bus = &mostbus;
 	iface->dev->groups = interface_attr_groups;
 	dev_set_drvdata(iface->dev, iface);
-	if (device_register(iface->dev)) {
+	if (device_add(iface->dev)) {
 		dev_err(iface->dev, "Failed to register interface device\n");
 		kfree(iface->p);
 		put_device(iface->dev);
-- 
2.51.0

