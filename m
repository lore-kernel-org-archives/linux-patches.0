Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543293AE1A9;
	Wed, 30 Sep 2026 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793911; cv=none; b=EETWbt4qA/DaUeD8V2zFGAFNFkkVNAvMDGEzCewhGS5XHZI2nZ4zudZUNvTfvuRIHZRC+diFKUPDr62Dc8oCafOXXWCVfO1CTmJ9retMlzOR7G7k4KAgQr8K6PDKocwdjSZ8ypPb34eshQ5SWNN/VRLvEcJOj6hBX1CZ+b+ZfMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793911; c=relaxed/simple;
	bh=wznz5cuHoxOyFcl36HOGEio05Uu+JIpLtx6HDEStgMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKKMWvdETybVQQ9IqiDAc5FBcah7Tu8Q/HtiaGo/hcH5gqyZ8+TBfWKFdi0Jqd779HeS51pfZ6h3U8WLLHJoHTwBS8jL7QT85TYIGXHReeMJ5m9Ro5iO94vmj9DL21yb0r7JbJ3B0X1uBCHMTSVjaa5KT6zPXi7XeI/1rRyo07o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pU3Pjjd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pU3Pjjd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577F81F00899;
	Wed, 30 Sep 2026 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793909;
	bh=r5GvbLLyl+vJr2WUEqooE3ULCnCqXpPi4uGOXWM5Mm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pU3Pjjd58IUg+Q0OkzEqBkRJSgRt+fRNy9Lb/orhKs206o9Xx2FbnGjaXiKjLe1uQ
	 ai3C7ncfoDDh0SkZL6WYPQuArg/DjiasSeRPihO+XzxEuhTiBVP4WBkhh3QIRRR/Ir
	 rImprN7KfeEvib9DAXplAmlkTssliTNpmSTpoB7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0025/1193] thunderbolt: Keep the domain reference while processing hotplug
Date: Wed, 30 Sep 2026 17:11:49 +0200
Message-ID: <20260930152434.853583920@linuxfoundation.org>
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
index bf35fd23b5e16..d3c9479080ffe 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -191,7 +191,7 @@ static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 	if (!ev)
 		return;
 
-	ev->tb = tb;
+	ev->tb = tb_domain_get(tb);
 	ev->route = route;
 	ev->port = port;
 	ev->unplug = unplug;
@@ -2324,6 +2324,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0



