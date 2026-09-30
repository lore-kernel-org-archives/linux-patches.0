Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68194FECEE;
	Wed, 30 Sep 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782350; cv=none; b=srD+28hyA+rTqBn2CaCTcFPx30GmtXEG2gBYyAo7IO1hluFIjjdkC8B7f2VGnxAXjPV9ZRhs10WukP1WeUy/UU1r/jjPtV3/wRADcAczsO/jChMenPLLROOdfSBRp+hG7uv9QOUlnCo61VFobyEnUEDB4GdR42FPft+wnvlXQBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782350; c=relaxed/simple;
	bh=RXzj0FFyyay4SzWY8sWYjsXYNrjfpfzteOsBaKBYoeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyAOxAAzympjPmqwLRTEt/ozc/JgHPxbq3d+Ziw00F1IgYpZvk2JJWZApxGj4yQzsbrlWK8QFjDSXutM6lyHFIHQ6eRz56Gy+QzFH1h+HGUeDuHtEw71N/XZIJeEshn8Doroa3Q7Z3k0U46g+i+4UMY/75dAmrVBznIvsjiIcgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHfPdpot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHfPdpot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ADE1F0089B;
	Wed, 30 Sep 2026 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782340;
	bh=lar6004OQTM+vxnJ0S52ZeeZ6QWblk+wcx2plhTlCao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHfPdpoteDiuz514oJ/ZJW5fvSeFjkb16b99NQqiEIgPbqWgfQIwKchWc8WGoMA/5
	 CIkT7cLHuVNBysSk2wEn/TO+eSexO24LMYBRYDQCPlPR9vXPG9/vESMWS0ILcUZEkj
	 OhJjfqS1usg1qkIolYm3ClhnU+e9FSurrzqraoh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/595] thunderbolt: Keep the domain reference while processing hotplug
Date: Wed, 30 Sep 2026 17:18:26 +0200
Message-ID: <20260930152348.004296808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 138ec65b2c761f065b19d115aed2b8246fc272f5 ]

We process hotplug events in a workqueue that may run after the domain
has been removed by tb_domain_remove(). For example if user unloads the
driver while at the same time plugging  a device router we may have
scheduled tb_handle_hotplug() to run. Avoid possible UAF in this case by
taking the domain reference before scheduling the hotplug handler in
tb_queue_hotplug().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 545ed25b705d0..01a8485ab8f7e 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -56,7 +56,7 @@ static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 	if (!ev)
 		return;
 
-	ev->tb = tb;
+	ev->tb = tb_domain_get(tb);
 	ev->route = route;
 	ev->port = port;
 	ev->unplug = unplug;
@@ -1213,6 +1213,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0



