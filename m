Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B8237756C;
	Thu, 30 Jul 2026 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422848; cv=none; b=UmXhTogPSCiXOraEvU/akcuQwcv0yXHWtr27Yh1wlO1SZ1RNKfsxZPd+I8vcEMD1Z93yEbe+xJWxcUQ5WHGpp6V5OnMt4dA//TpApaAjiEpbDCIHJQBant9Nu5z0NrRHLfn1xoaxAt2wIFn9P1TUZG9Oix8zUZEdOJpD2TXf6kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422848; c=relaxed/simple;
	bh=6t0J5o2NJBCRaSPElnACjF0vHIIn4eirvzx6zz1tXqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSYWJ0e1SWaaq7kWFB3U6oZBuvjCHXu1e2me18RiPOHPJzLpic2JF+0Y/LST7nRWf0TK4xK1aXQDf+icjWbsmba0GntNEHUtu4iLv7amvyOJzKFHO/QgJPqMpXPxbkB9x9vMyrN5amtsTZBj9U7eX9E+DiVZoEK8vrqX4QCKsY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eaf+kkfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eaf+kkfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00091F00A3A;
	Thu, 30 Jul 2026 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422847;
	bh=867R8zlXDLGlDvn4lfqOmxo3Dw0GnfW5XrO4vGJD+B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eaf+kkfJpPTd631IfT3kcoWNfPAStYXiInZPEjMGJw9KjoPxU/EMvAriqH4CVGSpj
	 rzDJzVF89xJ2hMl9jriYWDOC2GcpfOo2qKqEH9/OlXMp9ChfEbY0yuTWAGv7Q/Q3W5
	 aoqGWzgnNcyk+FCDsZWIS89UnLfb7Bt4HpISpieU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.1 577/744] firmware: stratix10-svc: fix memory leaks and list corruption bugs
Date: Thu, 30 Jul 2026 16:14:10 +0200
Message-ID: <20260730141456.548759475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1845,14 +1845,16 @@ void *stratix10_svc_allocate_memory(stru
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
@@ -1878,6 +1880,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
+
 	guard(mutex)(&svc_mem_lock);
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
@@ -1886,10 +1889,9 @@ void stratix10_svc_free_memory(struct st
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
 


