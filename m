Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D014C2BEFF5;
	Tue, 21 Jul 2026 20:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667221; cv=none; b=p4qaUYxRUwU9yFxyxLlF7V1pemQI5h6bap2H/G+P5o9Pq7dsDZ9EjuvORNDwawXr7bPcqHTaNh/q+Phvw1y2c+YL5vQ4ZtlmZhgQWe2GP/AGoBUTIYiAokAlarSf5JBUQ8PQ2OXGOmTXkXFjZFZiPL+Z7JKHVZvrrg/1LYzWmHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667221; c=relaxed/simple;
	bh=tY9VD5G2f92sQB8Tl8eIiI+WtX4pxTW9Y+t79WxU5y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdYqN7VfWjJsNJTGa4eLw02yUtwgzqvx8t2iMymbm08OOn/IXnrkcwl7+XGgvH39AnvsLOFVr1VFhOH+dkssMDnjbR1bStPLE6F7dlDJhFk9YaZOHm3ytR6+1PqZ3Veobw0bI7KnnvPmxWq6n1mbgbvuxZ7OTcneAU+dI0XdP7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oa+4KC/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa+4KC/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3721F000E9;
	Tue, 21 Jul 2026 20:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667220;
	bh=YVtB7+uGFKzDn9hvuzX/K/enFS4ej2d08DYm7DVl4+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oa+4KC/5zsM9j4S9EsW6MyjhTQRgrPE9kv59CkO58pJBDd5m8a7W+XQVnIPf44Eny
	 CVkHjSuvXMB/MPAseU0XMEkFud59aLwKntP7FNVqQ8ew/a/x8d4SLxYUUsSmsyMbUu
	 Tb2E9vHSBUtkejW4aNygQJMxGq6UzPUDPdiu9aAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0980/1266] fs/ntfs3: validate lcns_follow in log_replay conversion
Date: Tue, 21 Jul 2026 17:23:37 +0200
Message-ID: <20260721152503.770549087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 6a4c53a2e26a865565bd6a460961e8d6fcb32329 upstream.

log_replay() converts DIR_PAGE_ENTRY_32 records into DIR_PAGE_ENTRY
records when replaying version 0 restart tables.

During this conversion, the memmove() length is derived directly from
the on-disk lcns_follow field:

	memmove(&dp->vcn, &dp0->vcn_low,
		2 * sizeof(u64) +
				le32_to_cpu(dp->lcns_follow) * sizeof(u64));

check_rstbl() validates restart table structure, but does not constrain
per-entry lcns_follow values relative to the entry size. A malformed
filesystem image can provide an oversized lcns_follow value, causing
the conversion memmove() to access memory beyond the bounds of the
allocated restart table buffer.

The same field is later used to bound iteration over page_lcns[],
so validating lcns_follow during conversion also prevents downstream
out-of-bounds access from the same malformed metadata.

Compute the maximum valid lcns_follow from the already-validated
restart table entry size and reject entries that exceed this bound.
Reuse the existing t16/t32 scratch variables already declared in
log_replay() to avoid introducing new declarations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
[almaz.alexandrovich@paragon-software.com: fixed the conflicts]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4263,13 +4263,26 @@ check_dirty_page_table:
 	if (rst->major_ver)
 		goto end_conv_1;
 
+	t16 = le16_to_cpu(dptbl->size);
+	if (t16 < sizeof(struct DIR_PAGE_ENTRY)) {
+		log->set_dirty = true;
+		goto out;
+	}
+
+	t32 = (t16 - sizeof(struct DIR_PAGE_ENTRY)) / sizeof(u64);
+
 	dp = NULL;
 	while ((dp = enum_rstbl(dptbl, dp))) {
 		struct DIR_PAGE_ENTRY_32 *dp0 = (struct DIR_PAGE_ENTRY_32 *)dp;
-		// NOTE: Danger. Check for of boundary.
+		u32 lcns = le32_to_cpu(dp->lcns_follow);
+
+		if (lcns > t32) {
+			log->set_dirty = true;
+			goto out;
+		}
+
 		memmove(&dp->vcn, &dp0->vcn_low,
-			2 * sizeof(u64) +
-				le32_to_cpu(dp->lcns_follow) * sizeof(u64));
+			2 * sizeof(u64) + lcns * sizeof(u64));
 	}
 
 end_conv_1:


