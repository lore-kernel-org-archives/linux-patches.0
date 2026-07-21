Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D482D35AC0E;
	Tue, 21 Jul 2026 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657660; cv=none; b=TraWGH1LiSnkNDhTCEmFKw6rOskGmbfNmqW7/09z8g8CdKh9IZsYM6QTl+tf3MtGcryx+GFHOi3VSPAuojx6O3W1GMY/O5x7RvJ6z4TwGQ7FnmJSFqk8T9j++De7qtgNaP/znRNqwic0zYDA1Rcc2dYE88Nws5E/kqJakrq1e2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657660; c=relaxed/simple;
	bh=ufKJaues7XNW0EJsYBzmzmuOlVLl2Q4mubfVJUKT8uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPm6xbeZI2tdAroM3GBgxPN9YtXB54PIvBennT83PLA/4D7goFX85PIni5RjCqiW9nqgcv5hGJcB6EhdeWGQdvTQlHA2eoaNyh+ybcUXXdu4QEHtc2sNynfYVH2K3n+TOEKuJ9sYznSrqaBL06JhR5klxodxINquu2WMGv0Y854=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkFNNwii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkFNNwii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303321F000E9;
	Tue, 21 Jul 2026 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657658;
	bh=i9+Oh5tUZN3l7s24AeJa7/BiSZav/hH5sLSiu5lWDAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkFNNwiirfCX3kzav4Qv/FdIL+/66CesP6hSkhecwCH3r1rjlKlwOnKRekI6wWYkP
	 1m20i87snm3g+5pMayUokVVMjX3EyYgLwW6HrCaatYODDL1IhMW7LtZEXuWoiOyMf0
	 vIPqmzp6PlLAGqtEljZ5Gepa/rKUzKTwBGSBcD5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0849/1611] alloc_tag: fix use-after-free in /proc/allocinfo after module unload
Date: Tue, 21 Jul 2026 17:16:05 +0200
Message-ID: <20260721152534.481880410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

[ Upstream commit 2956268efc457cb05d29c1bf94de1e8e684d7bbc ]

allocinfo_start() only reinitializes the codetag iterator at position 0.
For subsequent reads (position > 0), it reuses cached iterator state from
the previous batch.  allocinfo_stop() drops mod_lock between read batches,
which allows module unload to complete and free the module memory that the
cached iterator still references:

  CPU0 (read)                        CPU1 (rmmod)
  ----                               ----
  allocinfo_start(pos=0)
    down_read(mod_lock)
    allocinfo_show()
    ...
  allocinfo_stop()
    up_read(mod_lock)
                                     codetag_unload_module()
                                       kfree(cmod)
                                       release_module_tags()
                                     ...
                                     free_mod_mem()
  allocinfo_start(pos=N)
    down_read(mod_lock)
    // reuses cached iter, skips re-init
  allocinfo_show()
    ct->filename   <-- UAF

After free_mod_mem() frees the module's .rodata, allocinfo_show()
dereferences ct->filename, ct->function which point there.

Save the iterator state in allocinfo_next() and resume from it in
allocinfo_start() with codetag_next_ct(), which detects module removal via
idr_find() returning NULL and skips to the next module.

Link: https://lore.kernel.org/20260604065938.105991-1-hao.ge@linux.dev
Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/alloc_tag.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index df6ba06a8e4a8b..3082d977efaae1 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -45,6 +45,7 @@ int alloc_tag_ref_offs;
 
 struct allocinfo_private {
 	struct codetag_iterator iter;
+	struct codetag_iterator reported_iter;
 	bool print_header;
 };
 
@@ -58,16 +59,20 @@ static void *allocinfo_start(struct seq_file *m, loff_t *pos)
 	if (node == 0) {
 		priv->print_header = true;
 		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
-		codetag_next_ct(&priv->iter);
+	} else {
+		priv->iter = priv->reported_iter;
 	}
+	codetag_next_ct(&priv->iter);
 	return priv->iter.ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
 {
 	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
-	struct codetag *ct = codetag_next_ct(&priv->iter);
+	struct codetag *ct;
 
+	priv->reported_iter = priv->iter;
+	ct = codetag_next_ct(&priv->iter);
 	(*pos)++;
 	if (!ct)
 		return NULL;
-- 
2.53.0



