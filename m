Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EAD611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E55C433D2;
	Sun, 28 May 2023 19:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302613;
	bh=/PwAq7MUFxiEKaJwH6+AFhYLtlBipTL94i+o4jAh21E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAs35evN7sfH4iZgAeNFU9SuIm9/gFK/VNwDzcf484awCVnETgpSeSeodABj6chjy
	 mii8Tyf85Cec0Z1pPJG93OK0DDxroWvLxd36ijtuPxKBn/6Hfdf3eNySACYec1tXCn
	 YCd440Yqx8AOPLGuGpOaUroHUKBOBCmSGSGL2W7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Howlett <liam.howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.1 047/119] binder: add lockless binder_alloc_(set|get)_vma()
Date: Sun, 28 May 2023 20:10:47 +0100
Message-Id: <20230528190836.962972014@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlos Llamas <cmllamas@google.com>

commit 0fa53349c3acba0239369ba4cd133740a408d246 upstream.

Bring back the original lockless design in binder_alloc to determine
whether the buffer setup has been completed by the ->mmap() handler.
However, this time use smp_load_acquire() and smp_store_release() to
wrap all the ordering in a single macro call.

Also, add comments to make it evident that binder uses alloc->vma to
determine when the binder_alloc has been fully initialized. In these
scenarios acquiring the mmap_lock is not required.

Fixes: a43cfc87caaf ("android: binder: stop saving a pointer to the VMA")
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20230502201220.1756319-3-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -309,17 +309,18 @@ err_no_vma:
 	return vma ? -ENOMEM : -ESRCH;
 }
 
+static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
+		struct vm_area_struct *vma)
+{
+	/* pairs with smp_load_acquire in binder_alloc_get_vma() */
+	smp_store_release(&alloc->vma, vma);
+}
+
 static inline struct vm_area_struct *binder_alloc_get_vma(
 		struct binder_alloc *alloc)
 {
-	struct vm_area_struct *vma = NULL;
-
-	if (alloc->vma) {
-		/* Look at description in binder_alloc_set_vma */
-		smp_rmb();
-		vma = alloc->vma;
-	}
-	return vma;
+	/* pairs with smp_store_release in binder_alloc_set_vma() */
+	return smp_load_acquire(&alloc->vma);
 }
 
 static bool debug_low_async_space_locked(struct binder_alloc *alloc, int pid)
@@ -382,6 +383,7 @@ static struct binder_buffer *binder_allo
 	size_t size, data_offsets_size;
 	int ret;
 
+	/* Check binder_alloc is fully initialized */
 	if (!binder_alloc_get_vma(alloc)) {
 		binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 				   "%d: binder_alloc_buf, no vma\n",
@@ -777,7 +779,9 @@ int binder_alloc_mmap_handler(struct bin
 	buffer->free = 1;
 	binder_insert_free_buffer(alloc, buffer);
 	alloc->free_async_space = alloc->buffer_size / 2;
-	alloc->vma = vma;
+
+	/* Signal binder_alloc is fully initialized */
+	binder_alloc_set_vma(alloc, vma);
 
 	return 0;
 
@@ -959,7 +963,7 @@ int binder_alloc_get_allocated_count(str
  */
 void binder_alloc_vma_close(struct binder_alloc *alloc)
 {
-	alloc->vma = 0;
+	binder_alloc_set_vma(alloc, NULL);
 }
 
 /**


