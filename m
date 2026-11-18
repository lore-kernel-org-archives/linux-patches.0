Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044342;
	b=3HKJigIyk7wiPV73jml9fOEbw9wuDbtx1SMRxQ4ETQqlKMT2iv6E7rllIgoS6mhg/4jO
	 gbN981tlp7RdDmiyyN+L8S0aq/T5NACYL0Odj8vTALGo2dokmb5i3G7QZphFlQyav/Wbq
	 +UkQ1zzzOBABi+ZhGOfQNdA2J0rHAdf7IwGL8giRa+PXAVBX+eZX4o1kVKpZIPVqfnqRk
	 VOuI4+uhiWsby6xFPG7CeJjzQW9/FLfQM4B68mQnb+4Se9vo3jzG4w1LBCoNR9v8msxSU
	 Ar4mxFqDJfkKFfOyuEI1XUn5qLmz2vQHmcuix2lZ/QVM5ZJpcGFvp3oYFkfs+bMFgPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NI+WUsIvRJYSirAZ9fC7HcMRtVTvvonGjPglY9Z+o1s=;
	b=vMBm+Wn4AMrP1Q5hBubFHQJBgqgyRpgVT60biON8uHYkW2xL0fQrH3UWIskX2MIeXeI0
	 YxPSyk+Vv4kNbbTtU3GPo2yz8XRwyhc2pFPh8BVp9H2NsY1fZOtzR1wdqce7bLXFDa+TO
	 p50e9FcEAd/Qyt4XnG1eZ45429ahUw4yyb1+CZb61ANauqbIbBim9+oOh/PJk+eW9up7u
	 opMTC5GFFzeHV9jgPKH0XcwEucQNplPhHDjZQ/MKnVBaPYPTMyg+MfrS7elqpBnKV1Rp4
	 NsPPHyXBfE1M5VUDp164rYO5jPqdURFPVTYdWiduymfw8kDg1NCnt6hm1SM/RihLNdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJdufyZX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F4606A334;
	Wed, 18 Nov 2026 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJdufyZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971491F000C7;
	Wed, 18 Nov 2026 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044342;
	bh=NI+WUsIvRJYSirAZ9fC7HcMRtVTvvonGjPglY9Z+o1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJdufyZXtAVMqCmzYXogHIfbuiuYwWS5H7OkmebXG0sCMfkwviQ7W2A2gGYSEH7hB
	 PO790dSQLNVDFvlWOD3JIrN+9Y5eV3Tmk2NjeYGZuUo2olB2dzHJGrr2MIacBs5qGa
	 IqwS3chtC3BepgannUJTu2ozsp9nyNnr1o61IBEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0534/2857] lockd: Fix use-after-free in nlmsvc_retry_blocked
Date: Wed, 18 Nov 2026 15:26:08 +0100
Message-ID: <20261118150220.710702279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


