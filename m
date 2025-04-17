Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53805256C93;
	Thu, 17 Apr 2025 18:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914727; cv=none; b=r6nrvAhzNOXH3P+PMye6aLKOr4PASGGZY7wCTzxLSiQPWtXAg6exgjKMu3EzNczkb1VX98LsPWqtfoHYmZpWOOcrrEt8JsuRxSM8a2bHD2Qi4N5n4YcAmwpWMiny2Zhb2OeEJV+wQGD4fFQl85BChJI/pflF03GTqeaNDYbY7S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914727; c=relaxed/simple;
	bh=Ksj9FPLZYKTJ1s6Dej8pt4aW1QQAWKg5wJr5OjPxj4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFTRm+YAh1GlICSjBLtADXEjY1JA0c9yiZ5qK9vqb1Ktme/SO8593HKL1wc6AKuVBscxKsJCUVLI441OGJIexhPvYcWfzgzzdvZkgDDRkjAcklkM+6n7oisjFAevIGogZ8yQOF5D0CrULv/WaFMz77CVXO9LlNjRfrdfKfeZpzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECN8T/+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECN8T/+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608AFC4CEE4;
	Thu, 17 Apr 2025 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914726;
	bh=Ksj9FPLZYKTJ1s6Dej8pt4aW1QQAWKg5wJr5OjPxj4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECN8T/+DC5abD+8lmQY538D1REuEruObqxfquPlJrD7pWMHdbUERrJo58FCBa/lss
	 J/5OCMw16BeEqrcM2KjBgxS8saYSorXID/6FMNaT2QvskeunHWmPk61UWCWvqus0NF
	 3JSPeahziZ8z/jFcfPW60PxGeX5oS29I2IZrG1T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.13 281/414] udf: Fix inode_getblk() return value
Date: Thu, 17 Apr 2025 19:50:39 +0200
Message-ID: <20250417175122.727896608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 6afdc60ec30b0a9390d11b7cebed79c857ce82aa upstream.

Smatch noticed that inode_getblk() can return 1 on successful mapping of
a block instead of expected 0 after commit b405c1e58b73 ("udf: refactor
udf_next_aext() to handle error"). This could confuse some of the
callers and lead to strange failures (although the one reported by
Smatch in udf_mkdir() is impossible to trigger in practice). Fix the
return value of inode_getblk().

Link: https://lore.kernel.org/all/cb514af7-bbe0-435b-934f-dd1d7a16d2cd@stanley.mountain
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Fixes: b405c1e58b73 ("udf: refactor udf_next_aext() to handle error")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -810,6 +810,7 @@ static int inode_getblk(struct inode *in
 		}
 		map->oflags = UDF_BLK_MAPPED;
 		map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
+		ret = 0;
 		goto out_free;
 	}
 


