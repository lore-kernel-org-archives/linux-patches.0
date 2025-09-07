Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908944315A;
	Sun,  7 Sep 2025 20:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277410; cv=none; b=HEwXmqbChbBDcMVm4PFhKLZjFUC3tPAGZxTWEWVjAmoW15PcVvuOz1jMLnV/E9T0dcOJpEBHqfhe3qUIiTeKfKzsjRIYRSvh+8APWQ7PI1e0Of+07OAbzQqNOfbHuteedZ1IkSo/YuBDktdiRkUX+XHI5yxvHPsQ4YifXf+UJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277410; c=relaxed/simple;
	bh=vRHH4DYwVEEEZPqglbwfhAivtUuHXF2zMw6Uy6sg9WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbePltd6mI5HTBcLPejKpgzke91ymxoDKwCS7ZASKu2gqbQ83gbyehVIEyEDCABR4ijv7pjVCgGNhCOTrKBVk87nm49PUdt+i7xMBusXPE4xXOT09w5NtcyS/vh3hVvW2zgzvYSFP9HpQ6WKL/M6/EnA/QRMXRoVBhVOv+thVic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUbo8bB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUbo8bB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B831C4CEF0;
	Sun,  7 Sep 2025 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277410;
	bh=vRHH4DYwVEEEZPqglbwfhAivtUuHXF2zMw6Uy6sg9WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUbo8bB0sVaqcGCEK2vdufDUag5ONsIr8U8t8PfzunKBJ6Sw2y4CzRrODNur9lHY9
	 dzE39pzL0XFLms54OuowQEg5nElyCUVmaXBBx17ZxA1By9EPbPn5iQFhOXsy/lTlhe
	 ZzKLmJJbzep5r4gobunEcWkAN6KowBozoJW3E2G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/175] mm, slab: cleanup slab_bug() parameters
Date: Sun,  7 Sep 2025 21:58:54 +0200
Message-ID: <20250907195618.138904857@linuxfoundation.org>
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

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit 4b183dd9359d5772446cb634b12a383bed98c4fc ]

slab_err() has variadic printf arguments but instead of passing them to
slab_bug() it does vsnprintf() to a buffer and passes %s, buf.

To allow passing them directly, turn slab_bug() to __slab_bug() with a
va_list parameter, and slab_bug() a wrapper with fmt, ... parameters.
Then slab_err() can call __slab_bug() without the intermediate buffer.

Also constify fmt everywhere, which also simplifies object_err()'s
call to slab_bug().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Stable-dep-of: b4efccec8d06 ("mm/slub: avoid accessing metadata when pointer is invalid in object_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1027,12 +1027,12 @@ void skip_orig_size_check(struct kmem_ca
 	set_orig_size(s, (void *)object, s->object_size);
 }
 
-static void slab_bug(struct kmem_cache *s, char *fmt, ...)
+static void __slab_bug(struct kmem_cache *s, const char *fmt, va_list argsp)
 {
 	struct va_format vaf;
 	va_list args;
 
-	va_start(args, fmt);
+	va_copy(args, argsp);
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	pr_err("=============================================================================\n");
@@ -1041,8 +1041,17 @@ static void slab_bug(struct kmem_cache *
 	va_end(args);
 }
 
+static void slab_bug(struct kmem_cache *s, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	__slab_bug(s, fmt, args);
+	va_end(args);
+}
+
 __printf(2, 3)
-static void slab_fix(struct kmem_cache *s, char *fmt, ...)
+static void slab_fix(struct kmem_cache *s, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -1098,12 +1107,12 @@ static void print_trailer(struct kmem_ca
 }
 
 static void object_err(struct kmem_cache *s, struct slab *slab,
-			u8 *object, char *reason)
+			u8 *object, const char *reason)
 {
 	if (slab_add_kunit_errors())
 		return;
 
-	slab_bug(s, "%s", reason);
+	slab_bug(s, reason);
 	print_trailer(s, slab, object);
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
@@ -1139,15 +1148,14 @@ static __printf(3, 4) void slab_err(stru
 			const char *fmt, ...)
 {
 	va_list args;
-	char buf[100];
 
 	if (slab_add_kunit_errors())
 		return;
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
+	__slab_bug(s, fmt, args);
 	va_end(args);
-	slab_bug(s, "%s", buf);
+
 	__slab_err(slab);
 }
 
@@ -1185,7 +1193,7 @@ static void init_object(struct kmem_cach
 					  s->inuse - poison_size);
 }
 
-static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
+static void restore_bytes(struct kmem_cache *s, const char *message, u8 data,
 						void *from, void *to)
 {
 	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x", message, from, to - 1, data);
@@ -1200,7 +1208,7 @@ static void restore_bytes(struct kmem_ca
 
 static pad_check_attributes int
 check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
-		       u8 *object, char *what, u8 *start, unsigned int value,
+		       u8 *object, const char *what, u8 *start, unsigned int value,
 		       unsigned int bytes, bool slab_obj_print)
 {
 	u8 *fault;


