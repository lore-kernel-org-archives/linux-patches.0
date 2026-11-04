Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827038;
	b=ySOx5FL6wWtPMVjDN9pPrtcMYFs9S9Ly0MUZ93y7j1RbKw0PsSqk7DePsLWhJp9UR6Mq
	 YIN4pUjAcOx0qAt/2Vi5FqVU6Zqy25W/P99Rt5u7QPSewzipOf03hBjIaMjgmOhoVExWB
	 XSX8RPt3GogsXtoknQ/oeqs7SUq8sIWniYOd7j29YoEWoVnIthaok8vKS+E6wfdY2BHqf
	 lW/9Rw1OIowwFMUQy5Ug2ItHkx3hjrI3M2Wp3jwKXJ1f3IOc/Q7kY2NrGOS4EBULQt3+f
	 kEPVbQpycyQZjH7/M2kuxglXCEqCl6PhQB1pc6+RVn0cG0HfVgmYVb9q3yepzgUKTRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bDhKjzqm2eqOlEzpQCNR4nawFJMVPWo9MzWj8bac20w=;
	b=GwYYb0Zq1W+c24mtA4f5JzjAt5PDNwVjlzMyIP7a8azaZpBEMUe7S+WRuHzoZKazMPz9
	 Ff/5CSiiYz3t6jJF8qWtBks9n04kPbhF4tpvfAww4HcAdMVI9CD5jRCydveg9WlXjrHoY
	 69NAigjVYxPmjMcVtpGH5guewjJf+kh3mvqQAMoRhxnwi2AA1qw56Zri8hqgW36DAEtgy
	 c+6slP0ii477g7Nqs1CJsm8pZiqTmzGXWFUE3/1XKBfF9btKRnPUVamu9zTJiJBg1k4Zh
	 tp1qA4yKgI3Omh7Ykq9qHQUpM0Svpt7/7RvVvmlpJ4FLyOGeIZS9ZGpbw7TQokPUEDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuIC9PV8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64386082BCF;
	Wed,  4 Nov 2026 21:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuIC9PV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4BE1F000C1;
	Wed,  4 Nov 2026 21:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827037;
	bh=bDhKjzqm2eqOlEzpQCNR4nawFJMVPWo9MzWj8bac20w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuIC9PV8wRv/LH08yIp5CKkq4fvgUmPOOf9oivzLQ5i4aLCGWl3tT8DlfgjpRhEda
	 N/nSE2oKWL/E5/kyPdzEP5JQqSEAevm3PDZo/FEF+V6BFkYsZ3yw+fqv7XIhZRwmte
	 g4+DJJMZeFW5co6HREA7KtRv6vryr9irPqZHlhL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 157/547] lockd: Fix use-after-free in nlmsvc_retry_blocked
Date: Wed,  4 Nov 2026 16:05:41 -0500
Message-ID: <20261104211042.617412039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1023,6 +1023,7 @@ nlmsvc_retry_blocked(struct svc_rqst *rq
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		kref_get(&block->b_count);
 		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
@@ -1033,6 +1034,7 @@ nlmsvc_retry_blocked(struct svc_rqst *rq
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		nlmsvc_release_block(block);
 		spin_lock(&nlm_blocked_lock);
 	}
 	spin_unlock(&nlm_blocked_lock);


