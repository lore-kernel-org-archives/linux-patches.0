Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90FB3264C2;
	Wed, 30 Sep 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790615; cv=none; b=q5Oszm47PhTeDTJr7i4CEgL1EfSdr9cx3koq+SDrDTZ9ipdwzk2yKUAyQTSVUJCgoPHP27aAupaHzsQIrPg/0ZFe8aacyjaLEautVRvl2zZRTcBpuk5/ogCPpKCTOuuSpIjb4M3PogkbZMg7z0YtZM9DvUfzfVK2NDKEwX2mJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790615; c=relaxed/simple;
	bh=EDdIM6Itr/TJbxqBKYrFno96C1iMIAv6x0IRJEcDQYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wfa99pKta5vZ9Wga/BLxVzSEpygan12pbchHvZ7NCF0BuOM4Vw8kDpu17k4IjHGmbr5OFrrq2SA2VKHFlRbv5LCE8ZpFu6lv6DO3ZvNULWwbGuEhljHV42utRd9SGUxuhTHk6lAD9hi4NWi3umdCZh7wkb+sfx+jovVf+P+zZc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFJCeUYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFJCeUYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DB21F000FF;
	Wed, 30 Sep 2026 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790613;
	bh=w/xlqYoivuEdSyMKP/JkhzvRV1gQ7qaoUF3dgnYw29M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFJCeUYmv83joO76wKESCVgLVR9z2vcErdPoQAEW/Cu4H1uNHcEG+nVOyv47J0nHS
	 yRrqav5JKR5EAEbtN3flL0552HhtXIiXJp6GF58JC1TyIc8BARRiJj9sbX/ZsODNye
	 fkphT7reHrDdt3y9JrNebLYx01sY3jQ/kPxOWeRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/752] thunderbolt: Keep the domain reference while processing hotplug
Date: Wed, 30 Sep 2026 17:18:04 +0200
Message-ID: <20260930152358.455729743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 5b2a74a1bec36..ed001dfd2cb4e 100644
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
@@ -1315,6 +1315,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0



