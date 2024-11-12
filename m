Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0592144A7;
	Tue, 12 Nov 2024 10:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408373; cv=none; b=kTaoOSZLWq6EJX2aHuCXttQfYUfNy5xie/IfAYm9CwyQxt4eufbJPb3wV2SgpLe54VhvCBeQ7TJdPpzzVH9uwzyyR0to/Jd5DHe5Efbmn9FBr//7C4vpBuJmoidh83ZAlVMqK1n88hKKK+eEHqL3iWwpqouWOPtXlI8waDfjbbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408373; c=relaxed/simple;
	bh=lextF7+kYxEYiH3fOm2YuESwCR0g7T38IrpFRGMdbcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cd+EzP6u/eSCn4BETFKMKJmGDy1EHtnsiGk3S/qDzEIER3o4qko86AlTFjGWBUDEb/HiDsCI+o3+m/LLRL/DuFtQwUVJ4XfcKhqEEPv2WJAarrJjJy7fzKxE12/8dfIDoNkHlVpq88yHQbmKWAdpMLMiC8O/WLrrp+CyNruTzUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+IswQBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+IswQBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40283C4CECD;
	Tue, 12 Nov 2024 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408373;
	bh=lextF7+kYxEYiH3fOm2YuESwCR0g7T38IrpFRGMdbcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+IswQBIS5di+xyoS8xZCK1e9OroO49k8Xju18VIjSY+nr4LfFmYaFfwVKB78pt+K
	 iR8351nm7bSNt4Z85WleuN5FHW2El/sBfA33I2rAEdJ43yFv8RHEb5WRjxwlqrntpR
	 YAim3x+i3paWkLAUjWEo3NmSZRw0N5ObMRMEzSDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.11 143/184] filemap: Fix bounds checking in filemap_read()
Date: Tue, 12 Nov 2024 11:21:41 +0100
Message-ID: <20241112101906.359040403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit ace149e0830c380ddfce7e466fe860ca502fe4ee upstream.

If the caller supplies an iocb->ki_pos value that is close to the
filesystem upper limit, and an iterator with a count that causes us to
overflow that limit, then filemap_read() enters an infinite loop.

This behaviour was discovered when testing xfstests generic/525 with the
"localio" optimisation for loopback NFS mounts.

Reported-by: Mike Snitzer <snitzer@kernel.org>
Fixes: c2a9737f45e2 ("vfs,mm: fix a dead loop in truncate_inode_pages_range()")
Tested-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2609,7 +2609,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 	if (unlikely(!iov_iter_count(iter)))
 		return 0;
 
-	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
+	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 	folio_batch_init(&fbatch);
 
 	do {


