Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED9C3A641D;
	Thu, 30 Jul 2026 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424681; cv=none; b=fIZ0WvnuePv9/h59de7O1g1zjmp5tfJiytB1RAjW6bEwQK03NJuJ/fqOKgWYUvk3gbFOpiQbrBLGVXmSSN8Ije181Pihkd7AS7fm2ibqbDUKol46X93c0V0E+3GWk4d1ewiXAYpCvLFB1XKgAr/wWs34AZxRtLLaB0eBq0kZGcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424681; c=relaxed/simple;
	bh=hyAtmn3llzLLUwJE83oOXIomjbDNjDbDJ3zMgRrHIII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMMy2VCeBlFcyR7jPIGWFRkX5w8YDqg4wUZRBZSayrTVBlBJc4FFYOuJi7Tijc/rZjfbnvX6bGt57noQ1AGHZcWLzFswzg1ZmygPx8B/ka3ik4Uwr9UnXQW9ix9lbaCZo5yqznqTbWcgdhU+ete9ckWpF+RggQIy3GAuOb7J9Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa/EuLHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa/EuLHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17111F000E9;
	Thu, 30 Jul 2026 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424680;
	bh=53teiIxwwvZ1Te2B+1ed8KrjgVVb4Fomx5zeMLVtluE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qa/EuLHfnZ7M/S69E9jETOO4JnYD7SgU612an3jCL/LcoXhZWPUl2UGlKYYV11b2M
	 j3lT8RVRxU4juyadPBOOsjSNKHEMT4LIqXUq85DKTZpbzAeFu1YlcPj/DF3kZFkNAj
	 j8iRqpKSDGQiqtu0tXZS3HHMlhdksG+/1O+qvyEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.18 479/675] firmware: stratix10-svc: fix memory leaks and list corruption bugs
Date: Thu, 30 Jul 2026 16:13:29 +0200
Message-ID: <20260730141455.306629271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -1080,14 +1080,16 @@ void *stratix10_svc_allocate_memory(stru
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
@@ -1113,6 +1115,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
+
 	guard(mutex)(&svc_mem_lock);
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
@@ -1121,10 +1124,9 @@ void stratix10_svc_free_memory(struct st
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
 


