Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E89651DAEB;
	Wed, 30 Sep 2026 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790831; cv=none; b=T+XoOBnD3NLzLhXZSvgltcPpvsuOoCKDwYOOOXcyRKiils5EirRvNFkEVAROjEyk3CZUwczm/cDWlLEe0udtL52rx8QTymtbI7aG9UUbmyS7OMIYhleRfXOaFenxWlPJZJzBk1uGdMXwXuLICJq54fFUlEwO8VVvg/WqPbHFOMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790831; c=relaxed/simple;
	bh=M8hm9bzws1xqTKFu/APiLnC9fgtoiV1tmUOezohDbH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABWjxuwKrJjUYRkEhSAaUZSEPAxgS6BoWKh4P3Ryj+QS1R61yn0fR4eNdDPHnAfiUxvth9xjlkuar2n8TEGIYDgLpWMfJmZoBiRFn57BM9kAByuem55i8xKXe0mdHlK6j3rp0hheMubW2tcHp8BlCj8v6qtSh6Vwl8bn8VkD8Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwvejTYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwvejTYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCE31F00898;
	Wed, 30 Sep 2026 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790830;
	bh=IsnztH4PjhLBy6REjXSY0WwjW0xAdOM+LiuKZI/iIHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwvejTYEZTEHl7bANsZlhexLY4w53KPM9BF1PBSiGVbutrqWUqzyxGILRf691aDPk
	 H4qxLNmy25pA10SWos0X6qsU0vvE9SZ0uS6RtM/xpPDN6hFsn9+C1D+AKpVsTKpmzM
	 jXGwHGsdWi0exrKHAi7svV1sPHSzFd9kjKSgBCWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shayderrr <darknessshayder@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/752] host1x: bus: Fix missing ops null check in error teardown
Date: Wed, 30 Sep 2026 17:19:20 +0200
Message-ID: <20260930152400.116065211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 481022c463935..168b77a143184 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -225,7 +225,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->exit)
+		if (client->ops && client->ops->exit)
 			client->ops->exit(client);
 
 	/* reset client to end of list for late teardown */
@@ -233,7 +233,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown_late:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->late_exit)
+		if (client->ops && client->ops->late_exit)
 			client->ops->late_exit(client);
 
 	mutex_unlock(&device->clients_lock);
-- 
2.53.0



