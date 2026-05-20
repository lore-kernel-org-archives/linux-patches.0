Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1394B3F39EE;
	Wed, 20 May 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299370; cv=none; b=cZ1wE6cbVMlzkBWuJTNCq6CStTt65Wc81lOk+KmTqGmtTXlYVDU/XjrPnA+4pUt0hm8XfUY99WMjuOCQrUXs/M/LSz5tnedfhJfKqi2ccu5B36YDx450CgX3qeCh+WCkl8ralOLBIxT5xuwf4FfhdZkhUAAvOxfII6Dfeq4WAdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299370; c=relaxed/simple;
	bh=KuV2t3cFvi8NyuSxtLBGUxg62yYs3/fFesw4bJufgYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDeDYbPv7mrvyogHFo5ipraV7/ZNOzlNcTjPaF6sKLSLTO5zaNQlwMMmVdzomFubEZRG9XD7kvh4UXCyF7B8nOt69RP0VTvO6eaYUbJ8tCMEn5+GvNJnV5JW5XCzm2US0Qr5YSSESrCSFePq/xzei15bhf1MMnrWP02sNvy/T1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRwvfwWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRwvfwWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781161F00893;
	Wed, 20 May 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299369;
	bh=44QuuTUffX3s1aCNGtB/1D+gv/IXrsJzxpEaxhumcWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRwvfwWvANpJcDrrKm+NKuLrVkqqA3aj0ou5+uacWksFTIJ6m71NS/77knsBvwhwe
	 lOxelDnn4peXYn/7UycIJ+BCMyy7CKAp6UxUSf3BTA1c8Xry9xZUWSRn7KdzhiO4Jr
	 z+A8jTNp59m7dv32PHDfEpcD1AEHCfMxjYVIXmqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 709/957] net: mana: Fix EQ leak in mana_remove on NULL port
Date: Wed, 20 May 2026 18:19:52 +0200
Message-ID: <20260520162149.920177382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 65267c9c4f28199985505977bc2c628c82fc50ef ]

In mana_remove(), when a NULL port is encountered in the port iteration
loop, 'goto out' skips the mana_destroy_eq(ac) call, leaking the event
queues allocated earlier by mana_create_eq().

This can happen when mana_probe_port() fails for port 0, leaving
ac->ports[0] as NULL. On driver unload or error cleanup, mana_remove()
hits the NULL entry and jumps past mana_destroy_eq().

Change 'goto out' to 'break' so the for-loop exits normally and
mana_destroy_eq() is always reached. Remove the now-unreferenced out:
label.

Fixes: 1e2d0824a9c3 ("net: mana: Add support for EQ sharing")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-6-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 12952f7273eb6..4b7e5acba7f76 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3723,7 +3723,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		if (!ndev) {
 			if (i == 0)
 				dev_err(dev, "No net device to remove\n");
-			goto out;
+			break;
 		}
 
 		apc = netdev_priv(ndev);
@@ -3754,7 +3754,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	}
 
 	mana_destroy_eq(ac);
-out:
+
 	if (ac->per_port_queue_reset_wq) {
 		destroy_workqueue(ac->per_port_queue_reset_wq);
 		ac->per_port_queue_reset_wq = NULL;
-- 
2.53.0



