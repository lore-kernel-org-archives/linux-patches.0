Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2801A76B6;
	Tue, 30 Jul 2024 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360499; cv=none; b=i6byQFys7RHGRlxTTuamVqbDegEx9rw6oYgOFB6gi3vs1nqg2HGysG3kiWDLkfu+QRoKUnx4he+pco8FkW+cyWYSgTkNTckyXL//M2SUaWm6ZU08BIh49icmN0tn32z4UDzHQOvcQl3NXW2Q4U/2lHr+RRGWONNCNHENHc68zXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360499; c=relaxed/simple;
	bh=dw+3KkI9Wu+W+6XsKHVYS7wJiDSQox87yzu8V+BQKZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQgXuFqDjEK5giIdevaQky2XqpjUdxRNiNafDL7tnf6GpiR9PJJtRKVziB6cAdlpGr69dcuwh1KBMlv1TZf8VTUbROdmAHtc4+FE+5UF/4tqCtRqe6JpRkGo1unOXSTedfDKjUh/OfjHXSdblLeQSjfb15AH+t9f3zD8ULkEFSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07bkOfw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07bkOfw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C3EC4AF0A;
	Tue, 30 Jul 2024 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360499;
	bh=dw+3KkI9Wu+W+6XsKHVYS7wJiDSQox87yzu8V+BQKZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07bkOfw5VRb52kI/fUZow96eB5RrFtWHhmUBSwRfxhsBcS3O0yEwaA8mSo+NAAcAJ
	 +8qI32DCNy2+sJvhCJkzuGdzsUFvfBQMlaAskwXz5ofRLZRqCbiXAv7TfafYYWmuQk
	 +1dvrhAbrdFq/bupKYn0ekqC6sr7HxR8Aox0QetY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.10 717/809] dm-verity: fix dm_is_verity_target() when dm-verity is builtin
Date: Tue, 30 Jul 2024 17:49:53 +0200
Message-ID: <20240730151753.258753866@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 3708c7269593b836b1d684214cd9f5d83e4ed3fd upstream.

When CONFIG_DM_VERITY=y, dm_is_verity_target() returned true for any
builtin dm target, not just dm-verity.  Fix this by checking for
verity_target instead of THIS_MODULE (which is NULL for builtin code).

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1539,14 +1539,6 @@ bad:
 }
 
 /*
- * Check whether a DM target is a verity target.
- */
-bool dm_is_verity_target(struct dm_target *ti)
-{
-	return ti->type->module == THIS_MODULE;
-}
-
-/*
  * Get the verity mode (error behavior) of a verity target.
  *
  * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
@@ -1599,6 +1591,14 @@ static struct target_type verity_target
 };
 module_dm(verity);
 
+/*
+ * Check whether a DM target is a verity target.
+ */
+bool dm_is_verity_target(struct dm_target *ti)
+{
+	return ti->type == &verity_target;
+}
+
 MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
 MODULE_AUTHOR("Will Drewry <wad@chromium.org>");


