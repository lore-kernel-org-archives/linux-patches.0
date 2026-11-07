Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061521;
	b=EZ+MM3DVwSmOedcM5anu0qBS+h/mw8tgrelF3iqZuiozvRvUIr2jQyzXaCqtbL7UCKle
	 DwOyKouQauednv5U+wszHMoMuvvxxMC/gYum4JQ7DBYleI3/QMkWcCL1n5Pfe/f+Lbu8E
	 qQvodmls/ipmBDCmdauCQEVMMBRSEX5J5ih55XJwf5n+86E2ilAzK4A7zSUFmdPfNG/iL
	 b17CZKtTYdbSaMuNTl45vGDOw0EiLjDR2IiPLgepS+uOBGZcUHET/505BngsxYpbALc3X
	 YNCh56KOnr5w1lKUAQLv/24vBr3O3zjqEUbE4UnheZnNN0yv008T3ye5RnVN6kXoDEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QmwyJlZHzmJNkfCVQ5uDYT3e37PQt3WXQ2aRNo4CPFc=;
	b=ZG8kdsgfzLX9nSqH090zN17NgX07YRtlQHtAzpmwN76h0w5koTQNRAab14Yn4uKg1GfY
	 yuwHHqA8uYpuMPfe68y5ftBHwaGV2uRMpaUGLIJdQk7xvRBEqWyU3oF3/Q1sHCd82JXKC
	 QFVZRjYJ/CjgdLfS8KntxyMRj4gppd2CviUv/xGxqf8s0iFq1OxyJ94jCqz5295zGPesk
	 Csy3TudSs4SArCjuSSKHNwYqjXCxCtPbfDyQoj/21wLEKznfPZPsTgBa9OE2+s0Z4KWK6
	 ScO3VywJ6klqy3DUemmAz8M5c3VlYazq2XatVi0YRkix36dJ2/3nrmUNDFIqP9lk82A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocwSDS9u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6B5606A32C;
	Sat,  7 Nov 2026 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocwSDS9u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31451F0089F;
	Sat,  7 Nov 2026 14:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061521;
	bh=QmwyJlZHzmJNkfCVQ5uDYT3e37PQt3WXQ2aRNo4CPFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocwSDS9uq3JFBoSSnQLxrdK9EVMcazauajBnuV+AjMAfK3kfJ5HDwe6waxA3VU69c
	 bkWKvJdGfS/u9V1kKPJfix3sJhR8iG0H62iAeZGKQOKN5I/9QV8WRcVKO17f9Rctxn
	 CWnRaDuO3jKTDuK8RKDW3X4y6dpq+aU1SvJLo820=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0609/1536] lockd: Fix use-after-free in nlmsvc_retry_blocked
Date: Sat,  7 Nov 2026 08:43:45 -0500
Message-ID: <20261107135014.643068335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -1051,6 +1051,7 @@ nlmsvc_retry_blocked(struct svc_rqst *rq
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		kref_get(&block->b_count);
 		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
@@ -1061,6 +1062,7 @@ nlmsvc_retry_blocked(struct svc_rqst *rq
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		nlmsvc_release_block(block);
 		spin_lock(&nlm_blocked_lock);
 	}
 	spin_unlock(&nlm_blocked_lock);


