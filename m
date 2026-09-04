Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F12358378;
	Fri,  4 Sep 2026 06:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502226; cv=none; b=W3YYD4mZLKgx1fJD4g0TBcV4vMbKkc1vEVkXP0nFF4GCiAxU7s1f6wTl/CLVlaetIwTL6LiPLRhMuKsfySWcvWLuf8AJbjdpFnfosgNs/kbzNH2KLEgPtBwAWZkY7mp7PPVWQPp5fZMoJPQN78YB+KlPF9TExfJyqumeQWEjQmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502226; c=relaxed/simple;
	bh=3SPSm/P+CL8cP8jppv0kXqL1Fdubr1tX7dFvhaTTVuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnhJFymtJiTBz9RL8rfa4/45PaTPDu0F8pMZwwU1txOSDG8H7OgQOVcyWVY7vIF5T8n0IiIEf9dYs/KFDh6JPw7kMCSUO5nO9E2V0QpEdcHaLYcdCEWXl8RYyCPUQyflfeHibNR7qJMpukGplbYz4FaIObr3m/9NhYl6E6UyZ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK3ea2hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK3ea2hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5741F00A3D;
	Fri,  4 Sep 2026 06:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502225;
	bh=MiebpDIdfFt3fUxpn1aAlK6Yh5jDtnOpYhGWzK1YxTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK3ea2hvoObl4J2kTQ57PjPInSRP4AAHh8JT7jrT3WoXsRSpn35IJquL4KxA3sGDx
	 5nnU+ZcXDCKR470lrez7W+kPVu9lESGCHwXHxNbcLjfMdHWgDXIBpxeBoihcepWaoS
	 JfAt+GibaunbxlvftBXG4GIJNlIYiqDEAkmkEVeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 131/403] fs/ntfs3: validate dirty page table on log replay
Date: Fri,  4 Sep 2026 06:58:54 +0200
Message-ID: <20260904045737.816007233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -4281,6 +4295,11 @@ check_dirty_page_table:
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


