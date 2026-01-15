Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB93BC4F3;
	Thu, 15 Jan 2026 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497100; cv=none; b=qKBnSZvdu6dAigs/CEVtlPQ4ntKBRxq/N204+kuD9RCPTMit3Q2v8Raf7IbY6NHsLZRnjt407XdkKBpN5GNzdwypu6mNBHg3FJqz8aWP4E7/qSM+CYnacW0ywvswBGwWTmH5E2viKcuf0T0QgOvEl8w12wA7I/OFg3THSf9cZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497100; c=relaxed/simple;
	bh=zjSqM5/UrEt+NWb0gLyJzfkgAzg4/I7nuW7+SKoAOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWFOLt/cT+miqVz1hmJbsuAuYDggtU467jKE2eYdWJ8qTSHRnEwvo6voE8fCfKLayn7YnuXVvIDr8Eww8VK/5IgcLxRtyUKPARsce2wRBMW/fbKPLH7TPW4FwTaDAVReErL/93/qhJklwaHPhtGBOFZ6hXn2Ewb3ibc3O8fRi60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuWFnw1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuWFnw1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3E7C116D0;
	Thu, 15 Jan 2026 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497100;
	bh=zjSqM5/UrEt+NWb0gLyJzfkgAzg4/I7nuW7+SKoAOXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuWFnw1Kx+JY/DcjqtiHhPZAjnCmw50q1ykxLjkeonUpllw0xh2mQTJiWQAxMvDRV
	 UGURTj7wqXpBLsBZMO9065QQUvWu0Y2xaRdc7OZPSuO9imRuo+/Y6Ax1/0JoUhBtZQ
	 HeJlOsjvOxd+4CnN5rJSrbXU+zsUtz2JARTcSwas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/72] net: marvell: prestera: fix NULL dereference on devlink_alloc() failure
Date: Thu, 15 Jan 2026 17:48:46 +0100
Message-ID: <20260115164144.803498970@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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
index 06279cd6da674..8f0ae62d4a893 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -392,6 +392,8 @@ struct prestera_switch *prestera_devlink_alloc(struct prestera_device *dev)
 
 	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch),
 			   dev->dev);
+	if (!dl)
+		return NULL;
 
 	return devlink_priv(dl);
 }
-- 
2.51.0



