Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D5D1DA4D;
	Tue, 16 Jul 2024 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144848; cv=none; b=ErjjUr25uPeFnxZUo/PLT2smavocQFivyJ81MAsTLGgyZtC4OQIwuOlaun6dpsAwZmZf2z290llZytEm6/EVFkQ/xEEbh0ZSiP6DDK58ZVgJS7AMgWxYiIQ2xlolrphFdGAq758piehNt+hilUxPzd/lgYA9Nh3toQjbdToKT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144848; c=relaxed/simple;
	bh=ifvMzeSXe6SD7Md9fYsH7H6Pk4kzJS0WTGvIh8KxKWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sh55SNyNUHIEorfTWvNNlgKz7QDtv9ihrChIUCjB2xFQiiNnsiEZSxPveoH2ZmyoQX2g24CuzczNViN3FFuPDjUTcjrhot3wrCzTN2KwSovKs2DrhOcFBO+lfX5RmhBdGQMWAZIAnjS7ZgfG5TPy2NCGOnYe/A1fv9g7ZNrakFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/RyIoSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/RyIoSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16CEC4AF0D;
	Tue, 16 Jul 2024 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144848;
	bh=ifvMzeSXe6SD7Md9fYsH7H6Pk4kzJS0WTGvIh8KxKWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/RyIoSJEy/52UFXRW4NuLLaHfV2/5WPJYs2r0JO3zW7nWX26pYq8xCuzvwh67mWI
	 5ajGViE6JgB3fLbyKjRMFos2fbTA1y449bprpm21/0NpXyZv+EMx9k3aHDVeukQQmt
	 gNlKfxuwPwnLWf7fv00qa4p2qT1qnIqggXYnvrP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Light=20Hsieh=20 ?= <Light.Hsieh@mediatek.com>,
	Jeff Layton <jlayton@kernel.org>,
	Alexander Aring <aahringo@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 016/143] filelock: fix potential use-after-free in posix_lock_inode
Date: Tue, 16 Jul 2024 17:30:12 +0200
Message-ID: <20240716152756.613082087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index c360d1992d21f..bdd94c32256f5 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1367,9 +1367,9 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
 		locks_wake_up_blocks(&left->c);
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



