Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59782320CD3;
	Sat, 12 Sep 2026 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226925; cv=none; b=dx5GZKuXItiPniwsOKS9DhVKmJrYVOus93h2ywc9i4BLlzIfDKdJlO0H5SdotzxBm/kwqP/0mAX0Spw2TgXziui1SJN+1CMD35ez/yvL+G91N34+HhyEEJhvEyhSMlLFRK3g1ZmtkJT/EdME/S+h7tNJXO2uCSHP8O2x8V5IIQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226925; c=relaxed/simple;
	bh=YJN7ad3ODLHsVC9h2V5vkibcoZtGuH89DSlecqeaVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggaee4/dKRhDcwh3GUFDOLJZm7Uxy5jiZrod3cXDI0Stu3DDEC6OCK9vcFRhCd7OpDtMcX4mzi4RRKILiKDxNYty9rC7HH/6ee+60GHYR7cEXeu20Wf98hufOGaMvhIyPXg8lvyYSyff70tYoo2bAO0xzEF7ietD75q2j0SsjH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCS4C13v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCS4C13v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19931F000FF;
	Sat, 12 Sep 2026 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226923;
	bh=95vYejLiBlT25Wlq8GC4CCepJripGTPnZ65pjL+QeOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCS4C13vcHskvpTAJ2n+RIOo4njisS8wSUEjlCnPW78WOFVqS/AtTxJgUEu2yijAE
	 XTrLBnI1AUZ+3Fuq6W3ohPYh6xmvckthFE1SV79hAi2O527oeDBhejixyBQ+bN8u7o
	 YtTADGksYX2hJV0Dmxw8g/Gzv955H9xhWocP70eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0076/1191] fs/ntfs3: bound page_lcns[] index by the log record
Date: Sat, 12 Sep 2026 08:46:44 +0200
Message-ID: <20260912065549.872850555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 6f7b9dbdc1b7520206abce0049bdd143eb536e75 upstream.

The copy_lcns loop and the redo shorten loop index page_lcns[] at j + i,
where i runs up to the log record's lcns_follow. That count is checked only
against the record's own length, not the target entry, so check_dp_table()
(which validates the entry's lcns_follow) does not cover it: the copy_lcns
entry may even be freshly allocated after that check, and find_dp() bounds j
but not i. A crafted record thus overflows page_lcns[] of an otherwise valid
entry.

Add dp_range_ok() and reject, before each loop, any record whose run does
not fit the entry. These are the only two page_lcns[] accesses indexed by
the record rather than the entry, so together with the entry validation
every access is now bounded.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
[almaz.alexandrovich@paragon-software.com: original patch contained changes to the problem already handled, applied partly]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -648,6 +648,14 @@ static inline void *enum_rstbl(struct RE
 }
 
 /*
+ * dp_range_ok - true if [j, j + count) fits in a page_lcns[cap] array.
+ */
+static inline bool dp_range_ok(size_t j, u32 count, u32 cap)
+{
+	return j < cap && count <= cap - j;
+}
+
+/*
  * find_dp - Search for a @vcn in Dirty Page Table.
  */
 static inline struct DIR_PAGE_ENTRY *find_dp(struct RESTART_TABLE *dptbl,
@@ -5078,6 +5086,13 @@ find_dirty_page:
 	/* Shorten length by any Lcns which were deleted. */
 	saved_len = dlen;
 
+	if (!dp_range_ok(le64_to_cpu(lrh->target_vcn) - le64_to_cpu(dp->vcn),
+			 le16_to_cpu(lrh->lcns_follow),
+			 le32_to_cpu(dp->lcns_follow))) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	for (i = le16_to_cpu(lrh->lcns_follow); i; i--) {
 		size_t j;
 		u32 alen, voff;


