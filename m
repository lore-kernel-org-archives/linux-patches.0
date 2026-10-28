Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210638;
	b=mqROITcAagCHQwFizxDvlFkTuJSNeRO0pZ7jIK0Z4evmsA0QTVpa06fgfal4lK4x+zMY
	 iYogFMsQHXE1xMG6qjK7JQamzqPDanz2jsIE043hztCM18HWYo/AQHIzuQ8oMPBxMOhIB
	 is8851pt6GBh7ExbM+fIkRQtlXayiyWRHjKx03vKnp4fHkN8X8yhdjFEUFMag4YcF6iZW
	 82fZzIOrOu+/+1ouiw711H51eJlw/6f1jVgrQiWTInyOvN4ky4yM/YQpVZe0OKnjhVcYk
	 tVF3s8j4TF2rthZWxtotsxH4UvU7vCM60SCBNR9uz0VcbrvCWLr4n1tsoi9ltoKxq9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8AUKT1rnZ9UCdYxsIeVXpU5DPRLkYTJrDd6boskTjc8=;
	b=dGjuaeCditzW+pKHw7I/1RShK6Xlcelr4xcbo9xynUW9WMM+HDC98XaYda+5CRLlOwCe
	 Xf0M07K1gQwe6nOqUmfQxbwK0/5fUUinlQv4R1QPLp9sOyGDXGvLsZkTPnA1w8t24bgvD
	 MyVxpCrrhr2IYa2+HfFf81sNWQfRcF8Eg0W/0vkdK5U1HYTMcXaCNSjzsh52mBWUise9h
	 WalT0m9dxlVbdX7B7dw/g1B/id7TtVCix1d3Uu5XKvIWX6uxj19neElDShJDaGWrYnZP8
	 2lFw0Ptr2NbI37TnuVKXuDRHV6fxx+irjkWdCpTM15ZvOG0qLSuvXvpGJ1JyBju6fxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpivml4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADFB606A31C;
	Wed, 28 Oct 2026 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpivml4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD7E1F01825;
	Wed, 28 Oct 2026 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210637;
	bh=8AUKT1rnZ9UCdYxsIeVXpU5DPRLkYTJrDd6boskTjc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpivml4BZ2S1IRYPbVPewNuR5Oj1r5lpOYAjfIZSsygaVDa11X+x2fww8J+tOdrUT
	 11Bfg6VwpreDPX9yPfN9qN5QJhF0QTNi5sNFpRMLRr+z9YEDTYZsgqlom66P5VcD+b
	 LQa6aho6oKPD4vQwpUs416wvJ33NCWEOwEv8JCqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/571] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
Date: Wed, 28 Oct 2026 17:54:04 +0100
Message-ID: <20261028170010.323784404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit 23b26f4408ac3f35a482d2e5cf6fc865d4201b71 ]

cifs_oplock_break() takes over the reference that
cifs_queue_oplock_break() acquired when it queued the work, and drops it
with _cifsFileInfo_put() once the break has been processed.

Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
point cifs_oplock_break() returns without putting the file reference,
mirroring the reference leak we already fixed in the companion patch to
cifs_queue_oplock_break().

This would trigger a crash due to busy inodes on the next unmount:

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)

Drop the reference on that path as well. Doing so before the out label
mirrors the normal path, which also puts the reference before
cifs_done_oplock_break().

Found by Sashiko code review. The failure path was not exercised at
runtime.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Changed the target path from fs/smb/client/file.c to fs/cifs/file.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b776fb2989df9..affb1ade0c15f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4893,8 +4893,11 @@ void cifs_oplock_break(struct work_struct *work)
 			TASK_UNINTERRUPTIBLE);
 
 	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
+	if (IS_ERR(tlink)) {
+		/* drop the reference taken when the break was queued */
+		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;
+	}
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-- 
2.53.0



