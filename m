Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6C1891D5;
	Wed,  3 Jul 2024 10:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004294; cv=none; b=arN75Lu9b/4RVWicLn1w9RfrXo1dUOnVLoqZ00zR63St77DuikAnSEiYPmpppRyvFT1akYp+rVBpfVG9uT3w20ogfaQ2w16Jz2GtQr/KfmpN794/mHt5/rn11aUzzw6o/E+6rUBSaDu3fwjigzqnAG2Bmq9jkiVmJ2e6UFb9Kmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004294; c=relaxed/simple;
	bh=xF6gG80Yuwc/PcsRqwKlxysgqLjfLMVTnngJHkE2Mfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9F95C6dDaILu80iMQMDDsydMi8C1tdgtAXWjwusWSlkQCZjl1vN2wlq6tVVlItVI6YrmFmPSnvP2T1OD7RKDVztt9b+MhxJoA8SvXmTf/5O9JgWEbPXU1BLLuPoXqktRgdkSE/GziACN9+cbX4ptFDijvw343z35RQaMNP3jZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPC8IYE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPC8IYE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9303C2BD10;
	Wed,  3 Jul 2024 10:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004294;
	bh=xF6gG80Yuwc/PcsRqwKlxysgqLjfLMVTnngJHkE2Mfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPC8IYE4/ntjLMWp+OltVfgAnvehalNLYmgu2QW12PcgNz1Ug5cJyl6nhTgRxqucm
	 gVqbrgpvZHRHXqwNArw/vup43q3iOQnqJKjhuH/vh+j8HIxqg3/Y0jC5WrITyDh8yw
	 HII4GpwCHihyBC7K9mPJzU/9Cq9hsSYb4jIXTtZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.4 184/189] nfs: Leave pages in the pagecache if readpage failed
Date: Wed,  3 Jul 2024 12:40:45 +0200
Message-ID: <20240703102848.416908201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 0b768a9610c6de9811c6d33900bebfb665192ee1 upstream.

The pagecache handles readpage failing by itself; it doesn't want
filesystems to remove pages from under it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/read.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -103,12 +103,8 @@ static void nfs_readpage_release(struct
 	if (nfs_error_is_fatal_on_server(error) && error != -ETIMEDOUT)
 		SetPageError(page);
 	if (nfs_page_group_sync_on_bit(req, PG_UNLOCKPAGE)) {
-		struct address_space *mapping = page_file_mapping(page);
-
 		if (PageUptodate(page))
 			nfs_readpage_to_fscache(inode, page, 0);
-		else if (!PageError(page) && !PagePrivate(page))
-			generic_error_remove_page(mapping, page);
 		unlock_page(page);
 	}
 	nfs_release_request(req);


