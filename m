Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAB94FE2C9;
	Wed, 30 Sep 2026 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784350; cv=none; b=g//wwOasF3kqdKOM/smYyKTKQo8LZNTBYY3v0Y3l+8w903PTrrgEkPzQVaqvNkxXCoKBjYLwk3CsFQstwa7EZ2PPFuDLs44XOqzlKWtU6uiiJEJ1gWCVgmEnHIpDgxRttmJBAQ7FUP7Cz1FgT/g4quJZdf6+fk7iG4tcVeMxHCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784350; c=relaxed/simple;
	bh=sHh8euqMtgZtTXFhq2szpsKFAIzAUlJxhfg2gxQPmaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iECIeXG1VaQTI56vQ4n5fWdrckcCA8WRG/bHJ0T3Uoj29gZiCUF3X3yeQwSo0KY5ksvqk5q13xHmMMCF3vIwotmB8pA9cUXyyf0I2OgOEaQodFZz9LL/S5EskYS2dDHquFFEk3eDBqY0o94+BqSdOyWLpGpq1F+yro9phxRq4j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOqPbNTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOqPbNTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50D11F000FF;
	Wed, 30 Sep 2026 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784346;
	bh=sKw4q0WQ5uoJCyl5LR/nw4n80LI32gK5AqQZnPsy+xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOqPbNTPK/N6A7MtYBnUCgiGndUa2nRzg1sBqyFxM3dIOaFmWpK0z3hZ7QIc3C6De
	 vbNzZndnTFqKvlSKuESCEXS3xQNMe7KcWIrsMgMhjJKVmUcbT2JwDuV+QY3+vp+9PN
	 1g/EyQsxbB8UXVHb1DKgnxdHG7SV7bySXm0Fmy54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shayderrr <darknessshayder@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/982] host1x: bus: Fix missing ops null check in error teardown
Date: Wed, 30 Sep 2026 17:14:12 +0200
Message-ID: <20260930152419.310439653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: shayderrr <darknessshayder@gmail.com>

[ Upstream commit 71d25f668bc5c0f36ea843462e12307dea45aaa3 ]

In host1x_device_init(), the error teardown paths do not check
client->ops before dereferencing it, unlike the forward init paths
which correctly guard with 'client->ops &&'. This can result in a
NULL pointer dereference if client->ops is NULL.

Fix by adding the missing client->ops check in both the teardown
and teardown_late labels.

Signed-off-by: shayderrr <darknessshayder@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260517170456.84927-1-darknessshayder@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 8c819af1bce69..751ef2f3342cd 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -226,7 +226,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->exit)
+		if (client->ops && client->ops->exit)
 			client->ops->exit(client);
 
 	/* reset client to end of list for late teardown */
@@ -234,7 +234,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown_late:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->late_exit)
+		if (client->ops && client->ops->late_exit)
 			client->ops->late_exit(client);
 
 	mutex_unlock(&device->clients_lock);
-- 
2.53.0



