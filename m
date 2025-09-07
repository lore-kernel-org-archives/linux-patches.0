Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46366315D54;
	Sun,  7 Sep 2025 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277404; cv=none; b=StkvLdJEZAAgQGJuUqFmI/YW9P+HiTm2bT39bfSGF5DYt6xesFwADqKCRBtE7rFMzxopt8KgtuvD/IFFmW7yDj4refQTbAdJ+ULLWVJu5JMWYxDYQ9mYpXMlxqNIZxsDc9Mb/mIPLGvf/cKKH+J5h3xA5wgcEjO8VAV2if8XIyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277404; c=relaxed/simple;
	bh=Kf11XYkqk7Hs9841no4YFHJFTZ9vZWOFzCaa6BARRdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ1q2zI5lWZ3+8qJrb1AM0f5UgCZ/FLU8pztPZXmDNrem97kCpGAHCSzCM33JjX/7UNQOUOsDZ7rNA8U7qd01xi93MB3/KTjWMl7wKC+8QswffFIgKtRiTgri//8kw+K+x/nmD9f6sP6+wyhk1He3phJ0YOepBY1zLv3uSDv83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptlurtU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptlurtU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA2BC4CEF0;
	Sun,  7 Sep 2025 20:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277404;
	bh=Kf11XYkqk7Hs9841no4YFHJFTZ9vZWOFzCaa6BARRdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptlurtU6Nub6L5yCQsi0X0aPlYtIUPWhCBV+p0c47Az/yo9yyPKTmLU0OnWjV+piY
	 dDBmBIKWR/yYu/VaNswIM27lF4rXwI2UbhfcEq/H8OVP13pKVcbjj6eurdXMAJGN3z
	 vuUmiXUlXCwZWPjqIEXBcP5cFMHPFr7Gqdn+2NfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/175] mm: slub: Print the broken data before restoring them
Date: Sun,  7 Sep 2025 21:58:52 +0200
Message-ID: <20250907195618.089260273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hyesoo Yu <hyesoo.yu@samsung.com>

[ Upstream commit ed5ec2e952595a469eae1f6dce040737359b6da2 ]

Previously, the restore occurred after printing the object in slub.
After commit 47d911b02cbe ("slab: make check_object() more consistent"),
the bytes are printed after the restore. This information about the bytes
before the restore is highly valuable for debugging purpose.
For instance, in a event of cache issue, it displays byte patterns
by breaking them down into 64-bytes units. Without this information,
we can only speculate on how it was broken. Hence the corrupted regions
should be printed prior to the restoration process. However if an object
breaks in multiple places, the same log may be output multiple times.
Therefore the slub log is reported only once to prevent redundant printing,
by sending a parameter indicating whether an error has occurred previously.

Signed-off-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: b4efccec8d06 ("mm/slub: avoid accessing metadata when pointer is invalid in object_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1191,8 +1191,8 @@ static void restore_bytes(struct kmem_ca
 
 static pad_check_attributes int
 check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
-		       u8 *object, char *what,
-		       u8 *start, unsigned int value, unsigned int bytes)
+		       u8 *object, char *what, u8 *start, unsigned int value,
+		       unsigned int bytes, bool slab_obj_print)
 {
 	u8 *fault;
 	u8 *end;
@@ -1211,10 +1211,11 @@ check_bytes_and_report(struct kmem_cache
 	if (slab_add_kunit_errors())
 		goto skip_bug_print;
 
-	slab_bug(s, "%s overwritten", what);
-	pr_err("0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
-					fault, end - 1, fault - addr,
-					fault[0], value);
+	pr_err("[%s overwritten] 0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
+	       what, fault, end - 1, fault - addr, fault[0], value);
+
+	if (slab_obj_print)
+		object_err(s, slab, object, "Object corrupt");
 
 skip_bug_print:
 	restore_bytes(s, what, value, fault, end);
@@ -1278,7 +1279,7 @@ static int check_pad_bytes(struct kmem_c
 		return 1;
 
 	return check_bytes_and_report(s, slab, p, "Object padding",
-			p + off, POISON_INUSE, size_from_object(s) - off);
+			p + off, POISON_INUSE, size_from_object(s) - off, true);
 }
 
 /* Check the pad bytes at the end of a slab page */
@@ -1328,11 +1329,11 @@ static int check_object(struct kmem_cach
 
 	if (s->flags & SLAB_RED_ZONE) {
 		if (!check_bytes_and_report(s, slab, object, "Left Redzone",
-			object - s->red_left_pad, val, s->red_left_pad))
+			object - s->red_left_pad, val, s->red_left_pad, ret))
 			ret = 0;
 
 		if (!check_bytes_and_report(s, slab, object, "Right Redzone",
-			endobject, val, s->inuse - s->object_size))
+			endobject, val, s->inuse - s->object_size, ret))
 			ret = 0;
 
 		if (slub_debug_orig_size(s) && val == SLUB_RED_ACTIVE) {
@@ -1341,7 +1342,7 @@ static int check_object(struct kmem_cach
 			if (s->object_size > orig_size  &&
 				!check_bytes_and_report(s, slab, object,
 					"kmalloc Redzone", p + orig_size,
-					val, s->object_size - orig_size)) {
+					val, s->object_size - orig_size, ret)) {
 				ret = 0;
 			}
 		}
@@ -1349,7 +1350,7 @@ static int check_object(struct kmem_cach
 		if ((s->flags & SLAB_POISON) && s->object_size < s->inuse) {
 			if (!check_bytes_and_report(s, slab, p, "Alignment padding",
 				endobject, POISON_INUSE,
-				s->inuse - s->object_size))
+				s->inuse - s->object_size, ret))
 				ret = 0;
 		}
 	}
@@ -1365,11 +1366,11 @@ static int check_object(struct kmem_cach
 			if (kasan_meta_size < s->object_size - 1 &&
 			    !check_bytes_and_report(s, slab, p, "Poison",
 					p + kasan_meta_size, POISON_FREE,
-					s->object_size - kasan_meta_size - 1))
+					s->object_size - kasan_meta_size - 1, ret))
 				ret = 0;
 			if (kasan_meta_size < s->object_size &&
 			    !check_bytes_and_report(s, slab, p, "End Poison",
-					p + s->object_size - 1, POISON_END, 1))
+					p + s->object_size - 1, POISON_END, 1, ret))
 				ret = 0;
 		}
 		/*
@@ -1395,11 +1396,6 @@ static int check_object(struct kmem_cach
 		ret = 0;
 	}
 
-	if (!ret && !slab_in_kunit_test()) {
-		print_trailer(s, slab, object);
-		add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
-	}
-
 	return ret;
 }
 


