Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC44F96CF;
	Thu, 17 Sep 2026 17:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667281; cv=none; b=fTHaROrNGRcSnFnrSgkhQREMICC/T9uw1fK/wOd/Pa+WoWKy50HDIX6ezVNg01c/DnzfmTW1DZFwjtr7MqA4iwROJ3HHxi5MbWZ8tC+fNXYOAqEN/yMbWbyYvFNYIIPxidhNwLEmx+0KjF5Gga1f8M+ywKjli+N1T4Hrb8U1CWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667281; c=relaxed/simple;
	bh=ZWZM4ceZLeNwhywFq58kOHKHv33VS62PXqP72V/UCMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkAAhCXX6cbY1811uC8QXj2sCukQFKkVqe3CmhQswBahg5LVnI3DivwmfXprik7vq+aoQfXVFrGujDfeVf0zz1Yxdb9LY1d6WEweogjBgTF5PstmJskbFonuop6LMU0clDwRXVqlLa0kpo8RQyK3Exx41lBTgL8pfzWVDCO3/p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTNkcrKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTNkcrKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF9F1F000FF;
	Thu, 17 Sep 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667280;
	bh=+yQSTxeUwkqaHBGM7jtwtfi4ITp96JTMKWBz6xiqWpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTNkcrKFu9GJOLgL+hjpE6Jxyn68wLyZs1GmzMMTQgVPK/pKoU7kgD2vBdpd82mBW
	 6GGsYyujQ/WlKMcN/bCPYOlN/Upx31WV8clspMPXKOdqrAT59jL2TCDMhsQUO7wqEf
	 9c9v3LDk6rXU2qkf5rxY3fiNPgqqp3y0+kgyuyuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0039/1102] thunderbolt: Keep the domain reference while processing hotplug
Date: Thu, 17 Sep 2026 15:59:42 +0100
Message-ID: <20260917151540.425934223@linuxfoundation.org>
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
index afcba22f50131..5d89a265938ad 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -86,7 +86,7 @@ static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 	if (!ev)
 		return;
 
-	ev->tb = tb;
+	ev->tb = tb_domain_get(tb);
 	ev->route = route;
 	ev->port = port;
 	ev->unplug = unplug;
@@ -2453,6 +2453,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0



