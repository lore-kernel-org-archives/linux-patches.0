Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551B7396B75;
	Thu, 15 Jan 2026 16:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496151; cv=none; b=ZASFhNghUyr59GAgmRffkx1kHq4ajQfrr9oHMI0qWe/U3R2psIdytPDB7WESWLGtLVg+V9CUFWLG4L4sM9eAAGbkdsdLeeJ63UZ7fg9TaKruHZOQFLHdejv299FtJ7wYl3lnZIwtYB7AQboAUeCL2DSQYPee5I5NTSj701BTC0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496151; c=relaxed/simple;
	bh=4E/wmeTD7NDWUqpXPs6MWDatH893b/Vfw4d1lM3qlBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYMsGKCG2ycdMF8pZlkWZf98nVBjEgp/kCmAFORvDPge6R2n+J/2kq8LY3VoJvFS8v3omdlyQgHX83gGrWyosc1HhGN7vVNr14gKs177GHZ4oKc3V2t673ta2x/MsDkJSHxZsGDjfHqqHw7YX8jCswJr7kD8KMQKjDv3RABiUeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBCrTCn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBCrTCn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DB5C16AAE;
	Thu, 15 Jan 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496151;
	bh=4E/wmeTD7NDWUqpXPs6MWDatH893b/Vfw4d1lM3qlBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBCrTCn9ZlxmB4oz4KQeLkaD5SSgLqwVjyPrq0/WvlAqlp39PHStr3qmUa5WPRnEo
	 B/3GlsG7Jf1TspoTgdKPGx94taq/bm2XwEiQzqWo5GlLolVkWpiWLF7Ogx4Yqzut2A
	 QWGVJvZDQzKT42DkIOJzKAsajrs1o1ySxsmQmIHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/181] net: marvell: prestera: fix NULL dereference on devlink_alloc() failure
Date: Thu, 15 Jan 2026 17:47:12 +0100
Message-ID: <20260115164205.751629650@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit a428e0da1248c353557970848994f35fd3f005e2 ]

devlink_alloc() may return NULL on allocation failure, but
prestera_devlink_alloc() unconditionally calls devlink_priv() on
the returned pointer.

This leads to a NULL pointer dereference if devlink allocation fails.
Add a check for a NULL devlink pointer and return NULL early to avoid
the crash.

Fixes: 34dd1710f5a3 ("net: marvell: prestera: Add basic devlink support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Elad Nachman <enachman@marvell.com>
Link: https://patch.msgid.link/20251230052124.897012-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 2a4c9df4eb797..e63d95c1842f3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -387,6 +387,8 @@ struct prestera_switch *prestera_devlink_alloc(struct prestera_device *dev)
 
 	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch),
 			   dev->dev);
+	if (!dl)
+		return NULL;
 
 	return devlink_priv(dl);
 }
-- 
2.51.0



