Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E89341ADF;
	Fri, 21 Nov 2025 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732542; cv=none; b=I3hG2/hNcd/tENtoPK+c4tvOoEfM7IOHIh2jPDehwaJzYuMTvL3vUgySwMnD6ReOQwUpkxwucId128BxjK0gI5a/c67nQ29hoxdg0Ds5EHYb3/X4eZhtKyXiiq0rZxBBcOcBOmA/KaMTu5hJenaiYt0xraRvFhm83vPtrORQCF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732542; c=relaxed/simple;
	bh=cK/Tof/r2vt6I6PLznSHaA1KlHC2whgGHESXNsOzp/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMaK3SeSnSWWVhbJDncwdhMpywemtr+Y+3HHQVJ2eLM1rwsmC3D0gSVSRK0SNsGiuN6YVQOjE1H2bYe+c4POkHNK3c0HKdbFwBn4VqIri3wqKbkUiLVfDB5rFsdGA6a2edFKZPW44+OTGNziCPkxyRI2IV+BJdMgkwwW3Z/5Tbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssgE7xiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssgE7xiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7068CC116C6;
	Fri, 21 Nov 2025 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732541;
	bh=cK/Tof/r2vt6I6PLznSHaA1KlHC2whgGHESXNsOzp/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssgE7xiZYyhbgerPe7JhKMP6zBcJsNmWM7HKG2Ffx3Y7xfpiGno4kgbjKIohUsBio
	 p3Y7SRqqsMpHcG1H9dDMtctdWLSJAXmIlwA6UI0ilF0NllD1qM7SvQJmqxrcQJ3wn0
	 dzJn5xf2ekdtMxkqVPjJoan7jIP4V2sMLjRpmEZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/529] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Date: Fri, 21 Nov 2025 14:07:36 +0100
Message-ID: <20251121130236.605945504@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9918a9a337b61..23c11c656dafa 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3141,8 +3141,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0



