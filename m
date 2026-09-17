Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238B5158BA;
	Thu, 17 Sep 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664101; cv=none; b=GB+1C70KQLiobttc7qoJZf9H2ruBp33ejHZC4LZ46koc1WUZM0n74vgQVWJkhDDI27fsNtlOx88JrjfFgCm9p9LoIonkcm830rH0cWd4cb7Cjj5f5xxa90dY2V+Pv3fOYRk3TF/2Tz64oquKakol7pTb5iFigu8X2ki73WWV5is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664101; c=relaxed/simple;
	bh=RPGz+AhpEV9rWBSkR762coi9X8KPn21kbBZ8pphg1sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8PJdCecDig8ZY5IGgiOF7TzOSqUIr7LRHsOIydiTdrImRq1b+F6jWH3DE9vzOTwJv8s3bUqvFznJeCiYbhri7SKk8rS/0FjbN7RtpN0tSlTgrYxDyQitU0nNn+aXL9BOUgoeUWMA+qNFFDxtYw62rUBHvqQnvj+t6E1ZxAHPCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QU0J/T4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QU0J/T4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8E61F000FF;
	Thu, 17 Sep 2026 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664099;
	bh=ba1DdJRFZKhSPuwm0QWgnZPHqli2TM3klj209l9s9dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QU0J/T4m7DJVmJxYkyP2dv3kNYNSsfcob8Afg1tdIVJRQp1n/bp6rNQDc1OI8P3u2
	 ssjkHf27gvg/jwo69zJVKng542cw/j07nhbrH88DAb4HMj22orG5DvgylpXb7vdy6P
	 O9b5HUtZGdQNKTgCiXST5wWt9bP9drSX6tzSjwLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shayderrr <darknessshayder@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0252/1250] host1x: bus: Fix missing ops null check in error teardown
Date: Thu, 17 Sep 2026 16:00:47 +0100
Message-ID: <20260917151558.983248528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 3313ead8bfcc2..06aa7fcd367e1 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -221,7 +221,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->exit)
+		if (client->ops && client->ops->exit)
 			client->ops->exit(client);
 
 	/* reset client to end of list for late teardown */
@@ -229,7 +229,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown_late:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->late_exit)
+		if (client->ops && client->ops->late_exit)
 			client->ops->late_exit(client);
 
 	mutex_unlock(&device->clients_lock);
-- 
2.53.0



