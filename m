Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4C23A9629;
	Fri,  4 Sep 2026 05:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500474; cv=none; b=ujQYiUmb8QqtYbfz/SnlfKT9crOkzPV55bi0Nd0LtI8/Xjgo2lybTLdYEG/w43wwg0nH3915/on8ZsmysbKL+Qg7s49xR+qhmFYlxeqBGSx/GZbYXQdt6Bpk+kx5cWCdIXONWQsUHpza04h/ZiLmMjBpTldHk/kyrTmxMFpcpQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500474; c=relaxed/simple;
	bh=yIQ0bheh+DTp6L/V0I8vyQJUc+zzhPhXgYJq5hLL494=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH3IF9UkkRF3VKakZBMc0AHLnvbWis6LN/z/jUcmHVKTXaWqXXDafNq2zvUGLhxbWnP+xLUAMBxJkwTQF4JQfU6/QPV4zNI9tmRqAnl/WTkIHVheyXnJ90HQ+YNeSco62s65DqDG/m7zchUAnagbvkT60kp/Hy1bgH/+w9bOngo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUiWP2qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUiWP2qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FAC1F00A3D;
	Fri,  4 Sep 2026 05:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500473;
	bh=4eUSsmF+g/KU4fpRyuhDsW8JmbHqC+9jbbBDH1Vvrgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUiWP2qwx4+tjbBR542vyoIuVfR0lWJw/QfmcRa6UcuN3rBLmp7N7/nHk0zPzrXNY
	 uCvtXaNrCzi+htywRGRhOJVmFg6IBrgrRMELXwe6KQS1qFJJrnxC02cBiRNn1DXzuG
	 mshVJmginRcpF98t1Wz9/DqX2fQfzwCgWgVcb6cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 067/552] rapidio: mport_cdev: fix use-after-free in dma_req_free()
Date: Fri,  4 Sep 2026 06:53:44 +0200
Message-ID: <20260904045749.368578926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


