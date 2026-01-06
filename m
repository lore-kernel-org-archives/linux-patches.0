Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAC2D8DA3;
	Tue,  6 Jan 2026 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721256; cv=none; b=F5XuZPeB/1y7GEhw29+MqMhv9x2G3ouS6RaSI0hp1Tf3xx1YHLEHfSNdHYA/kTu+NL/ZGvtKf8IU/uJs5dPaVhtmvJpnKEp2ga6Gk5v9S7DMQMSNjHgjREjze9R5J479+dUd0J12gYKKZ+r5bzJqPj5IL6HdRhIhzQYWHQPQrpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721256; c=relaxed/simple;
	bh=91AoSwgV3DsZiTsCgEmRrupTLK4bg2byCDPr2kO2b48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGhrjshhoBjobJpXPxOwBlardSw9Ip2h/MZdU+Fj12rr17eBse15MeuRxUx+oKb66HjndNnaTo8LNySNDXM0nn63KfgmYbip2K7BocyKo117DIikOeI7jFBaKNCskBOwiHyVLwXQygQT9fIuU6FJ9/hn78QLqbwPloztOOzyFFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpgHB94I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpgHB94I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96346C16AAE;
	Tue,  6 Jan 2026 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721256;
	bh=91AoSwgV3DsZiTsCgEmRrupTLK4bg2byCDPr2kO2b48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpgHB94IF3cHvM6aEYGpPC/JYUcHZM8mq94av4eMtbWoNLbEoMRz28y2MYq4xv57d
	 6xniqeKzOdBKtu07auoiJUZEKm7Ur0Kxu1qnsjx3yuqFz6gY0jEEshZIwJ8jf8v5+T
	 Heqz5FdXVcRwnCSHmCPJsomy9u56yBp7do3sp9ac=
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
Subject: [PATCH 6.12 482/567] drm/i915/gem: Zero-initialize the eb.vma array in i915_gem_do_execbuffer
Date: Tue,  6 Jan 2026 18:04:24 +0100
Message-ID: <20260106170509.186253685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -951,13 +951,13 @@ static int eb_lookup_vmas(struct i915_ex
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
@@ -966,19 +966,8 @@ static int eb_lookup_vmas(struct i915_ex
 
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
@@ -986,10 +975,6 @@ static int eb_lookup_vmas(struct i915_ex
 	}
 
 	return 0;
-
-err:
-	eb->vma[i].vma = NULL;
-	return err;
 }
 
 static int eb_lock_vmas(struct i915_execbuffer *eb)
@@ -3374,7 +3359,8 @@ i915_gem_do_execbuffer(struct drm_device
 
 	eb.exec = exec;
 	eb.vma = (struct eb_vma *)(exec + args->buffer_count + 1);
-	eb.vma[0].vma = NULL;
+	memset(eb.vma, 0, (args->buffer_count + 1) * sizeof(struct eb_vma));
+
 	eb.batch_pool = NULL;
 
 	eb.invalid_flags = __EXEC_OBJECT_UNKNOWN_FLAGS;
@@ -3583,7 +3569,18 @@ i915_gem_execbuffer2_ioctl(struct drm_de
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


