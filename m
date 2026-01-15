Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582C01C5D72;
	Thu, 15 Jan 2026 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496884; cv=none; b=iDwAvhUV86xf2une1kTdlAzVsIxVHRZHQfKHUOGzcfiTwbcByu5YAj0VfvvZAT02CivSXSOjf3Hc1ykmRyz2igVMAaN/BFsT6YE4lOmkKRhwjBcfiK5CF3rKrqADO9GP2fL8IZYvnBTNkLIVUq+ChCdK2fH24t860gIcHJoxQYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496884; c=relaxed/simple;
	bh=JJzzQXXElvpksB9f/4CUjHw7PA3BiMttSkLUTHHZQQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8mNBEcoTp/FoMswFqXTgn4Kf4gSBIIr+HENkdUEPWhaX3n54v3dyFiwjSoGATmBJRb1xdIVDElHYu6rQdd1SSEN5fU1BAXmdo7hFFJn5BVhK/7Wb6+x0Cdku/+DKRcdU9StF3PB8e6q3GhUs+4F0rAcXkTyhm0MY/F9Vc95+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txXvpsbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txXvpsbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6919C116D0;
	Thu, 15 Jan 2026 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496884;
	bh=JJzzQXXElvpksB9f/4CUjHw7PA3BiMttSkLUTHHZQQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txXvpsbjjQnbW6PRLfAJcJn4GR7tivtYrEiKOvE9bs2xD3Z7E8Q1DJeEBeRa15gr7
	 H3O/YmIEs838tiSAAtHk70BWRQfwNujGbioKZ3qqNmWVXJv0AwIuSxjnU7WxE9bnY4
	 /ds2eKOI8GZz3Kidj7W3BoP6l/YKC1w3RryLCYY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/88] net: marvell: prestera: fix NULL dereference on devlink_alloc() failure
Date: Thu, 15 Jan 2026 17:48:33 +0100
Message-ID: <20260115164148.122852485@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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



