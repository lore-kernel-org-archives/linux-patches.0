Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F3E225A3B;
	Mon,  2 Jun 2025 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876629; cv=none; b=izdVuwgPkAXD1LA0qYcgv+N4gfPRnkA98weTKYLa2rkZv0NYMWsTkuRJ+gw5eO14GETgf0SjxYgy8PY4DJ62s+12mLuudJEmF2lYOWKpXJy4rV8n+WYSaQQJS9uIiADfWBZoz3/QKEd8LYeVPF4RJysooIk1NzA6WbY7QBSDe9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876629; c=relaxed/simple;
	bh=n01z1DpjkqkosL93eEo0kHikx3S1+OyJUbi9u8DFHTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4mdL/g8fGC1viAR+dz6JYhrGMZ8X8KL37U0dISHcVxk2oNkU496yO9CBnE+xC8u+PGMcnZqtKGj49TS6efWQV2vUQk3Q6vVFQ7q74TFZ3dbmWqHhVaXBS6rLIVJ+uSr0sNWK+3xRjnV6eaLz5JnvFYllpdW5QFizS1HUYY0SJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK+ZmFBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK+ZmFBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64990C4CEEB;
	Mon,  2 Jun 2025 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876628;
	bh=n01z1DpjkqkosL93eEo0kHikx3S1+OyJUbi9u8DFHTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK+ZmFBuEC5+k6uePnjJLpo9+iDOy+G9klMjz2YQksKeUOf6oAh7/xryOfZ8esDqA
	 JW8wgjRPWxWeOPzIPfDzBjKat5SsXjjFbs/7zFziOnScOJGB0JT9HcxaZmIQfp3gfJ
	 OJfIZSL2WQXAzJo4nDRDp+DG+54BvTqjwhuXetXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/325] fuse: Return EPERM rather than ENOSYS from link()
Date: Mon,  2 Jun 2025 15:45:00 +0200
Message-ID: <20250602134320.723127466@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 8344213571b2ac8caf013cfd3b37bc3467c3a893 ]

link() is documented to return EPERM when a filesystem doesn't support
the operation, return that instead.

Link: https://github.com/libfuse/libfuse/issues/925
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c431abbf48e66..0dbacdd7bb0d8 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1068,6 +1068,8 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	else if (err == -EINTR)
 		fuse_invalidate_attr(inode);
 
+	if (err == -ENOSYS)
+		err = -EPERM;
 	return err;
 }
 
-- 
2.39.5



