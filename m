Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E268A2C08D0;
	Sat, 12 Sep 2026 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219884; cv=none; b=ZkiWOARReAQHajsHXPn0d9QOra7EsV6MtdSClyUh7eo2fzvBWhXINwhdxNmtngbEmKhqpcrRIc+0ZxafhBt5Yi1croUf+g2wlpN6DudozeMFnUd37M85PXvhsoYR+rQz45cYt5H91D3yOFLLbtHDrEs4hsYLQaFOkzNI/44SC/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219884; c=relaxed/simple;
	bh=T2ffGwGMwY9yJrlKcPy5AfEBOG2YRUhcuJXYK6bkBFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL7Gc7RiZdky75BV2uTL6p2O6CO3D0YhsISaRCvMYwUOGNKZFOdLWVxsRXItfskLl3gRKDm1r4y5BjyFx6F8wA0Td1YU2x7juW41f6GlWjIEcPeM/d2NuMF+lP+4+7oEzz9A1NfVjVzPtVaU2y/GX5hBxO7ypQL469BDQm8jPds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJcHuC7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJcHuC7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A425D1F000FF;
	Sat, 12 Sep 2026 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219882;
	bh=BUb2CCVyREOnlG591wGYkp6g75+Ur/e5al4xBq/rkgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJcHuC7OEpN226IZt+MLS/uhlcEM6A7S8mQrZ6fngJjuKTDVBG6wCsMNwK8BQR1Jm
	 LhQGAffAo7tA11KQLPEy2C/1tafNmZ0EA8lOOPoUJwtusKd716pbgFrbZbLDv3Qist
	 dE/OFcLzWOU1H7rEk6gIiS5T2KbrXCOpmGduQfLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0027/1424] rapidio: mport_cdev: fix use-after-free in dma_req_free()
Date: Sat, 12 Sep 2026 08:40:59 +0200
Message-ID: <20260912065607.913481553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -582,9 +582,13 @@ static void dma_req_free(struct kref *re
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


