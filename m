Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208D3A7F4C;
	Fri,  4 Sep 2026 05:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499022; cv=none; b=sSy76GTAgHvqcfaKAlojtVBXfCabDDs70fL6S3/t9T20+HlEkoko7iNOfX9fm0KsvihEsTa8rdTfGmoHGEpvnSBxbcDxEottBng5AQqdSv+xTxV5CeYxzd5g1SQxycggo6N+29HVn545SKseST23dtL/cFEhDe5mZ9wkUwjUVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499022; c=relaxed/simple;
	bh=tqNd+5oK6VUYsOGvP680ZbXMcvImZ3D1tESRVWSKEJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT6LCpsEMjVzrI7GT4UcGZMspBxacJ+N+9L/CnRbXWQ/53RosAugiNpjQBIuTPoaBSmNdrtct1Ro69Om0DWyU9EHU55P/rIc+P5fVE1N5BuQTNLnbnX0gTmxUByyPxTFulOneHpjyIOHWqXbKlOo5w6xeW9WPaF5BM6RV2b1nsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+B0UpKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+B0UpKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5611F00A3E;
	Fri,  4 Sep 2026 05:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499021;
	bh=InrhBO4ZhQ+KX1nst+N4DFO1YyWZgcvoio5emXacIzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+B0UpKcyWgE6xq82uJzsKD09OIXkH2jGOdpZatrKF5B3Qy5h4uwN7YydZvt5EgHu
	 S1cDiO05oh+rF7VqAvDROakkGLJoest4o8sD17nynvZgPIqJ30PYlFPmO50yU6eq/I
	 hnRGSrfcbpLpXEuxEGXuMqfNR+AVm6hGmuZZfMeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.2 263/713] fs/ntfs3: bound page_lcns[] index by the log record
Date: Fri,  4 Sep 2026 06:53:51 +0200
Message-ID: <20260904045809.732709550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -5106,6 +5114,13 @@ find_dirty_page:
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


