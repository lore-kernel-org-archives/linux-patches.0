Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573B74F3EC2;
	Thu, 17 Sep 2026 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667692; cv=none; b=kY5qMfhjRQzHsBpsZ53DZAqh8Mfelu78+aDhrz7osrrH/tkJ1H04kytbCLWninOVnictnnPMllHs4DVJ6i5Sk8WNEXqMnqbIUwAyCIyfGlt1mDFwNMxzNbMefN9dbZP5zJbxvo0dcqiEOL4/h3rXD0XtUqeJDXozrNU3c9UsNsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667692; c=relaxed/simple;
	bh=PZUxMEY4TnH1+ZBd2oaabETZH1AkB9lwRBStagsnFCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+bsv33uZs/g3yId8rHGg6zuqN6V7e5nekYsP3XwvjwgYf8fvNHYGX84oVJk8tPAfNKGp9xvctboQpsoVez5j6MbD4BYPPlPjO3grybFe7LWTtT4z8VVrteM/SvCpCJShvSK4IH6Y7gRxtdZk+nG5I9jnY4fV23AgHRoAUzIz30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XODkwh2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XODkwh2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786D01F000FF;
	Thu, 17 Sep 2026 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667691;
	bh=YgwS5p5fMKa7D5vlJyq1WHU9Z9CBUEDWD5yvaAK+aeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XODkwh2yud2z55aswYZSCgGpUp3P5QLnIsA//x3gk9l4jLOmZAjxYg5RJXnwVOZmb
	 H9ahNqvdWll48lqpx47PiWAXZCl6VmdGhMH/IwIbEy7oLc2M04S3WUCQY288s9IhB2
	 fVwQIy4sXE3JwK5qLzSFiYj1oQhjIE+UhM8+45EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shayderrr <darknessshayder@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0178/1102] host1x: bus: Fix missing ops null check in error teardown
Date: Thu, 17 Sep 2026 16:02:01 +0100
Message-ID: <20260917151544.029339555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4dd83627fae06..5184932f379ed 100644
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



