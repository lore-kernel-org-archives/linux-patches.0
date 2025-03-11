Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61AA25DD12;
	Tue, 11 Mar 2025 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705780; cv=none; b=Fg6CETx6oQByRJFeT1xBPvPvH4Xbo43qpYzq4aJ/q7wqcnGNDesf7HZyTYdAid9aHNF5H/1mFlgyXSVnHX72so8RIqeRLMatBelocLcWoEXJA3VE2UqyjFyfnWRjdSTMKO+o4tVa8GyHPX58KTMaZFHiVUQWHl3t9nYr4qhjLdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705780; c=relaxed/simple;
	bh=J3xqvYgkchS35Ajf2LtGKLqrpugxWlTOHiZGdQs1wQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHD+RiVMzaJIm2TEe0AKPJ8D+o/1EbOVUx8M/YSabA189RfE+JQNwn3WIDZLROUmDLLgb3PIOr8pkqDhflHqKuO8DWHN3DNC3Xo2tXZV+uaWGBhsAHKFdj4lRf4yf2Rt/KcwKeEDBmX337BY3inzi1aNeUFwOH24GN1pjASwdZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+rQBKlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+rQBKlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BE0C4CEE9;
	Tue, 11 Mar 2025 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705780;
	bh=J3xqvYgkchS35Ajf2LtGKLqrpugxWlTOHiZGdQs1wQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+rQBKlQSc3HWEHDuttvMgVk5P+3xIGh6sbud1hoUYzYqtscZwm3v0WAEg6V6lCPE
	 WG3G2MMbvC+uMwKnIHX317qYXn1XnGTmU4yBrJ74D9Z4RoPDB2xUlSiLdIsGwQkPZy
	 wNjabix5Ot+pvMbkwRi0/5AmegFBt9Hc3XTuXHGo=
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
Subject: [PATCH 5.4 153/328] ocfs2: handle a symlink read error correctly
Date: Tue, 11 Mar 2025 15:58:43 +0100
Message-ID: <20250311145720.988766654@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


