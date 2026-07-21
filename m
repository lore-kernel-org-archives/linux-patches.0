Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5790647012C;
	Tue, 21 Jul 2026 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663699; cv=none; b=CeCphmrlGnDEDUxuMn3sXuBzRdtZAvlEHqDYemRKOYN3c0SYthA7caCC6g06KPQjJhfU+ChsQ78cTeHKOxmLEnINJA5Rbs91z523DIGfHtzt2ymZd0+Lhpyn3ceFMd+bEhb+yZI+FXEZJxQd6/pjDqnm1C8opxhMi6Tfl/mLg5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663699; c=relaxed/simple;
	bh=FQb7ASlSDIWWuixQ2PNmC7aC0Zw+RnCgoPY6EiGO3h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWrSZx+YpbOilk9t2m6dfe1WnwTioLvns7GduNSIXAoegxI+GYJXJiR6l+OfDnhCq5kN3PhDL6vFkg2d7s/3D71N9sQLwjWKE6ylwS+Fw60j9tmRkYgAGJRVipLd95mzV9DkIrH6Jb4cg41Cg1oSyU+pGakC5hNTaFmkZKJGSII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5JD0vvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5JD0vvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724011F000E9;
	Tue, 21 Jul 2026 19:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663697;
	bh=Nv5eBnTswnEtpmXmdqmnBTMWG9mW92uu3CB9hWVaa1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5JD0vvfMhIdgSy7fG+Z+54Zcb2FkpE4+l5n2JcHx/LBZg9Q3tdwgba2fJcxIKwf9
	 1f+3XmoGcMvYPoB1mw6JRIy2u4G9dRwLLrjir9B8zUZ14CDo0/7oi5ymRnMTjonlfp
	 hjATJ6uMR/KmB+voPsmHDF/QsEGn0N+4qniEsjCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 0919/1276] fs/ntfs3: validate lcns_follow in log_replay conversion
Date: Tue, 21 Jul 2026 17:22:42 +0200
Message-ID: <20260721152506.601668113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 		goto end_conv_1; /* reduce tab pressure. */
 
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


