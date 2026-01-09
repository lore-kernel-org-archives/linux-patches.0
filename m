Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FB23590C8;
	Fri,  9 Jan 2026 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962849; cv=none; b=WtTernxENHhVs4JSnd5O6sXuXEayYTDlnYpy0OtkooqPJYHyBfW2iKaV1l0LmqVKt81Q5fUcsefvesXJ57crle90o/OMDf2kBG4XktvTaYbLV+Z17frLjbZCmcDfzSjo0hkvBlWO3dy1OFDtir68Lw6J6+HbhOkr8mbTUkDhvcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962849; c=relaxed/simple;
	bh=XiWOwdRTTxoZXQxY5mJdEl2/R/OyW6VPbUU+tf3rYXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBtrWRCXVLiNF1zStyoxKvvXtR92VVmu6iS9F2A88lqXlhcdPLFOISB82KghqXDsXXZsKwNd+o31QoCaYmBicIjf/faZosWbslUvj/xUU+D2hwgambIaNLzCYVkEPFRbvQEgwM+EOPZXh59CAOmtg9uGO5OILbfJWf3Tw44ybFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yo5pbtYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yo5pbtYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8C0C4CEF1;
	Fri,  9 Jan 2026 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962849;
	bh=XiWOwdRTTxoZXQxY5mJdEl2/R/OyW6VPbUU+tf3rYXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yo5pbtYdCzXFAH2yEBZRB9/iOxMx0pqBVPCktYnjBT25afazs+i5B2S8c1wFt9Pzh
	 W+7kAhS4WDprzFdfUWCR7JFeljYFbk/kMhnGbUwMcdlF7S6RzyO/z8ZyatNvEqCyRH
	 VEGivl6mU5u2EGB8uT/Vdp9FpWV5goFxyg6ZNinc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gangmin Kim <km.kim1503@gmail.com>,
	Krzysztof Niemiec <krzysztof.niemiec@intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 509/634] drm/i915/gem: Zero-initialize the eb.vma array in i915_gem_do_execbuffer
Date: Fri,  9 Jan 2026 12:43:07 +0100
Message-ID: <20260109112136.703858266@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Niemiec <krzysztof.niemiec@intel.com>

commit 4fe2bd195435e71c117983d87f278112c5ab364c upstream.

Initialize the eb.vma array with values of 0 when the eb structure is
first set up. In particular, this sets the eb->vma[i].vma pointers to
NULL, simplifying cleanup and getting rid of the bug described below.

During the execution of eb_lookup_vmas(), the eb->vma array is
successively filled up with struct eb_vma objects. This process includes
calling eb_add_vma(), which might fail; however, even in the event of
failure, eb->vma[i].vma is set for the currently processed buffer.

If eb_add_vma() fails, eb_lookup_vmas() returns with an error, which
prompts a call to eb_release_vmas() to clean up the mess. Since
eb_lookup_vmas() might fail during processing any (possibly not first)
buffer, eb_release_vmas() checks whether a buffer's vma is NULL to know
at what point did the lookup function fail.

In eb_lookup_vmas(), eb->vma[i].vma is set to NULL if either the helper
function eb_lookup_vma() or eb_validate_vma() fails. eb->vma[i+1].vma is
set to NULL in case i915_gem_object_userptr_submit_init() fails; the
current one needs to be cleaned up by eb_release_vmas() at this point,
so the next one is set. If eb_add_vma() fails, neither the current nor
the next vma is set to NULL, which is a source of a NULL deref bug
described in the issue linked in the Closes tag.

When entering eb_lookup_vmas(), the vma pointers are set to the slab
poison value, instead of NULL. This doesn't matter for the actual
lookup, since it gets overwritten anyway, however the eb_release_vmas()
function only recognizes NULL as the stopping value, hence the pointers
are being set to NULL as they go in case of intermediate failure. This
patch changes the approach to filling them all with NULL at the start
instead, rather than handling that manually during failure.

Reported-by: Gangmin Kim <km.kim1503@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15062
Fixes: 544460c33821 ("drm/i915: Multi-BB execbuf")
Cc: stable@vger.kernel.org # 5.16.x
Signed-off-by: Krzysztof Niemiec <krzysztof.niemiec@intel.com>
Reviewed-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20251216180900.54294-2-krzysztof.niemiec@intel.com
(cherry picked from commit 08889b706d4f0b8d2352b7ca29c2d8df4d0787cd)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |   37 +++++++++++--------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -941,13 +941,13 @@ static int eb_lookup_vmas(struct i915_ex
 		vma = eb_lookup_vma(eb, eb->exec[i].handle);
 		if (IS_ERR(vma)) {
 			err = PTR_ERR(vma);
-			goto err;
+			return err;
 		}
 
 		err = eb_validate_vma(eb, &eb->exec[i], vma);
 		if (unlikely(err)) {
 			i915_vma_put(vma);
-			goto err;
+			return err;
 		}
 
 		err = eb_add_vma(eb, &current_batch, i, vma);
@@ -956,19 +956,8 @@ static int eb_lookup_vmas(struct i915_ex
 
 		if (i915_gem_object_is_userptr(vma->obj)) {
 			err = i915_gem_object_userptr_submit_init(vma->obj);
-			if (err) {
-				if (i + 1 < eb->buffer_count) {
-					/*
-					 * Execbuffer code expects last vma entry to be NULL,
-					 * since we already initialized this entry,
-					 * set the next value to NULL or we mess up
-					 * cleanup handling.
-					 */
-					eb->vma[i + 1].vma = NULL;
-				}
-
+			if (err)
 				return err;
-			}
 
 			eb->vma[i].flags |= __EXEC_OBJECT_USERPTR_INIT;
 			eb->args->flags |= __EXEC_USERPTR_USED;
@@ -976,10 +965,6 @@ static int eb_lookup_vmas(struct i915_ex
 	}
 
 	return 0;
-
-err:
-	eb->vma[i].vma = NULL;
-	return err;
 }
 
 static int eb_lock_vmas(struct i915_execbuffer *eb)
@@ -3352,7 +3337,8 @@ i915_gem_do_execbuffer(struct drm_device
 
 	eb.exec = exec;
 	eb.vma = (struct eb_vma *)(exec + args->buffer_count + 1);
-	eb.vma[0].vma = NULL;
+	memset(eb.vma, 0, (args->buffer_count + 1) * sizeof(struct eb_vma));
+
 	eb.batch_pool = NULL;
 
 	eb.invalid_flags = __EXEC_OBJECT_UNKNOWN_FLAGS;
@@ -3561,7 +3547,18 @@ i915_gem_execbuffer2_ioctl(struct drm_de
 	if (err)
 		return err;
 
-	/* Allocate extra slots for use by the command parser */
+	/*
+	 * Allocate extra slots for use by the command parser.
+	 *
+	 * Note that this allocation handles two different arrays (the
+	 * exec2_list array, and the eventual eb.vma array introduced in
+	 * i915_gem_do_execbuffer()), that reside in virtually contiguous
+	 * memory. Also note that the allocation intentionally doesn't fill the
+	 * area with zeros, because the exec2_list part doesn't need to be, as
+	 * it's immediately overwritten by user data a few lines below.
+	 * However, the eb.vma part is explicitly zeroed later in
+	 * i915_gem_do_execbuffer().
+	 */
 	exec2_list = kvmalloc_array(count + 2, eb_element_size(),
 				    __GFP_NOWARN | GFP_KERNEL);
 	if (exec2_list == NULL) {


