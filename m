Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D2227599;
	Tue, 26 Aug 2025 11:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207405; cv=none; b=GCH20rGaCSHP5SLqL6SZvNvBhDt8AZbsXIu1B/aXW75sjMv3dP//x6xcMvu4ICB+d6zXhn/O9geCi0oc3PvMiqyrmV9HCT9gZ5Jv67nVYuGcETbVX78dkHFAouMpZz0tWlpOwT/HPs9C0MvqTlMmBkk0AcmHTeRusri/FgfuuCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207405; c=relaxed/simple;
	bh=3pbiH8HUb5gXK4WrctLs8KyNL/44ga6BfPKrxUksqHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1rBOfTTzRcj2gDe96MUH9T4JhALxxbCsFmqEgRPhybkW1EN6ugF6xdRzMO8c53kinkwv+CGRMl4lOWHCGMKaB20PXdI8xDOTNmOjwrA7BL1sD3snkqBRXFyANXxXOw3MnWKWlkDjxXs0DjH36aJQ41u2QJvkROc8LdstIs6gEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXdCZc8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXdCZc8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D280DC4CEF1;
	Tue, 26 Aug 2025 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207405;
	bh=3pbiH8HUb5gXK4WrctLs8KyNL/44ga6BfPKrxUksqHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXdCZc8C3M9gYw91geIt34ao++b6V2PHnvktumY5stD3wwc2ucj/MHoB3aoF7tNXt
	 9OXbctZkeje5gtbFDVDVTgy7UZA3SB02d72HpuzsjTmeiejgdjZRLBi4GZ8zvIlBMV
	 UHJdeedfTUcN7D4DCbOiV4r+kw9WxGLDojE7Sb9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	melvyn <melvyn2@dnsense.pub>,
	Summers Stuart <stuart.summers@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.16 169/457] drm/xe: Defer buffer object shrinker write-backs and GPU waits
Date: Tue, 26 Aug 2025 13:07:33 +0200
Message-ID: <20250826110941.552912684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 2dd7a47669ae6c1da18c55f8e89c4a44418c7006 upstream.

When the xe buffer-object shrinker allows GPU waits and write-back,
(typically from kswapd), perform multiple passes, skipping
subsequent passes if the shrinker number of scanned objects target
is reached.

1) Without GPU waits and write-back
2) Without write-back
3) With both GPU-waits and write-back

This is to avoid stalls and costly write- and readbacks unless they
are really necessary.

v2:
- Don't test for scan completion twice. (Stuart Summers)
- Update tags.

Reported-by: melvyn <melvyn2@dnsense.pub>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5557
Cc: Summers Stuart <stuart.summers@intel.com>
Fixes: 00c8efc3180f ("drm/xe: Add a shrinker for xe bos")
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250805074842.11359-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 80944d334182ce5eb27d00e2bf20a88bfc32dea1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_shrinker.c |   51 +++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_shrinker.c
+++ b/drivers/gpu/drm/xe/xe_shrinker.c
@@ -53,10 +53,10 @@ xe_shrinker_mod_pages(struct xe_shrinker
 	write_unlock(&shrinker->lock);
 }
 
-static s64 xe_shrinker_walk(struct xe_device *xe,
-			    struct ttm_operation_ctx *ctx,
-			    const struct xe_bo_shrink_flags flags,
-			    unsigned long to_scan, unsigned long *scanned)
+static s64 __xe_shrinker_walk(struct xe_device *xe,
+			      struct ttm_operation_ctx *ctx,
+			      const struct xe_bo_shrink_flags flags,
+			      unsigned long to_scan, unsigned long *scanned)
 {
 	unsigned int mem_type;
 	s64 freed = 0, lret;
@@ -86,6 +86,48 @@ static s64 xe_shrinker_walk(struct xe_de
 	return freed;
 }
 
+/*
+ * Try shrinking idle objects without writeback first, then if not sufficient,
+ * try also non-idle objects and finally if that's not sufficient either,
+ * add writeback. This avoids stalls and explicit writebacks with light or
+ * moderate memory pressure.
+ */
+static s64 xe_shrinker_walk(struct xe_device *xe,
+			    struct ttm_operation_ctx *ctx,
+			    const struct xe_bo_shrink_flags flags,
+			    unsigned long to_scan, unsigned long *scanned)
+{
+	bool no_wait_gpu = true;
+	struct xe_bo_shrink_flags save_flags = flags;
+	s64 lret, freed;
+
+	swap(no_wait_gpu, ctx->no_wait_gpu);
+	save_flags.writeback = false;
+	lret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned);
+	swap(no_wait_gpu, ctx->no_wait_gpu);
+	if (lret < 0 || *scanned >= to_scan)
+		return lret;
+
+	freed = lret;
+	if (!ctx->no_wait_gpu) {
+		lret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned);
+		if (lret < 0)
+			return lret;
+		freed += lret;
+		if (*scanned >= to_scan)
+			return freed;
+	}
+
+	if (flags.writeback) {
+		lret = __xe_shrinker_walk(xe, ctx, flags, to_scan, scanned);
+		if (lret < 0)
+			return lret;
+		freed += lret;
+	}
+
+	return freed;
+}
+
 static unsigned long
 xe_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
@@ -192,6 +234,7 @@ static unsigned long xe_shrinker_scan(st
 		runtime_pm = xe_shrinker_runtime_pm_get(shrinker, true, 0, can_backup);
 
 	shrink_flags.purge = false;
+
 	lret = xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
 				nr_to_scan, &nr_scanned);
 	if (lret >= 0)


