Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16A03C1999;
	Thu, 15 Jan 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499340; cv=none; b=QsdquMZ9PLjAGkjxQKeKol4hYP6PstAVdjBhUCFKFWjWDM7zQeXYyfikuxEgsqSPskjkJMqsJb94wnbhv6ew5L+WXPmOw4yGIirwEl/e+LOTXrDUJzUKg+zYqPV9/xL0ek+OcUEwaEvCDwo9a3nHArKFPKEmnGG381Nia/JXFoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499340; c=relaxed/simple;
	bh=AU1KwHw9V+I+VheeEofD5IcQ9xSqXhttqQmRrcfHM64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDnAUFmPM35T/AK2XAGe2Vn4MxzRHIaKDEABW26/VC5niVjCtGP+qRHFhRZAQI0KUx6LpDHARl825wvgF3/dalU129XA2JRCtBt2fzppKWHARQTrL3se56nTxtEkPy5tXk+sulHt8I5guvdRcvKkcM2rkxCew4iB2cERkrZ7Qmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDGf5l7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDGf5l7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E067C116D0;
	Thu, 15 Jan 2026 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499339;
	bh=AU1KwHw9V+I+VheeEofD5IcQ9xSqXhttqQmRrcfHM64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDGf5l7DfjIEFYIjEPLlzLONhQtcY84DlttGlLlSxSkXv4q5cvS+1UhM0FYg3KBfB
	 HpgNkP/qVr7AuaQvU6EOe3mYDvXU1LV3JKUIbQzFVsvZGv6a7n5EQJync9fN9CgGfP
	 lyagJD7Tduu/NVgEOX1S96Y5H/9KkmsOZ+cp0QqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/451] block/rnbd: Remove a useless mutex
Date: Thu, 15 Jan 2026 17:46:32 +0100
Message-ID: <20260115164237.812967482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 24afc15dbe218f860994f627b4ba1fb09225a298 ]

According to lib/idr.c,
   The IDA handles its own locking.  It is safe to call any of the IDA
   functions without synchronisation in your code.

so the 'ida_lock' mutex can just be removed.
It is here only to protect some ida_simple_get()/ida_simple_remove() calls.

While at it, switch to ida_alloc_XXX()/ida_free() instead to
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/7f9eccd8b1fce1bac45ac9b01a78cf72f54c0a61.1644266862.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c9b5645fd8ca ("block: rnbd-clt: Fix leaked ID in init_dev()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 71b86fee81c2..ced9c4d7b926 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -23,7 +23,6 @@ MODULE_LICENSE("GPL");
 
 static int rnbd_client_major;
 static DEFINE_IDA(index_ida);
-static DEFINE_MUTEX(ida_lock);
 static DEFINE_MUTEX(sess_lock);
 static LIST_HEAD(sess_list);
 
@@ -55,9 +54,7 @@ static void rnbd_clt_put_dev(struct rnbd_clt_dev *dev)
 	if (!refcount_dec_and_test(&dev->refcount))
 		return;
 
-	mutex_lock(&ida_lock);
-	ida_simple_remove(&index_ida, dev->clt_device_id);
-	mutex_unlock(&ida_lock);
+	ida_free(&index_ida, dev->clt_device_id);
 	kfree(dev->hw_queues);
 	kfree(dev->pathname);
 	rnbd_clt_put_sess(dev->sess);
@@ -1381,10 +1378,8 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 		goto out_alloc;
 	}
 
-	mutex_lock(&ida_lock);
-	ret = ida_simple_get(&index_ida, 0, 1 << (MINORBITS - RNBD_PART_BITS),
-			     GFP_KERNEL);
-	mutex_unlock(&ida_lock);
+	ret = ida_alloc_max(&index_ida, 1 << (MINORBITS - RNBD_PART_BITS),
+			    GFP_KERNEL);
 	if (ret < 0) {
 		pr_err("Failed to initialize device '%s' from session %s, allocating idr failed, err: %d\n",
 		       pathname, sess->sessname, ret);
-- 
2.51.0



