Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B30D430789;
	Thu, 30 Jul 2026 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426293; cv=none; b=mqF0aSgJQgcVIQLhTQIf4z9/12CQMPfZfM9/s+M1IpXkvOZghCob8Wga4yRIhsQglA9QP8o+54P9aB6CKGp7ixuQJH91YsiBSrYrftAysX3UQkA4kZSLFtzHEPc60jtmmimi1TqRBeIxfv9mDmzAeTgHZP1UBedHCiXLWw9ysAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426293; c=relaxed/simple;
	bh=lxDBEkCyOKtopI7IEvUCOPYSva6sMLYfCvHBNJR2TGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F63XrAqY3OV8wBs4GwefaP9315xRBzrBUq71oslFChUuqXy/jukmtn1sytSiDEvxc5yWtvESDTtZDNJjTR4AV6Gbg5BLwFxS+NjPa2FP/aRtc4DGJCDvUR+dL6gYzf6fkzmNZ37DnU5IxT6KhlNolrGdIKcsUop9YzYzt1JyMKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry+2CTVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry+2CTVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8151F000E9;
	Thu, 30 Jul 2026 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426292;
	bh=3ZXAN7HVfZz4Gl4g4bgyopuU+V3q+OanOuvj5TM3EAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ry+2CTVKsZW/AH5ErtD/2WuWNs3J2x0I5GfzmAGXAdXNY1byWvBzlydJmdEN+Rs+9
	 I4uffUKy89YFWcwapZ5K1yJZe/PGtt+EYxcrLC18NWFtBkVveOJ5YtntNdTc+bda9V
	 9/XSiOAApgTXupMgK4sWOe5SqYh2n6M6KuABrV5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.12 366/602] firmware: stratix10-svc: fix memory leaks and list corruption bugs
Date: Thu, 30 Jul 2026 16:12:38 +0200
Message-ID: <20260730141443.650491352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Tze Yee Ng <tze.yee.ng@altera.com>

commit 9119ceb76e987c2ec2b549ea100e3268ce3a1c7c upstream.

Fix a memory leak when gen_pool_alloc() fails by freeing pmem on the error
path. Switch pmem allocation from devm_kzalloc() to kzalloc() with
explicit kfree() in the free path to match its list-managed lifetime.
Remove the erroneous list_del(&svc_data_mem) which corrupted the list head
on failed lookups.

Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
Cc: stable@vger.kernel.org # 5.0+
Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1083,14 +1083,16 @@ void *stratix10_svc_allocate_memory(stru
 	struct gen_pool *genpool = chan->ctrl->genpool;
 	size_t s = roundup(size, 1 << genpool->min_alloc_order);
 
-	pmem = devm_kzalloc(chan->ctrl->dev, sizeof(*pmem), GFP_KERNEL);
+	pmem = kzalloc_obj(*pmem);
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
 	guard(mutex)(&svc_mem_lock);
 	va = gen_pool_alloc(genpool, s);
-	if (!va)
+	if (!va) {
+		kfree(pmem);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	memset((void *)va, 0, s);
 	pa = gen_pool_virt_to_phys(genpool, va);
@@ -1116,6 +1118,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
+
 	guard(mutex)(&svc_mem_lock);
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
@@ -1124,10 +1127,9 @@ void stratix10_svc_free_memory(struct st
 				       (unsigned long)kaddr, pmem->size);
 			pmem->vaddr = NULL;
 			list_del(&pmem->node);
+			kfree(pmem);
 			return;
 		}
-
-	list_del(&svc_data_mem);
 }
 EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
 


