Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD44834B18A;
	Wed,  3 Dec 2025 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777679; cv=none; b=STVnx73apq4uAkzivneU+lUaojOv3p7ckJgYRnwUdygW8ycRyGEIV+A2P8XQG6OhTVMXStIMSxcKxQtvLPIu6dCcz3i80eqtSCMojXZTVCGw/stPUoTtZSkze95XmMSs/uvqPJP7Gs8I3LCw7QGAVPtGIn07qnqnCFLKk6QQcUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777679; c=relaxed/simple;
	bh=fQ8zxJqO0o1aYNR8y1NkN7fSrgwy1b0Qd74fvrHpiuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2pKj38DZtrS8OR3jJ4X12YLWmuJVqdf3OCVzqNmxeNDmgD3KHA8aZgcxwFpWew1Y1Z0ganVYjZjq6vZ7T7BMmQ7Wm2k2qtWASMNXKHzc/4Xnb2pF9qCrUC+W52JLZdf2AACEUplqbxVJ8rAwrMHU9b/+hzYRNyLLBDjouPX20w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMRgbtJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMRgbtJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D9EC4CEF5;
	Wed,  3 Dec 2025 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777679;
	bh=fQ8zxJqO0o1aYNR8y1NkN7fSrgwy1b0Qd74fvrHpiuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMRgbtJB9HPzjSlAFQBBB7H0Uvo/vHhehvTHaIPcdcqsUp2EtUGRjEjxyAhlFkw2D
	 Y5LkBl5lI2nNVz3CDm4wD2Nuabc1wJuJDE6oy6Ftnb6V7Hw5xM407Ipsvm4q9XQ7y8
	 ydmz5FJvFSYBOIOB6+qfUkb002SBwuUADNsAqIVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/392] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Date: Wed,  3 Dec 2025 16:24:23 +0100
Message-ID: <20251203152418.256929577@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 9d85c565a7b7c78b732393c02bcaa4d5c275fe58 ]

Initially, trace_sock_exceed_buf_limit() was invoked when
__sk_mem_raise_allocated() failed due to the memcg limit or the
global limit.

However, commit d6f19938eb031 ("net: expose sk wmem in
sock_exceed_buf_limit tracepoint") somehow suppressed the event
only when memcg failed to charge for SK_MEM_RECV, although the
memcg failure for SK_MEM_SEND still triggers the event.

Let's restore the event for SK_MEM_RECV.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20250815201712.1745332-5-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 3569e1a5f1387..645860eace46d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2858,8 +2858,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0



