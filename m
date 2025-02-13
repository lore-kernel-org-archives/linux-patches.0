Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D726B087;
	Thu, 13 Feb 2025 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460867; cv=none; b=PPocbMBuUA5Nt+xcDHB8IdBcCkOoBeNgPnKo/F1tQglXjHSCcM6fKHFfRKZiMTTlmCBr7tQcwR7t5XFovJbOPXa2A+vy7H0jK0ar3gCmTYh4NI4xGaj18NA5DEBLb3p0FgT6cdkLGiKjCRNtagmxRZZv1csWKLjVBbacp3JYEXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460867; c=relaxed/simple;
	bh=C59OUwbYByuhAPx40s1qtZXPs7p/Wyy20RGT6bBko7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaBjzgFLG2SHShUEDG3EKxHo5ACBPIMXCG7IV6kkGWlXyk0j2eOPJm29I5QXdlGTuOx1Xn+O8giYTn87YfbFuXcHFCwgwRZfCNTvWGp97dKsC3YeIWq4UiKnrtP7hbPe3Da5OUTe3dz6Q7ZCJeM7p2j+bSHXFGEFpKBJAAihcbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIiVeBCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIiVeBCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE27C4CED1;
	Thu, 13 Feb 2025 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460867;
	bh=C59OUwbYByuhAPx40s1qtZXPs7p/Wyy20RGT6bBko7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIiVeBCO6tuFgBxlv9tJFIt+JcuGfvVD4kJLwOTrHqw1B/GnE4b0sahtLU9E5SiHV
	 hTADmDE3E7At6SFTbf371Hku2iWrngH4tBWACV8i8JTMZhVnRHQl5Y1P4yPZNEBz5l
	 M7P7FfBnfX5yS1WOHu41VNahxr+ltRUPhoumXwtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 234/273] ocfs2: handle a symlink read error correctly
Date: Thu, 13 Feb 2025 15:30:06 +0100
Message-ID: <20250213142416.682174527@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 2b4c2094da6d84e69b843dd3317902e977bf64bd upstream.

Patch series "Convert ocfs2 to use folios".

Mark did a conversion of ocfs2 to use folios and sent it to me as a
giant patch for review ;-)

So I've redone it as individual patches, and credited Mark for the patches
where his code is substantially the same.  It's not a bad way to do it;
his patch had some bugs and my patches had some bugs.  Hopefully all our
bugs were different from each other.  And hopefully Mark likes all the
changes I made to his code!


This patch (of 23):

If we can't read the buffer, be sure to unlock the page before returning.

Link: https://lkml.kernel.org/r/20241205171653.3179945-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20241205171653.3179945-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/symlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -65,7 +65,7 @@ static int ocfs2_fast_symlink_read_folio
 
 	if (status < 0) {
 		mlog_errno(status);
-		return status;
+		goto out;
 	}
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
@@ -76,9 +76,10 @@ static int ocfs2_fast_symlink_read_folio
 	memcpy(kaddr, link, len + 1);
 	kunmap_atomic(kaddr);
 	SetPageUptodate(page);
+out:
 	unlock_page(page);
 	brelse(bh);
-	return 0;
+	return status;
 }
 
 const struct address_space_operations ocfs2_fast_symlink_aops = {


