Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C061F2749DF;
	Thu, 15 Jan 2026 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498763; cv=none; b=Y4yml1mdkf884ObseQ2Noo2u3nN9kvo0kJgG5y9LKVKxOnSPmax8EkscUIo+SEz/QabDX7q/zH32ryHbxnO+63rFxPXEfbWYdXfgJFaVePkpSi+j2Jh364rsK5Woc5ATGmvy1eFE9VnQoVuq0+8vZQeZ44L/CkhStn3ncPkRLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498763; c=relaxed/simple;
	bh=qHMVfdQ5nqGzSkzF85Af2ROv49HmYDGGpZy57ID2dyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKkTfeNfOl4CEseKO1pvWqgRGcq8+BCisrTngwEVydkA3cDiSwhIngg0ddSpQfYPRIOQQLWZQSuRXF6ry5Pko6HgOUqUQAHMESagDS4wurYUiY43zRzBCb+eqbc2dH0qqRCP80TMp748bL73gGC6NJWvnuVW1oAcI0v2+dmf/iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZzUgPCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZzUgPCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B6AC116D0;
	Thu, 15 Jan 2026 17:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498763;
	bh=qHMVfdQ5nqGzSkzF85Af2ROv49HmYDGGpZy57ID2dyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZzUgPCAqOqRZ6jEWD7uL6iIK6NAcRhMVdKAxT/LSwPdQcHP/JpgGS+b57rc/w4ty
	 NpsYK3Ug2B5u/CU8GBsdBOH3A979wyOB15jy4YI8iR2cSugYLZhIsFAT7ONgdEB+uG
	 PjlE4WdOpN1/dzojNhj3OYHbgbvm3lQKP2zVMDjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 528/554] net: marvell: prestera: fix NULL dereference on devlink_alloc() failure
Date: Thu, 15 Jan 2026 17:49:54 +0100
Message-ID: <20260115164305.438988574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 68b442eb6d694..59e865df6cee0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -396,6 +396,8 @@ struct prestera_switch *prestera_devlink_alloc(struct prestera_device *dev)
 
 	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch),
 			   dev->dev);
+	if (!dl)
+		return NULL;
 
 	return devlink_priv(dl);
 }
-- 
2.51.0



