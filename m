Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207889;
	b=avJukAR5ULY9hVllIMwQDdYyUfWKkk81MM1LZSUobjvlFHx7opAcbA/6Kg0IaPhstaNy
	 4TFf1siwiybvzR3w4V9lfneN6BKtLXMU/beTAbOSzU2ov6nqZK4+3SsGg5mIiEFYysGQ/
	 OS5zwLykdtoPrrduT4VceCFBFxw7Cs+vSzJQ96XJsVB1yKtAvNNjHzFjWDZVJXqBBZjaj
	 5WaqzZNtF2g9fOqX9G16Rl7c7PryJlf4Ed0poRTr1/L067XgvPMKXLsaSp7PldzRASxYG
	 KjazIPC8/BmElko5RknM92aUgg/CyCyIEoIYQU9ESgUBdd6KjbOjrZ0OgZGzZ5htUFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ss8gsWKtXL8tWq9lYoizefnzjuf+JHEF1DWOOeGmP8M=;
	b=b+xnFIdCZH3aNF0PrDei2Jiz3rawdjilmHWjltd+5ZPzC7bPAqGWMYUNNMtFGK4fzBg/
	 1viTbeaXJk0fGzCuOclR5/fKxjWvBUEodEPlkMyW9c/UhR4aDAwW+pWPNP3yk5jeyI3Ru
	 iQmPGNb7jRYbIqHJPsBdw9fmtwcGvlBcoXiC52pQoOemJBwGZqwDEj9nQdDVLKCjZve9p
	 4sjlyB4kqdBYZfu2MIBab+aMO7KAiaiVngv8WSHLCxuZpxmarvcysuXHQKBUxf8NHnX86
	 OWtzImtXBDKBPWsQ6CkX9LA51d8jtCPyvM8COVanfUcR2MKUthxThHo7r5YyeFUZAcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juClGz3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA38606A333;
	Wed, 28 Oct 2026 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juClGz3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26371F031E1;
	Wed, 28 Oct 2026 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207889;
	bh=ss8gsWKtXL8tWq9lYoizefnzjuf+JHEF1DWOOeGmP8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juClGz3Hyv9BmrunekVEtCPyzWXItyhj5VfUstBQg5wvAqSJXPAkLYjVCxABN1zPq
	 yoBbaiq60Q0DcEhmgoogBptVgGUHnDVzht/1X/v2CLwApUAww2B44gYm7UDB5zFiPb
	 cBPNzFGnjrEqjTr8vNeZw+TV4l/ixrmOA/k3eS9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/247] eventfs: fix SRCU read lock leak in eventfs_iterate()
Date: Wed, 28 Oct 2026 17:58:55 +0100
Message-ID: <20261028165950.531199099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

Commit 1b95382da85c ("eventfs: Use children field for rcu head and add
memory barriers") added an early bail out to the ei->children loop:

	smp_rmb();
	if (ei->is_freed)
		return -EINVAL;

Upstream wraps eventfs_iterate() in guard(srcu)(&eventfs_srcu), so that
return still drops the read lock. The 6.12.y backport instead brackets the
function with srcu_read_lock() and a shared "out" label that calls
srcu_read_unlock(), so this path returns while still holding eventfs_srcu
for reading.

The unbalanced reader prevents the grace period from ever completing, so
the call_srcu() callback queued by free_ei() never runs and the
eventfs_inode is leaked. Every readdir that races with removal adds
another reader.

Set ret and jump to "out" like the other bail out paths in this function
do.

Fixes: 1b95382da85c ("eventfs: Use children field for rcu head and add memory barriers")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index a992c2919f79a..e060dfe7cdac5 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -678,8 +678,10 @@ static int eventfs_iterate(struct file *file, struct dir_context *ctx)
 		 * Matches the smp_wmb() in free_ei()
 		 */
 		smp_rmb();
-		if (ei->is_freed)
-			return -EINVAL;
+		if (ei->is_freed) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (c > 0) {
 			c--;
-- 
2.53.0



