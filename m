Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077DA311599;
	Wed,  3 Dec 2025 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776127; cv=none; b=CSQ3n7/kHrDyk6tZQf4ARgSXic+NqctaLGtEMfAZvcR30t7jF9RB0a91mlzMU/sHdd80nkJFfh28vNmSQv0yPt+fyaPJ0zfaTgPWmcs9NMEjuNFVq4/fjxm8Ku+XFdK+SgZyhmI9NX+2FCb/7jaHoZgTENfP6gEImX+osGskGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776127; c=relaxed/simple;
	bh=SOdo/TQ3M1bfhR0ziMgb8w+imrhgrGByQp7A6v9DyI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWZWfzva+ut89+0MVA84tN2A+1P5gh7aH+la8UwIZ6SqX+uNgo0dwN+QhGp2o9CZoQrdbCt4RxHjh8lyMDalbcdmWeWC9+PG+F+Z2eckv35eDQbUL3lQ+jNJop0YIPgyDJsDoTOetWnT3eMsRH9I/1P+HnofoCBucKhmFnaU9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vVr9x0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vVr9x0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A775C4CEF5;
	Wed,  3 Dec 2025 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776126;
	bh=SOdo/TQ3M1bfhR0ziMgb8w+imrhgrGByQp7A6v9DyI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vVr9x0VIn7YntnZLuNZ8pSvi4Pbxlfw5wiFUnVdNOjAB2dhPdUgB30vpi2WtknWZ
	 OAvGBHLImFuWRWS5+++qenqIUXnpDjI+sYEvhVCqTVys2BXvndyiNS8sLh0jYtdztt
	 29iQgF2itM5qS83ePoedkhmMqpSG0KR5WVyE0tlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/300] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Date: Wed,  3 Dec 2025 16:24:52 +0100
Message-ID: <20251203152403.882962141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3108c999ccdbb..37f2a79c23b23 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2695,8 +2695,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 			return 1;
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0



