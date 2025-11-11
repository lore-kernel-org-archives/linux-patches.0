Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC94A21D5BC;
	Tue, 11 Nov 2025 01:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823387; cv=none; b=mwFvdVQbWS0pmSpsyqRs4UCCCvlO4fo+GZrlU0VuavlvdwaFAqwXYstUUelg/javxHxULVWzVJiKue1uYqz/Eyr/eTkDQOzjPo/nQsfv1nC7DR5gr1yZjWkgGAg7fEVoiHrkV7Pt07R1mTT5Wia7xJ9RKLgILsrJPXGVqMEj0iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823387; c=relaxed/simple;
	bh=VBBiVTj+Fkvu2GGdRW4gRt9IBKvr7mJTQyCDKrPVLuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwql7KiRovCKG9RlPxAvIlfFyQXogLfrsUQeyJkA+27b3iADjnDnQ5Rj7ObDPCnaKj013e4xb/8xpgfvViRLUjKSK15wNKOCsvfB95xJm21EHTMYdaJOcDn5E4fP8qnfOuVw61F6qO2ohFCdbvWXBIMhDXh+Ke4Ia1J2I7iT3+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGwRHi47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGwRHi47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF8AC19424;
	Tue, 11 Nov 2025 01:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823387;
	bh=VBBiVTj+Fkvu2GGdRW4gRt9IBKvr7mJTQyCDKrPVLuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGwRHi47upAlgY1OkmSo1mI4WCulC+b7IcMj39pvFsb/hDNOYwDqe/rPbKhkN+tes
	 2nca10gUc/VOnaPjftTP4mfG6RCTd8tF235cgwcK/o9Oq8Qk/ByOMIXcqr9t9WSiqY
	 M4lewqqnSw7QRwRSUNgVL8WN/rSDdO5Wxk0wnL2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/565] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Date: Tue, 11 Nov 2025 09:41:33 +0900
Message-ID: <20251111004532.246919686@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5f248a914042..bf31b19045243 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3267,8 +3267,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0



