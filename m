Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035224;
	b=etCANo25VaE4EKqnrxoASCyxoaHlgfU3O5ElLHJgvC6Ldqq8drDH+OkeN7j/sl6+Y1K/
	 hefKvAqWt9FItvM/j4mh4rwEfSz5h1CrIbZIuXqwsdNJ1fNfyAJosW7qHs4haKFByZMjc
	 z0E24RQ4b8utB/STs//1sif1TpnYq2p+A1P9r0pRG5f+G4MCBMk2HTvR9k7D0KWHKar0z
	 57121zzR0G5T3639AFA1nP/K1wwOnhe5ojAXa9HTExsZHwODkKGo+AjNI+JavipSACivl
	 y4+lix+E2MLcBzQ2IsnaVTaNQmSLGcJ9RhckMu2KO5qFcIHXQjy4wcVAAIlw0TG0jfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z0aRU/r3xRVyMnV8rSINpz9Lsg5jLiXDgpMKQo4l2pY=;
	b=Umc403EjmHk2xhX7VpdUQYgV2Hji3HVKanUm+QD45RAc6IGS4NOiK7gxhxxtIOWbZf0K
	 A76eLofp7eB0lOIuPLxUeJogCZuGJHm3vvIHllBJhT/JJM/bB4wffRWZPjAxOjrtjX+JF
	 aO8ob9t8lw+xb+RXZir58pjFRqayG5kJWzHeHLEbRZzCL+wKpMyngKpskfvcHD+WWrUMj
	 1OL4rTw7yEEuDlPQTIUbkIlvnePbrDdItZOU915o/qc1TuU+5LAQvLVm7l1nYKvQZy1si
	 itgERCxWwJHtHQO+QHgV95al5F4c5Wut3rYW5wIMrbEjNCgTPrUTWTs52qYBgMjZBJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QTH7w8v/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6760A2614;
	Wed, 18 Nov 2026 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QTH7w8v/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA251F000CC;
	Wed, 18 Nov 2026 20:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035223;
	bh=Z0aRU/r3xRVyMnV8rSINpz9Lsg5jLiXDgpMKQo4l2pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTH7w8v/s7T1Ox5z6Xo6oRwAY56k6IK8xC8edzBnYNE9i7PtCgfjxBzl9hzOnDDiO
	 3AgtiSvrICsGkbHclxf3/EY4wKuGlMMkjdte5/wPBX4KNNhZMX8LesAxRUxUCX/RR0
	 aRL2AOvUC3u+nkZDVrBQ8DZ58kgRwbGvdpihPvfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0589/3318] lockd: Fix use-after-free in nlmsvc_retry_blocked
Date: Wed, 18 Nov 2026 15:20:11 +0100
Message-ID: <20261118150335.244927545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit f5b7634f0f213299a07b461fb10385c8639a4ab8 upstream.

nlmsvc_retry_blocked() examines the block at the head of nlm_blocked
under nlm_blocked_lock, then releases the lock before calling
nlmsvc_grant_blocked() or retry_deferred_block(). The nlm_blocked list
reference is all that keeps the block alive across that window.
nlmsvc_grant_blocked() does take one of its own, but not until after
the lock has been dropped. Unmounting the nfsd filesystem while a lock
request is still blocked reaches nlmsvc_traverse_blocks(), which drops
the list reference and frees the block along with the nlm_rqst hanging
off it.

  BUG: KASAN: slab-use-after-free in nlm_async_call+0xd6/0x230
  Read of size 8 at addr ffff88811b04c808 by task lockd/8377
    nlm_async_call+0xd6/0x230
    nlmsvc_retry_blocked+0x61c/0x800
    lockd+0x144/0x1c0
  Freed by task 8392:
    nlmsvc_release_block+0x231/0x290
    nlmsvc_traverse_blocks+0x139/0x1b0
    nlm_traverse_files+0x1aa/0xa00
    nlmsvc_free_host_resources+0x12/0x60
    nlm_shutdown_hosts_net+0x127/0x280
    lockd_down+0xd5/0x1c0

Take a reference before releasing nlm_blocked_lock and drop it once
the retry has run.

Fixes: 0e4ac9d93515 ("lockd: handle fl_grant callbacks")
Cc: stable@vger.kernel.org
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-nfs/20260818235808.3458075-1-shuangpeng.kernel@gmail.com/
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260822-lockd-retry-blocked-uaf-v3-1-761661eae60c@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svclock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -1040,6 +1040,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		kref_get(&block->b_count);
 		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
@@ -1050,6 +1051,7 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		nlmsvc_release_block(block);
 		spin_lock(&nlm_blocked_lock);
 	}
 	spin_unlock(&nlm_blocked_lock);


