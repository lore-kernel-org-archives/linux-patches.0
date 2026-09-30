Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DCD2D594F;
	Wed, 30 Sep 2026 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794221; cv=none; b=tF/PCFpPwvr2SBknrWJoYoIX4luSLccV667+wh1RehSMAeVcK3zrhhnvIAYvFztE3OjHxcw9i3pLcpKhXJAeNK7kde+Lxmsk6F6Ur60wMFFNyF4VnO2FUnL+xI6YJIAceY4KrYXfkAdelK99rQZdyGrNG+6lH0/sP2Ru6HhP8PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794221; c=relaxed/simple;
	bh=gwsV17U8OoHCPic6B2u8kaWK+SnRyC772iTWyV8bPvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STGN4xCwvew/fSFGTpCZ9BURy7NTVxZdhhWcMshGfoXxtOo8qrdYqM1Pm6gVM474VQiJBXFRWM3ocVmAyHTHgMMGHccm7phRJlFj9mkzv/JKpmt76IQ7RvaQrfqwI1w1I/FHJzzqdyuYsbEQVKAY6rRucrd43wfeCJp9WaGUzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLptjB9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLptjB9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2191F000FF;
	Wed, 30 Sep 2026 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794219;
	bh=JCKXeFLi3W0BgscEwyY1QPvh+UKex5WNXk6Yzmp5PX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLptjB9BpOk/UwyBI2+o0KuNbk0Oy4SylCdgOUDzosZYAIKdp/M2h0Se23gbILFAF
	 0bDnwSNsmIZAVnlECCfEZNsYBkVUk+Jp1p9RYsdpGodnLTWAaT63MEWoXRMoGCr0r4
	 WiGwGxLn1Nxo7jU+Gqp44a5p5oviO0ZSvcCdOfes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shayderrr <darknessshayder@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0133/1193] host1x: bus: Fix missing ops null check in error teardown
Date: Wed, 30 Sep 2026 17:13:37 +0200
Message-ID: <20260930152437.166243540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 8a4e0738014d6..e8092f785f417 100644
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



