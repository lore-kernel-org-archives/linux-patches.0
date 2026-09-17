Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C487149738A;
	Thu, 17 Sep 2026 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660344; cv=none; b=IP7MTYZc4osu8oiL+hIZrhUdJ+nyNrdYzGGaygnsjZbDEmY2LHmUHDW6pn4Y28r5O3IOMsPB2dwS7v3LwxW/L16bYqkEDJJLPZ+xvG0nK2xcVNAp4MY3H4VS7EB+utMgzebeU0YsmYi076hlDa+ddcRfKMU/WurCMVAiMdi1UWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660344; c=relaxed/simple;
	bh=OGEOw5xAzUUIFhcMJ8dP2XAZhIIGBf0L8rr94B2jKN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeboR7ecePcC31bqGmloroySotcl5a9p9n5Z6GUTUUCVeRZBTQXm+lJCay2l7WMcM5CrdRuyPiRjuOzkqC/WIFlg6NQsRW2BLjB0E6MpBxgbMDuQFJLj6jH1uZboI/Qyr84O50KLY6Gt78bo026T5ttikqmWByfKqfvSMBTG0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClGEfEPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClGEfEPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE4B1F000FF;
	Thu, 17 Sep 2026 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660342;
	bh=klIwsGb4KNgRdj+H5ZUJ9VgnCZOf9hDuRxfMtGIoEGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClGEfEPsZ2GUbpMsP1hSCDex82CxzhuPNEdG/65y5Ex3deF8titYWJNbpPYuw6wkY
	 cv7j+orSGwXe0UBlZ/d0B3AFMNuFPl6cmFJRuMYQPo8/olov5v1Idz+DHuwGJ2+mgt
	 R/YusnlIsDGyTfEGaW4hi805mzCkTduQgIjyfjAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 7.2 560/733] erofs: preserve LZMA decoders on resize failure
Date: Thu, 17 Sep 2026 16:14:28 +0100
Message-ID: <20260917151406.260152491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

commit 617d0d8d199ba1790c94310fd75a22d01c97a8d6 upstream.

The pool-resize path frees each stream's old decoder before allocating
its replacement. If an allocation fails after some streams have already
been replaced, the failed stream is put back on the list with state ==
NULL. z_erofs_lzma_max_dictsize is still advanced as if the whole
pool had been resized.

An existing LZMA mount can select the broken stream and pass
NULL to xz_dec_microlzma_reset(). A retry at the same size also
skip another resize attempt. Since the global maximum was advanced,
thus, the invalid state is left unrepaired.

Allocate each replacement before freeing the old decoder, temporarily
retaining one old decoder during allocation. Stop at the first failure
and advance z_erofs_lzma_max_dictsize only after all streams satisfy
the request.

Record each stream's dictionary capacity so retries can skip streams
already enlarged before a partial failure.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor_lzma.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -5,6 +5,7 @@
 struct z_erofs_lzma {
 	struct z_erofs_lzma *next;
 	struct xz_dec_microlzma *state;
+	unsigned int dict_size;
 	u8 bounce[PAGE_SIZE];
 };
 
@@ -128,11 +129,19 @@ again:
 	err = 0;
 	/* 2. walk each isolated stream and grow max dict_size if needed */
 	for (strm = head; strm; strm = strm->next) {
+		struct xz_dec_microlzma *state;
+
+		if (strm->dict_size >= dict_size)
+			continue;
+		state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
+		if (!state) {
+			err = -ENOMEM;
+			break;
+		}
 		if (strm->state)
 			xz_dec_microlzma_end(strm->state);
-		strm->state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
-		if (!strm->state)
-			err = -ENOMEM;
+		strm->state = state;
+		strm->dict_size = dict_size;
 	}
 
 	/* 3. push back all to the global list and update max dict_size */
@@ -142,7 +151,8 @@ again:
 	spin_unlock(&z_erofs_lzma_lock);
 	wake_up_all(&z_erofs_lzma_wq);
 
-	z_erofs_lzma_max_dictsize = dict_size;
+	if (!err)
+		z_erofs_lzma_max_dictsize = dict_size;
 	mutex_unlock(&lzma_resize_mutex);
 	return err;
 }


