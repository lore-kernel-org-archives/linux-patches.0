Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948523A7F4C;
	Fri,  4 Sep 2026 05:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499002; cv=none; b=ebe9hoB1WbPK+l0nN4wxB0vu5nH9Gjt4eh1VLuVjA6bdDRjtFLqw+xfTOnsyaWjwgm3Ao/Y6oK/RKYmMG7gqk3dd9899ZB/Uo441ykYawAToF394XFsbiJ035Yqc//rE8k5P+h7FfZ/dmh4pQHdHcBxO/7z1BZpdvM/DBmPCYAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499002; c=relaxed/simple;
	bh=7jSpbRY9fXCU8EGypVURAzd6ATUViw+YdJXemDI9dgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaCyUhPjYb3cdML+Gx7on4KElhAzz6w6V4GILShGp7XzcnVFFafAysVPFyox42N0Gwm3Zx2jDqzq9YQcB7fbljlJbaq+zJR5qxKH2QkLTZow5aDXPvTY+qLU76YiO9gug2eXSNlRedvgdHlP17r6souFfxffUNI+ae/R9qUeE58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UM8+M5eL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UM8+M5eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE341F00A3D;
	Fri,  4 Sep 2026 05:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499001;
	bh=qU3uOuB7LM4KvOTFy5L6HFmGYF7CImgWn2RW32S8cpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UM8+M5eLwbJA6gwx1YGsfKmO1h28kiPXwJ5ww4CGZmlVofnjA4BVpvzE8pTob3TG4
	 WX+gGcD250RkOnFZ9N2y7Wu2amfe/AG2IX4Ste3EVVt6q6TsIvPYny8Q8SXcyflLOm
	 qIo3o3lPXllTYUj5XZzJCdmqbIdd9dA7fUZ0NXlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.2 261/713] fs/ntfs3: validate dirty page table on log replay
Date: Fri,  4 Sep 2026 06:53:49 +0200
Message-ID: <20260904045809.687840622@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit 006cb7713dec10368e699abc4367e5faa334c9a5 upstream.

Each DIR_PAGE_ENTRY ends in a page_lcns[] array whose length is the on-disk
lcns_follow field. check_rstbl() validates the table bookkeeping but never
checks that this array fits in the entry, so a crafted lcns_follow lets the
v0->v1 conversion memmove and later replay passes run off the entry.

Add check_dp_table() to reject, right after check_rstbl(), any entry larger
than its size claims via struct_size() (the same expression used to allocate
these entries, so the check is overflow-safe by construction). All consumers
can then trust lcns_follow as the real capacity. This covers every
page_lcns[] access whose index is bounded by the entry itself (the
conversion memmove, the HotFix store via find_dp(), and the self-bounded
scan loops). Accesses whose index comes from the log record need a separate
bound and are handled in a follow-up patch.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -789,6 +789,20 @@ static bool check_rstbl(const struct RES
 	return true;
 }
 
+static bool check_dp_table(const struct RESTART_TABLE *dptbl)
+{
+	u32 rsize = le16_to_cpu(dptbl->size);
+	struct DIR_PAGE_ENTRY *dp = NULL;
+
+	while ((dp = enum_rstbl((struct RESTART_TABLE *)dptbl, dp))) {
+		if (struct_size(dp, page_lcns, le32_to_cpu(dp->lcns_follow)) >
+		    rsize)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * free_rsttbl_idx - Free a previously allocated index a Restart Table.
  */
@@ -4294,6 +4308,11 @@ check_dirty_page_table:
 		err = -EINVAL;
 		goto out;
 	}
+
+	if (!check_dp_table(rt)) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	dptbl = kmemdup(rt, t32, GFP_NOFS);
 	if (!dptbl) {


