Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598417A93F;
	Tue, 16 Jul 2024 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145351; cv=none; b=SWrSUjy2/Pqy4cVUIVjwYk8O935Be+vfP5L2kGQn6Aix59EYEcUye+4UwlXyi/a6Rpf3k8sKXqWM11kk0rUrzKlZex8I3us7IZ3yusMh2ZHoi03XMXxKvqzWU3HHNKT+3lzIMh1Ur8Zr3ZyewJZq5mw+nZbAJh65EE/f5Tljr6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145351; c=relaxed/simple;
	bh=v39x/fwQAmG4AFlPFbJD1bm5u9op7F8mVdsH0oqAke0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oHY+2DPp8bD4FwncL2+pK5nTNHBZdHlB8bbWOiW2PVbVRNQ8cOZgZGfIj6lymsyrbUoePwqsm4Ky0cQQugukpt5UNBnwFfv3PnQyIRLb5fGRS3E/duZopDfZ6JN3bW1et5ARA7xCeigKUYpajqedUc5iLr+MsvyL2hkqjfjDi54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NypBuW4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NypBuW4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7EEC116B1;
	Tue, 16 Jul 2024 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145351;
	bh=v39x/fwQAmG4AFlPFbJD1bm5u9op7F8mVdsH0oqAke0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NypBuW4aVzuU670KET0NYvzqPsm/AG1dgHeHj6ILu5PiD9DbFXT/xnOZfpwMb6awx
	 VOOVhPdxLSn4y4QKwhXTWK2Rd4upCKGFw6Qa23XZ5kiKVfoUx8dIm7m6eQ0EZosTvO
	 VCvWtrcmOs2M4E2QQcaJrgQJnx7Y/qqlDq+hk7RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Light=20Hsieh=20 ?= <Light.Hsieh@mediatek.com>,
	Jeff Layton <jlayton@kernel.org>,
	Alexander Aring <aahringo@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/96] filelock: fix potential use-after-free in posix_lock_inode
Date: Tue, 16 Jul 2024 17:31:20 +0200
Message-ID: <20240716152746.876907938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7d0918b8fe5d6..c23bcfe9b0fdd 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1298,9 +1298,9 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
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



