Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35CD3EB11D;
	Wed, 30 Sep 2026 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795158; cv=none; b=S81svW2ag8uY1IUyYz5pOfb3o9CMsHJ5rdd2vbdvNyD2d2ZIIs2obvIYY/oWOHGKDDF0gukivdVizyiSYG586d9wnMLie0KJXBFFw+9z7aY2UYeQODEoIvnjp4ZtRF1GCnJBPzDISxyt4rzz8Cr2rbnqi1YnYUALkds1L53Hwk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795158; c=relaxed/simple;
	bh=xfc9/GE+VwO0JkVH595shLlcq7vj3khARFyRUkkVAUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS/BLvyt3qdgSsvn+YWsHu+oETiRIjHjMc9OtAvZWrDcj/chqG1swlCVoCtKVzd9Jbc+GFSxRbU12tgQdL8t+Q5/sSK3t2PjJ7rD7BzUsHHSwW8zcuTQrJcyuJ1eJ/yb34l/H8bBFhgrSRkUWqq/H49NFwISjRAbUbeGYOOLS7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqpvZGm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqpvZGm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E79E1F0089A;
	Wed, 30 Sep 2026 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795157;
	bh=lsu8jPk+InTzSfn1cQIlthx4tWbCItgsbMct6zoWof8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqpvZGm9FKdIaVnX+P2mYKgf32jQTQpExYnZ/V7Wrt202IcCoYY+K25o40pUyuBMe
	 nKk5+ule10gz/pcFSTJdrBvquZLKyiCz4RcjHcjndwUiwyP0qMHIhM81W3Fy4IkufI
	 KNqbJGYAaEPFMPGnwzBCf8jY3rsLa2ZhRxNKrR5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0461/1193] btrfs: send: fix lost error return value in will_overwrite_ref()
Date: Wed, 30 Sep 2026 17:19:05 +0200
Message-ID: <20260930152444.413959904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit d0285dfbc3b46f41395b26ee2f4a16d99fb3e736 ]

The direct-return refactoring in commit b3047a42f55d ("btrfs: send:
directly return from will_overwrite_ref() and simplify it") changed
will_overwrite_ref() to return directly instead of going through the
common out label.

That resulted in a negative return value from is_inode_existent() to
start being converted to 0, making lookup errors unable to be
distinguished from the inode not existing.

process_recorded_refs() expects negative errors from
will_overwrite_ref() and aborts processing when it receives one.

Return the value from is_inode_existent() to restore the previous error
propagation behavior as it was before the refactor.

Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_ref() and simplify it")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 4fa05ee81d434..099b5a2e11566 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2157,7 +2157,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 
 	ret = is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_dir_gen);
 	if (ret <= 0)
-		return 0;
+		return ret;
 
 	/*
 	 * If we have a parent root we need to verify that the parent dir was
-- 
2.53.0



