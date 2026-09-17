Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3883B776A;
	Thu, 17 Sep 2026 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671049; cv=none; b=dp97nuzqPY7EaTjqPlT+O7jLjtRCGwAzOtL7Vdkoa5j3883fwjjn89Ca2fITKNiXajG/wiwdvr2XUs9ETNSctbkRznWxsWWTEK+6pPoz4w6jfUpQQrvaHXsycPY6IvxrgE3HKmTowhtGH4dggAaq/Fqoow+meXy0x2gwk9ZmwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671049; c=relaxed/simple;
	bh=q/w+DN8EJwFBupsthrv8pPjMUY0SkRj2du+3dz/Vo4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehr5SuQPHYxBYMyxoTe4yGJq4Zhfw0DB4u215ISBgzA8KNX1sqJFu7UK7wGlenMzCtD7rGWDaYr8FA0we0U/SjvXHFNC1uC7uVO1GCoLo6VkZxAw/ZwUV0mD3rS3NSMCBA6/W+mxh7U4i6Ytyw/tZrjbISUmjT6rJr0t5WvtF5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0o6efil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0o6efil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEF51F000FF;
	Thu, 17 Sep 2026 18:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671047;
	bh=zefQk6oLUj5MA936tiq5vmq40uIVjBh3h2R4lpyxKxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0o6efilTFaSEmnwmvMy7R5JJ7PQEesBUqVJ4HFxCsZR2MZOTHZkRUecBhFkyWmQY
	 jjvfUrj10nqiFxnLkTdwdFNnhbzxZYvQrXv4oARUE5blP5DbbuffjKNIGa1ohzXxTE
	 jD0abuIl9SChMY6Zvvud3wTspve0QVBly6t2TAH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 6.12 0852/1102] erofs: preserve LZMA decoders on resize failure
Date: Thu, 17 Sep 2026 16:13:15 +0100
Message-ID: <20260917151601.927945914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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


