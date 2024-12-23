Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8DB17A597;
	Mon, 23 Dec 2024 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970813; cv=none; b=A8HoFi+UxRi7B+GtFXACL7UlAAlnQ2kxbQiP3/I5AxKiJim9DZdkahBUeAQSthvNQ1skLyLz7mNH/d5BA66vUT10jK/y5ss1zbvH+zbPncCrefH3NnWQVkIvViYV2Kv1HDyJbYT2Vbo9UYB8P2worWXGHoafXGXijml8KDeytuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970813; c=relaxed/simple;
	bh=QhQN8QXxB+Dv+FP2/tleFLw0lZdaqf4s+pwo6mzRTkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rETEFinvIhDhYmgl1wg47ifZ8YuEINqyEwuEM3mxcPSvZIdpB60cBcQbt9Z6Y9+owwrGY9CPEH+VD5fqlkDpVsOctRWcIq7eZbWgZ7l4Q8lNJOPZS6pN1pm03UCR7SRY012gOhLln6JYmab7E3/8crr9lcCOOpCaebsSCTLpUIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1TmQYXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1TmQYXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2349C4CED3;
	Mon, 23 Dec 2024 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970813;
	bh=QhQN8QXxB+Dv+FP2/tleFLw0lZdaqf4s+pwo6mzRTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1TmQYXr8P+b2ylWCf+aJGAup7A7zOHfMpUyDgUqV6OxhIMLJK67tzZO9MHO1ur5H
	 8lRCmE4XRH5x+JmXw/Qs0H3xVvMQUrv9Wu4J6e7q5NN8lD48e06x4UZ+W8eVyZFwht
	 2aqUyFuoX+3tkQ4rcyGBxK92yaynPb69DE6vwyQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Shreenidhi Shedi <yesshedi@gmail.com>
Subject: [PATCH 6.1 77/83] udf: Fix directory iteration for longer tail extents
Date: Mon, 23 Dec 2024 16:59:56 +0100
Message-ID: <20241223155356.624711093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1ea1cd11c72d1405a6b98440a9d5ea82dfa07166 upstream.

When directory's last extent has more that one block and its length is
not multiple of a block side, the code wrongly decided to move to the
next extent instead of processing the last partial block. This led to
directory corruption. Fix the rounding issue.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Shreenidhi Shedi <yesshedi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/directory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -170,7 +170,7 @@ static struct buffer_head *udf_fiiter_br
 static int udf_fiiter_advance_blk(struct udf_fileident_iter *iter)
 {
 	iter->loffset++;
-	if (iter->loffset < iter->elen >> iter->dir->i_blkbits)
+	if (iter->loffset < DIV_ROUND_UP(iter->elen, 1<<iter->dir->i_blkbits))
 		return 0;
 
 	iter->loffset = 0;


