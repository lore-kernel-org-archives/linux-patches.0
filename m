Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1E7257AD8;
	Thu, 17 Apr 2025 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914909; cv=none; b=Ke4IwCMFDAYYIzCmWWoLR2qAdvQaNK92BTqhG0rLpjZn1vr3rxI32usO/FEbgJ/8Ksiv+6PnF0DFMyzuIQxzI7y1aMbC0RdtLyw0btPlE20FyFB3oKXpN9iIQCDHQTaJ7ObZ/lk+ARhtkTxyxJmP4yX0SgSuib+mSCVtCHrf3ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914909; c=relaxed/simple;
	bh=ljBl4t2tOHu/keZb62NmldklrcI8sGwrMXWE5mXD420=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFuNhnevmwvA8geCM4HNS3JdEj58t6E+4I7/htfL4WkbkokgXVqpSp1UXLZ0OpM0/TKZLJr3sKGzcL0FKDUZF7ZNjvkz/BDXsQryaUyZPBfCLSXy6/uO3UkFzXQuVa8i4w7WyY1ovH6EAnuCBFNdtNu2Qb8O4gXTmCgGR+KiRAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIUmeU4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIUmeU4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB4EC4CEE4;
	Thu, 17 Apr 2025 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914909;
	bh=ljBl4t2tOHu/keZb62NmldklrcI8sGwrMXWE5mXD420=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIUmeU4wWGGSqRbCPJ/W+VendCikwc/iwR6l/SQLwE432bTIJrQ4wLU05gMnCe8gU
	 bQx5nKGohrtVuj63C+bOehojDqAimhu4/cKSTItrSupW23nwiieGKu9Ksbr7FsCwKV
	 724mXqBCnBv3QOl0r1+FMScdYK127Q1vHqnupeQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 369/414] landlock: Move code to ease future backports
Date: Thu, 17 Apr 2025 19:52:07 +0200
Message-ID: <20250417175126.306882200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 624f177d8f62032b4f3343c289120269645cec37 upstream.

To ease backports in setup.c, let's group changes from
__lsm_ro_after_init to __ro_after_init with commit f22f9aaf6c3d
("selinux: remove the runtime disable functionality"), and the
landlock_lsmid addition with commit f3b8788cde61 ("LSM: Identify modules
by more than name").

That will help to backport the following errata.

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-2-mic@digikod.net
Fixes: f3b8788cde61 ("LSM: Identify modules by more than name")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/setup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/security/landlock/setup.c
+++ b/security/landlock/setup.c
@@ -19,6 +19,11 @@
 
 bool landlock_initialized __ro_after_init = false;
 
+const struct lsm_id landlock_lsmid = {
+	.name = LANDLOCK_NAME,
+	.id = LSM_ID_LANDLOCK,
+};
+
 struct lsm_blob_sizes landlock_blob_sizes __ro_after_init = {
 	.lbs_cred = sizeof(struct landlock_cred_security),
 	.lbs_file = sizeof(struct landlock_file_security),
@@ -26,11 +31,6 @@ struct lsm_blob_sizes landlock_blob_size
 	.lbs_superblock = sizeof(struct landlock_superblock_security),
 };
 
-const struct lsm_id landlock_lsmid = {
-	.name = LANDLOCK_NAME,
-	.id = LSM_ID_LANDLOCK,
-};
-
 static int __init landlock_init(void)
 {
 	landlock_add_cred_hooks();


