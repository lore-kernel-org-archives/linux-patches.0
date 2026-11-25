Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622104;
	b=5D/hRnSZ8OLFKqxH/yqvOUUzVhIud5wGWVYx9aFrVsH6QA5RPITVPlpIkFEtH1m9cd37
	 uz7/qyZOGBZBPzXy0i11Ek+DGzdmj4y3D54ix1NWY0q9p+YuJB+a8yZS+U+0eoQZl/vW8
	 dS1E/iR1W4TME9tXt6IW1hu4gn808qkVBqdlwGFL6+p8kTTeD+kcnGAB9rdKH0IXmiFYo
	 6E9dE2lZEOS1VWEMwFhk+bo77tuJWsRaZ4LUOmOuUGhj50TkYkVXAJLXqMRhzYnrvBYdD
	 qOctHS1A9QBnSuEvNtl69hSBPMWcX2L9n9SuLGWqQaMCU9MmUUyBYdzQzuzsJGMQBUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1zddXNkAhxZUufstEaSC70GPNZTTiDDxUkMsegWR1Sg=;
	b=OTO071rtXuHIWZNCAWzk/5qwwI28LHca7QwiUNuvy5wW1I4gtpOnbJQsSnCan6t3mv1V
	 K1VHZBzMr76UnAgbxiB+b9w2ywToTiIiXXR9ttU4SyT31rajj6tCmFBkUU8AsrWdeIgSR
	 sxq2uXAqEjQPuT6gH0ZNgmTrawQSNc7IeHlqpG50MFIEqnmEB8GDbmemE909EftEZXMCg
	 JZp3jUJVLsbPr55LouHqPg9fMB+3BAFaazrflTyDBJNdiLUtZ7DgkPKWcK3pFnFhIM4HK
	 kYRzeoiUeTAKuCMHNIDkqcam2X6e2mI+S5vvuS4WKHt/z+TZjXKVaSmaAXgzc0bfT8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eBriW6Br;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D43F606A321;
	Wed, 25 Nov 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eBriW6Br
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645591F000C0;
	Wed, 25 Nov 2026 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622103;
	bh=1zddXNkAhxZUufstEaSC70GPNZTTiDDxUkMsegWR1Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBriW6Br4Pt7GuHKUVprelAgpssr3P5VUlR8Vy6xyrlAdHFRb5rwQ5KTA3MGVE4AL
	 q4MEXtV5KuKXGkPm26GZSixXwS679btffGYePQpNo5BazTULS/PmWIWKWO7xtgvTIB
	 F2+pYphFY8Td3v1xVQAwZkf0+qP8dm+a873oQQEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 405/990] af_unix: Remove gc_in_progress check in unix_peek_fpl().
Date: Wed, 25 Nov 2026 15:29:32 +0100
Message-ID: <20261125143831.586334618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0edbc945eb9edd0086f25b151a79cfe4adc0dfa8 ]

unix_vertex_dead() and unix_peek_fpl() are synchronised
with unix_peek_seq to prevent GC from purging a live
socket's recvq.

unix_peek_fpl() skips the synchronisation if gc_in_progress
is false.

However, on weakly ordered arch, GC might have already
started working while the write to gc_in_progress is
buffered.

This does not occur on x86.

This is an unlikely path that happens only when AF_UNIX
fd is peeked so not worth complicating.

Instead of adding memory barriers in unix_gc() and
unix_peek_fpl(), let's simply remove the broken short-circuit.

Fixes: e5b31d988a41 ("af_unix: Give up GC if MSG_PEEK intervened.")
Reported-by: Qihang Tang <q.h.hack.winter@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104162858.991930-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 1007e110e377c..fc1828e01bdbc 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -330,9 +330,6 @@ void unix_peek_fpl(struct scm_fp_list *fpl)
 	if (!fpl || !fpl->count_unix)
 		return;
 
-	if (!READ_ONCE(gc_in_progress))
-		return;
-
 	/* Invalidate the final refcnt check in unix_vertex_dead(). */
 	spin_lock(&unix_peek_lock);
 	raw_write_seqcount_barrier(&unix_peek_seq);
-- 
2.53.0



