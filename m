Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3F3503BEF;
	Wed, 30 Sep 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784078; cv=none; b=qNWJDTE0SlWsNO/BbK3rc7103VgZ0OQoTwkImLKMQdu537cz49UeaprnfFdqW85987alAcX34wat4pzGLCuEqqliO5+mvdDF3yDnVwzz+389MYWbg9Tw+/W+nvYQWwiF4joV9jf4o5MADQLl4xyaWG9PReExPP52BZKDZchLCVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784078; c=relaxed/simple;
	bh=GGHEUwXqmBbt7JXQVfWaV/sajva0f/g/XbWmnKu7p00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Svoys3Yqdi5/uKWt9tBax3cL39ZHbVL0sCIdgKWA7hqPflHa7O29wmSlvI3TRbBA8VRCHZL5ZgrJHEF6pWRvdXGd7YQCuKYx6aiKYRJ2Yuh1nFzM99lSFtt4YVoMd0RWmbOLLONQNiyrigRtbTF/NXuyGevPOgwJykxoUDW7pec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYqy5OcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYqy5OcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F621F0089A;
	Wed, 30 Sep 2026 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784074;
	bh=XcLzEi7o1oBZ4WXgOky6fpwiwhM6xcNd9xDMWsVb9TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYqy5OcU5/Vm30qf/vOfQSC9W5VbucBBUyuVrNcLT+GdgM0by5c0Y7JwdiCvigyUn
	 5mA6u0LgvwNzlZgBwIFQxxdiwPwHNN/DcEk/MI9sr4OOSUUXdqo3G1XPmti6Jzc3kH
	 Ye6nUd1C5aIR5Q4Dykm2I9C0hq8488x2K76RopXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/982] thunderbolt: Keep the domain reference while processing hotplug
Date: Wed, 30 Sep 2026 17:12:36 +0200
Message-ID: <20260930152417.223349009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index f417ce477d4a0..3c993a40c2313 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -59,7 +59,7 @@ static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 	if (!ev)
 		return;
 
-	ev->tb = tb;
+	ev->tb = tb_domain_get(tb);
 	ev->route = route;
 	ev->port = port;
 	ev->unplug = unplug;
@@ -1464,6 +1464,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0



