Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0970C332610;
	Sat, 12 Sep 2026 07:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198639; cv=none; b=Rr6Eoc61/OXxWggPU09nQGyz5DSvru06+W3BLb5MNYXw2zctswH0lK1ANYgvMI7kfTF8iUIQWwM6zRhybRT8d5aPiOZoQLsFlyOQqjerm2vbWQf5naW1KEWMAHdkEWjSVr/kfRhKe8+JsswFouzcBREecZBJEuL1cNzU/Bj1LRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198639; c=relaxed/simple;
	bh=ueaY3Wxxpa8hz+2kO23697V+dsAAoU2YOfShJDHiX3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKQi3rJMdSPM+V3xH4OPXmidyErQWt8viXVEwkCqCtUQT8hPjBIrY9gQVBwoOFVyr3yl42cBzwTX+SdBWTBI3bDtgKhaYEGFYrPslQzEWMknZDtDMQAUUh91Qh2zxQn8z/tzJulojJBLvU/iDnqtQzHiCqgIyY0f1qGMxFAoU1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC+rikSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC+rikSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7EB1F000FF;
	Sat, 12 Sep 2026 07:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198637;
	bh=P60RAaV8eS8D/HT229p43uFDlE1TLFUADcxxTAgu/34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GC+rikSsIj8nOpU7xnqQhjsYHCHv5CHbbj4AvLz4JkKo4XDLSZg25ZerkvoyY/T6t
	 kSaNUi6eqlrAHqW+V2ivHDvNvmLNzniwsyPnartnKJxmPXn0Vvv/82GLNUN/umFCcR
	 E9XvICsKvbDEPGXS96Xz1v1JG2m3+UhfaMbmdgdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0423/1815] dax: fix holder_ops race in fs_put_dax()
Date: Sat, 12 Sep 2026 08:36:13 +0200
Message-ID: <20260912065658.825967677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: John Groves <John@Groves.net>

[ Upstream commit 7a6db2eb6d5da9ade0d4802e25bbec3342ae0187 ]

Clear holder_ops before holder_data so that a concurrent fs_dax_get()
cannot have its newly installed holder_ops overwritten. cmpxchg()
provides release ordering on weakly-ordered architectures, ensuring the
WRITE_ONCE(holder_ops, NULL) store is visible to any CPU that observes
the holder_data release.

Add a WARN_ON() that fires only when the cmpxchg observes a non-NULL
value that is not @holder, i.e. fs_put_dax() called by something that
is not the current holder. That is an API contract violation; the
WARN_ON() does not prevent the damage but makes the bug visible.

A NULL cmpxchg result is deliberately tolerated: kill_dax() clears
holder_data while a holder is still attached when a device is removed
out from under a mounted filesystem (after delivering MF_MEM_PRE_REMOVE).
The holder's subsequent fs_put_dax() - e.g. xfs_free_buftarg() after a
forced shutdown - then legitimately finds holder_data already NULL, so
warning on that case would turn supported device removal into a splat
(or a panic with panic_on_warn).

Also add a kerneldoc comment documenting that fs_put_dax() must only
be called by the current holder.

Fixes: eec38f5d86d27 ("dax: Add fs_dax_get() func to prepare dax for fs-dax usage")
Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/0100019ecc09dcab-2f4aa175-0b84-4b36-9e54-ebff302ebb0a-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 433cd431a6c06..45f84b0eb909a 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -116,11 +116,47 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 
 #if IS_ENABLED(CONFIG_FS_DAX)
 
+/**
+ * fs_put_dax() - release holder ownership of a dax_device
+ * @dax_dev: dax device to release (may be NULL)
+ * @holder: the holder pointer previously passed to fs_dax_get() or
+ *          fs_dax_get_by_bdev(); must match exactly, as it is used
+ *          in a cmpxchg to atomically release ownership
+ *
+ * Must only be called by the current holder. Clears holder_ops before
+ * holder_data to avoid a race where a concurrent fs_dax_get() could have
+ * its newly installed holder_ops overwritten.
+ */
 void fs_put_dax(struct dax_device *dax_dev, void *holder)
 {
-	if (dax_dev && holder &&
-	    cmpxchg(&dax_dev->holder_data, holder, NULL) == holder)
-		dax_dev->holder_ops = NULL;
+	if (dax_dev && holder) {
+		void *prev;
+
+		/*
+		 * Clear holder_ops before releasing holder_data. A concurrent
+		 * dax_holder_notify_failure() that sees NULL ops returns
+		 * -EOPNOTSUPP cleanly. A concurrent fs_dax_get() that acquires
+		 * holder_data after the cmpxchg below is guaranteed to observe
+		 * holder_ops=NULL first (cmpxchg provides release ordering), so
+		 * its subsequent store of new ops will not be overwritten.
+		 */
+		WRITE_ONCE(dax_dev->holder_ops, NULL);
+		prev = cmpxchg(&dax_dev->holder_data, holder, NULL);
+
+		/*
+		 * prev == holder: normal release.
+		 * prev == NULL:   already released by kill_dax() when the
+		 *                 device was removed under a live holder;
+		 *                 not a bug.
+		 * prev != holder (non-NULL): fs_put_dax() called by something
+		 *                 that is not the current holder; an API
+		 *                 contract violation. A lock would be needed
+		 *                 to guard against this, but we WARN_ON()
+		 *                 instead since violating the contract is
+		 *                 a bug.
+		 */
+		WARN_ON(prev && prev != holder);
+	}
 	put_dax(dax_dev);
 }
 EXPORT_SYMBOL_GPL(fs_put_dax);
-- 
2.53.0



