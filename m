Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D832AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2E9C433C8;
	Wed, 20 Sep 2023 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211220;
	bh=7F3sDRYk3/fu29YeI5dlbZEsTH871CS37ht8kp0FcWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3LqJbV12z/UmDyxSgLV6ZGgjafXUEcnUooGJ/NAxLQsXprINPIPrP0mfAclQlsVV
	 2vsgofI+0tsooQocdSEh/+gHq1qxP3j1nQPCVRAr4b4yEisPjZ8lVe+Cf29CwKyxtG
	 m8t2cKGauwq2Rtp4kbpp8bj49EUuLK4aXI27LIR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Sodagudi Prasad <psodagud@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 4.14 013/186] lib/ubsan: remove returns-nonnull-attribute checks
Date: Wed, 20 Sep 2023 13:28:36 +0200
Message-ID: <20230920112837.344434821@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit bac7a1fff7926fb9891a18fe33650884b0e13e41 upstream.

Similarly to type mismatch checks, new GCC 8.x and Clang also changed for
ABI for returns_nonnull checks.  While we can update our code to conform
the new ABI it's more reasonable to just remove it.  Because it's just
dead code, we don't have any single user of returns_nonnull attribute in
the whole kernel.

And AFAIU the advantage that this attribute could bring would be mitigated
by -fno-delete-null-pointer-checks cflag that we use to build the kernel.
So it's unlikely we will have a lot of returns_nonnull attribute in
future.

So let's just remove the code, it has no use.

[aryabinin@virtuozzo.com: fix warning]
  Link: http://lkml.kernel.org/r/20180122165711.11510-1-aryabinin@virtuozzo.com
Link: http://lkml.kernel.org/r/20180119152853.16806-2-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/ubsan.c            |   24 ------------------------
 lib/ubsan.h            |    5 -----
 scripts/Makefile.ubsan |    1 -
 3 files changed, 30 deletions(-)

--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -143,11 +143,6 @@ static void val_to_string(char *str, siz
 	}
 }
 
-static bool location_is_valid(struct source_location *loc)
-{
-	return loc->file_name != NULL;
-}
-
 static DEFINE_SPINLOCK(report_lock);
 
 static void ubsan_prologue(struct source_location *location,
@@ -354,25 +349,6 @@ void __ubsan_handle_type_mismatch_v1(str
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
 
-void __ubsan_handle_nonnull_return(struct nonnull_return_data *data)
-{
-	unsigned long flags;
-
-	if (suppress_report(&data->location))
-		return;
-
-	ubsan_prologue(&data->location, &flags);
-
-	pr_err("null pointer returned from function declared to never return null\n");
-
-	if (location_is_valid(&data->attr_location))
-		print_source_location("returns_nonnull attribute specified in",
-				&data->attr_location);
-
-	ubsan_epilogue(&flags);
-}
-EXPORT_SYMBOL(__ubsan_handle_nonnull_return);
-
 void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
 					void *bound)
 {
--- a/lib/ubsan.h
+++ b/lib/ubsan.h
@@ -57,11 +57,6 @@ struct nonnull_arg_data {
 	int arg_index;
 };
 
-struct nonnull_return_data {
-	struct source_location location;
-	struct source_location attr_location;
-};
-
 struct vla_bound_data {
 	struct source_location location;
 	struct type_descriptor *type;
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -7,7 +7,6 @@ ifdef CONFIG_UBSAN
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=returns-nonnull-attribute)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
 


