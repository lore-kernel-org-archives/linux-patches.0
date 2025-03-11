Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B81F25E83E;
	Tue, 11 Mar 2025 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707020; cv=none; b=igHZy7EYiwl5xYdI0G7/NqvitrJMlO3KbS5mTzhIexKps/r7/NLxXaNqdqFYscgskMWx0rFhk3arGomoUV0yjSiF3qGgU+0KWx+DXIoFydLkBntLf3Kh5byuim6lBrtJBisvVim8Wsp3jj3Flfr3i6yfg3/bAb+b2WZpeoq5gkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707020; c=relaxed/simple;
	bh=rqIWR/EXAZIJDGiEnro8nxqOrSyUFp1Ow7tdB4zfqvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5Ey7OIejUbJp2OfXrYDKNAzb13KdlDGwc8+Yo0zUHo90UGcg/uLk2euTxVthGOAuMeb2ywAdmg9QO5Aryysaz7bMRaljPChci6Eug2h74HjDTzLPNHP2FTMk+HteXjvyekRUge2AoAoFSS9sIIXXQ3jP+SmfrVYOgwCnvrjffc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKcDOczq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKcDOczq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE542C4CEE9;
	Tue, 11 Mar 2025 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707020;
	bh=rqIWR/EXAZIJDGiEnro8nxqOrSyUFp1Ow7tdB4zfqvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKcDOczq92XGtnBKZ82JCKP9dGzYgqAWyLUAZ/3wGfrkxLzTS7nBNil8Cd1hivRh0
	 ZYiPVCVNWIQJIc9jJHyRg2xpVSEHW1EA6QWIQFlzWRyHWSgH2db9FoG7QQ9A18TsLz
	 BZS5EAngg0P6Xxq+WdLSX3+5ciVJPXoGE/n/Ls/U=
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
Subject: [PATCH 5.10 215/462] ocfs2: handle a symlink read error correctly
Date: Tue, 11 Mar 2025 15:58:01 +0100
Message-ID: <20250311145806.859791284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -66,7 +66,7 @@ static int ocfs2_fast_symlink_readpage(s
 
 	if (status < 0) {
 		mlog_errno(status);
-		return status;
+		goto out;
 	}
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
@@ -77,9 +77,10 @@ static int ocfs2_fast_symlink_readpage(s
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


