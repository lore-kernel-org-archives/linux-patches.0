Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057752;
	b=5h1bTy6U5r1asb4URsmZ9uK3SABRv/ht8xm5+B0QjyyuGadJoL1wFLYKhB8QlEdHwp7a
	 lyYWC4b/N2ijBQ9bKdNlDursUbRX/H89GXnIu+gX8rE3J6iWF2kPePQHhk6WutUGOhkuY
	 Wrwm9hXIx6GO6GIx//zKRPRtssrJRrCMVNlWc0+3Cc5fLE8e3KzigftQyaVCOcRzCTlws
	 XyESrJqkgk17k/37r2vqzhRc1eX6h5eCZfHG0sr8JGz14nfDM2lk+vfm2VDdSdF2gTBXU
	 ffsvppbd2EA7lXHZtiglOmRg3nFEYkTvcrxtOEExbwZTLDy2lxmsuk7yj7KfF8n9HgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kpf8MDfDaIAPpD444WjCipf9ij/3yWbgcuyHj+3U1ko=;
	b=HQ+lm9JXKkA9qLlb+V1H7N2ZFCGizPfcHtYXAfXlHCY+303Nf89k7jCjS/V9NIZJnc7u
	 jQlKQMUHlpp4q6Y4QJMj/GwQb+ISB5H+yP/rmzgLfXKf2YmzYGFGIMn8wOq2Wr2dRCTeG
	 L8e4qFRm4l7X9bNj/5dEsqyzEOiahNe+IhEIE6ZOF9dfm8cr9jEXc8j8R9ahYii7z9hS8
	 uiIYRS7Pk0IknwncKb8DqWVbd+6j9IobsuDB2kxhSsIiC7ThmwqCz5oilj6UARiRWVhtq
	 g894XHd/1J2bLH0Y6005iKS5iXXviSA2GBxhwil7clKS/yqWnnl1tuIUxkV6VX6O3CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cO7z0BgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE14606A31C;
	Thu, 19 Nov 2026 03:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cO7z0BgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F711F000C4;
	Thu, 19 Nov 2026 03:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057752;
	bh=Kpf8MDfDaIAPpD444WjCipf9ij/3yWbgcuyHj+3U1ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cO7z0BgHAbAEnpmVRHPKUL3mYY0YuxOMI4j7rEKGZOLIivIL8kei4Tr8scayEC3Lu
	 DysMLFUu3HQg/xZuP1WlHqw1TwrTVDcmr85L/dKYfaG6eAC4gFBohKIMjU3UTd7H5v
	 RBLMtZcVa18UVBr8Zli9e8tvsB8/c9ozCH9bVq5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0241/1848] lockd: Fix use-after-free in nlmsvc_retry_blocked
Date: Wed, 18 Nov 2026 15:37:59 +0100
Message-ID: <20261118145921.980948721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1014,6 +1014,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		kref_get(&block->b_count);
 		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
@@ -1024,6 +1025,7 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		nlmsvc_release_block(block);
 		spin_lock(&nlm_blocked_lock);
 	}
 	spin_unlock(&nlm_blocked_lock);


