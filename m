Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11835C6AC;
	Tue, 21 Jul 2026 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673884; cv=none; b=t9nWsKXTWfWACYGZEgOaG7CnvGXIN29HwpftsDs8L07sVy9RSMJ030iRP7WXHarPA2P6Uerae7Xl3sSDGKgTi8MRc8q6xXgNPW5Gsb/PefiPGLZsBRY9SrOGXUHnxW9vjcuagAWCSB1qRo0PBs9F5MpI5YzaAtLeJua+PzWFOxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673884; c=relaxed/simple;
	bh=Nx39/iF8ifpDcGz21+WykZ3+5ZxwuSAkPDC61CreUwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSa+qHYM8o7YtkYY0EphMxcgCzLpLfXhI/0HmMtZUAvFpb9sfdx+noZaxrdqOAvxQF9URSSLVJkBYBMQYTqKX7ZV3xupWbomwS9dRC7oZPSm/oimW/OoyRCemfk29nro3CApsjTBm8/U/Ol9Eo/gmD/l5BRnR5alVxh6Bn4bIuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QS1XF3UN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QS1XF3UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0911F000E9;
	Tue, 21 Jul 2026 22:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673882;
	bh=a+tqfQd1NXJTWtSAbV6LVS4P5C/cO1RzSLOFkago3gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS1XF3UNB4vuRJIKl0fH8KIn4N4EAFkVoil1E9auuS2JcIYKjYYcpLt3i3ytacM4W
	 q02ngKTPqxYzQFG23/j9xMaMHZDFRXl7Wms5uFd6Q0vq4jAL+BBrT6XwTReMX+ypus
	 tag38W5UdGj0LU38YJXOEVoTsWV8ixn2hrP7kO04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/699] i3c: master: Prevent reuse of dynamic address on device add failure
Date: Tue, 21 Jul 2026 17:21:30 +0200
Message-ID: <20260721152403.159156785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b3ba8383da4d0cff15810e32ea785eceb0a80813 ]

i3c_master_add_i3c_dev_locked() is called after a device has already
been assigned a dynamic address.  If the function fails, the address
remains marked as free and may be reallocated to another device,
leading to address conflicts on the bus.

Ensure the address is not marked as free on failure, by updating the
address slot state to prevent the address from being re-used.

Emit an error message to inform of the failure.

Opportunistically remove the !master check because it is impossible.

Note, directly resetting the device's dynamic address is no longer
an option, since Direct RSTDAA was deprecated from I3C starting from
version 1.1 and v1.1 (or later) target devices are meant to NACK it.

Fixes: 3a379bbcea0af ("i3c: Add core I3C infrastructure")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260612080107.11606-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index f3fc7fe3779fe9..22a95b30d5abad 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1902,12 +1902,11 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 	bool enable_ibi = false;
 	int ret;
 
-	if (!master)
-		return -EINVAL;
-
 	newdev = i3c_master_alloc_i3c_dev(master, &info);
-	if (IS_ERR(newdev))
-		return PTR_ERR(newdev);
+	if (IS_ERR(newdev)) {
+		ret = PTR_ERR(newdev);
+		goto err_prevent_addr_reuse;
+	}
 
 	ret = i3c_master_attach_i3c_dev(master, newdev);
 	if (ret)
@@ -2028,6 +2027,16 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 err_free_dev:
 	i3c_master_free_i3c_dev(newdev);
 
+err_prevent_addr_reuse:
+	/*
+	 * Although the device has not been added, the address has been
+	 * assigned. Prevent the address from being used again.
+	 */
+	if (i3c_bus_get_addr_slot_status(&master->bus, addr) == I3C_ADDR_SLOT_FREE)
+		i3c_bus_set_addr_slot_status(&master->bus, addr, I3C_ADDR_SLOT_I3C_DEV);
+
+	dev_err(&master->dev, "Failed to add I3C device at address %u, error %d\n", addr, ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(i3c_master_add_i3c_dev_locked);
-- 
2.53.0



