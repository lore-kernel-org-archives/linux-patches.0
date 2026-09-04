Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C55E24A05D;
	Fri,  4 Sep 2026 05:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498540; cv=none; b=QHAXaG4hIgAg4LFTkHmv5hhCa1i1aSPleRSPez6ZUIAOJ57osSNXvNIusbsze2AI41NVeDqYy+Zpr91E8/t+wS2Feso9xqohovTKe48+vuyCiLuYrXhOwDTy72NsQD0nPuyHkLLxXKsZ14KjeWOs1BoamQUq8j0WeBXIyGgrcGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498540; c=relaxed/simple;
	bh=IfhtHXaVFta5H7wZfUcsAte4M+5/tKFz1nYA9bpJJCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uErknem+dy6g5yHWeut9/US6KEo5GP6yQv+NcGzU+G0OEy1OHYGqOQBApXTnP3zwtTU+XjEvsEXTZZPVu93oJdB40P1zlltMnUUbO6Ml2I0TC7J/xcs9j8pwjpCNQNVgtInhLRvzJjguW+7ipu9ynYAz3T1PJm36+xB8EXPZegU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=198VbAy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="198VbAy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EA71F00A3D;
	Fri,  4 Sep 2026 05:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498539;
	bh=enKkwfLc6pXUUXB9v5LDjZ2taxK0hYvStapQYPEs06Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=198VbAy4dpk50onFgr7aWyP/LldhXluCFgvtNzr3EAI6xvE4g8kfawUKvv0hcvgtE
	 0dVqLc+uoX/Bjx7S62u+TZp6L+SJJGXhxEABSHDQzAqfW5y6JEFUfW1cuoNTc/uvZu
	 uef+TG0PFNcyc5IC96GOhdjr94KxAYWIEG/hXNL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 099/713] rapidio: mport_cdev: fix use-after-free in dma_req_free()
Date: Fri,  4 Sep 2026 06:51:07 +0200
Message-ID: <20260904045806.055952000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Kim <james010kim@gmail.com>

commit 5cbef379a94b161726c5f504598bf4791d45cedc upstream.

dma_req_free() acquires buf_mutex through req->map, drops the mapping
reference with kref_put(), and then dereferences req->map again to unlock
the mutex.

If kref_put() drops the last reference, mport_release_mapping() frees the
mapping, and the subsequent mutex_unlock() dereferences a freed object.
This is a use-after-free.

Fix this by caching map and md before kref_put(), clearing req->map while
holding buf_mutex, and using the cached md for mutex unlocking.

The bug is reachable from userspace via the RapidIO mport character device
interface.

Link: https://lore.kernel.org/20260723235220.588424-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -564,9 +564,13 @@ static void dma_req_free(struct kref *re
 	}
 
 	if (req->map) {
-		mutex_lock(&req->map->md->buf_mutex);
-		kref_put(&req->map->ref, mport_release_mapping);
-		mutex_unlock(&req->map->md->buf_mutex);
+		struct rio_mport_mapping *map = req->map;
+		struct mport_dev *md = map->md;
+
+		mutex_lock(&md->buf_mutex);
+		req->map = NULL;
+		kref_put(&map->ref, mport_release_mapping);
+		mutex_unlock(&md->buf_mutex);
 	}
 
 	kref_put(&priv->dma_ref, mport_release_dma);


