Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831414;
	b=iY3Tud8rX+zxagJ8b2TdVADf7iAnb+Rwt5mwM9QjI/C3YwY/dYX9ttDokWSrbcTCmjfb
	 42D/e0wc/222rMZxQzaYq1nrrKiZACmTSB9SqZ1tgvAk4Phjiy4bH6MgCDtGWYHCzHUgS
	 pykVcNlaLTpljCYQqq7zOYpyeXKvNcZG6IEgvJM4e8KB9X+pKaQMjyCFdDLNvo6jqWpNS
	 yc5nLpsiWSAyXHYtCFUctk/jU+GHv/64A1OxUVMIKY0qXumamftjCoEM5raWjoaBX6/AN
	 5le8BS/cO5yjvBEaRDE755woJi1w0cSLL3zoZqEdcNFY2ZejWTvqPfJJDU0rGbDiRpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mm3MHz+aDp2PjkRKNN5XnE6IaijVZTqtB37uzSZIVVw=;
	b=ZRYczTJk+vSR4A027BcDxYU5zyUkwGvpfwpisD1C25bo1KVQH7mFabmHgQKDB92Dplns
	 e9UUD02ajVZuTZ60fxSNtE31h90BE9Wow6r0cz5tbLJyNZNPYtucHVULAsnD9hzKkU/k1
	 2f3v8CEsOwhRnBiDn0VSEGJajTn05Ll5VB36keKy8/PTb5Dh0CSuMsIpwK+8IJSx75FOh
	 h+RnOw0WVTRABK1rTqSmwxT0W3IThTK5/KAn+c7ob++7RR10mC+XFwcMeBa92yop3Wq/w
	 T541kBUOBIQJ7s5iYSQfqp29CEJ+6cDETWDRvx48Q8rRwthWwhyl8ACeIZUBS//fG2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIMoq9Iq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04802606AB0A;
	Wed,  4 Nov 2026 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIMoq9Iq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6731F00A02;
	Wed,  4 Nov 2026 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831413;
	bh=mm3MHz+aDp2PjkRKNN5XnE6IaijVZTqtB37uzSZIVVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIMoq9Iq8uXBVy2QauUWUCy4VZuazbKi+oaVkOb6/Dk21DZRZKgjiUFVTGi8EcWE2
	 wCgmm5FwUC+u2wMkliiGn27LWREW2D5tgGpY0KWV9r1cIEYfKWEptiskZ70eVBLQ2z
	 FWunr/H4aCqCOL2s1AidgHtHKLgKxQotNZLeEOTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0673/1005] lockd: Fix use-after-free in nlmsvc_retry_blocked
Date: Wed,  4 Nov 2026 16:06:46 -0500
Message-ID: <20261104211102.497159911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1048,6 +1048,7 @@ nlmsvc_retry_blocked(struct svc_rqst *rq
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		kref_get(&block->b_count);
 		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
@@ -1058,6 +1059,7 @@ nlmsvc_retry_blocked(struct svc_rqst *rq
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		nlmsvc_release_block(block);
 		spin_lock(&nlm_blocked_lock);
 	}
 	spin_unlock(&nlm_blocked_lock);


