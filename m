Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73FBF9E8;
	Tue, 16 Jul 2024 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144648; cv=none; b=e3QshntwXmiHtS7LS7RuFwF2GdxJxQ8ANNlM1xV+dFQBqwxy1sv9PuKVAh5D2w4rSa73wOdeoA2rYz+zt3ypFh6FC0JO7LTYeFG0ByN8r4QEv142wnTtaB34SZG9B2VskHWlB3/L1ftrzk6Jt9cKQjoVZTxTEkXNQ+evd+ZqGJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144648; c=relaxed/simple;
	bh=7hwpRDeAWOWf6veKJ1FSlqc+qDIXpAnf0GnOr6pJtUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnxtTZuMiAuh66I1hwIog3NCn+v/ycdI0ScgHd9ShhgMpP9txzLtINPQcmTSVMtv7ibsmL+sj3NjnFPSTJIjQwsdixOPvKaHtHp55Iv5E2sqc1RLs1S2ZOznSDy2g40gMNbSF0xTT3HfCB2nGOe1SjNn837blbzPS6MpGjaLKZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c53JkCL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c53JkCL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D8EC116B1;
	Tue, 16 Jul 2024 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144648;
	bh=7hwpRDeAWOWf6veKJ1FSlqc+qDIXpAnf0GnOr6pJtUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c53JkCL2Szm5tgz2fHCq2/xV0NVukvJUE/0BbN6S/G4YskoZldpsJKz3PaMduKaik
	 H0uXIV99FoS0DTCMr9ghAf7NzgqEp5LC/mEb4/fgwSWVUBbh1aV7nGLKZBAVFOI6Uo
	 dq/RCVXKrVhpcWQHLrcapK4tdpn+xXxL2i80X9oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Light=20Hsieh=20 ?= <Light.Hsieh@mediatek.com>,
	Jeff Layton <jlayton@kernel.org>,
	Alexander Aring <aahringo@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/108] filelock: fix potential use-after-free in posix_lock_inode
Date: Tue, 16 Jul 2024 17:31:14 +0200
Message-ID: <20240716152748.250616864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1b3ec4f7c03d4b07bad70697d7e2f4088d2cfe92 ]

Light Hsieh reported a KASAN UAF warning in trace_posix_lock_inode().
The request pointer had been changed earlier to point to a lock entry
that was added to the inode's list. However, before the tracepoint could
fire, another task raced in and freed that lock.

Fix this by moving the tracepoint inside the spinlock, which should
ensure that this doesn't happen.

Fixes: 74f6f5912693 ("locks: fix KASAN: use-after-free in trace_event_raw_event_filelock_lock")
Link: https://lore.kernel.org/linux-fsdevel/724ffb0a2962e912ea62bb0515deadf39c325112.camel@kernel.org/
Reported-by: Light Hsieh (謝明燈) <Light.Hsieh@mediatek.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20240702-filelock-6-10-v1-1-96e766aadc98@kernel.org
Reviewed-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index b0753c8871fb2..843fa3d3375d4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1392,9 +1392,9 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
 		locks_wake_up_blocks(left);
 	}
  out:
+	trace_posix_lock_inode(inode, request, error);
 	spin_unlock(&ctx->flc_lock);
 	percpu_up_read(&file_rwsem);
-	trace_posix_lock_inode(inode, request, error);
 	/*
 	 * Free any unused locks.
 	 */
-- 
2.43.0



