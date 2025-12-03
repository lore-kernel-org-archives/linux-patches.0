Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD8734AAE2;
	Wed,  3 Dec 2025 16:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779132; cv=none; b=EkbZc/7SD2ta7yAnUSg5l19r0RKP7qsk/lOHl5kVspGEp4bdKQ4cprowpHqZtlG/T21brTyQnQ2HdvUqJ+uQRXdQeX1MZlumZXNakdQQdOGvEZhm5p+430/XVOX1o64vfpi4bXFXym10sf/Z6/TniyYzlEzYfiN68k8CocqveUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779132; c=relaxed/simple;
	bh=7ln4ut3eOZVeBkhiZF5e0okTmKrWlPZkdN0aYG9FsLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9Q2gUjLHZPtOFkugZpK5yQLtRrUzcoHbvlMWEh74gdcKU6W0lKqQtg31W3qPZqrGqKrY+5LKs2XodE0w3dTfYzJmTyFq92Xd0429XPxfAwsvrAYfy8/XaRoKgVfF/anADaquOgQkVIN3BV72Qu2OupS4sZO52HjOa2T6gb45zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBzsglBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBzsglBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC134C116C6;
	Wed,  3 Dec 2025 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779132;
	bh=7ln4ut3eOZVeBkhiZF5e0okTmKrWlPZkdN0aYG9FsLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBzsglBmyJJkRQM57vCIZg8U4zikiATdgqDSIE1D/x1e5MezeMNX8majFlNSkAJoZ
	 /7o1JB5Wa/c1XNxSm3Su/H52IV8LBTJt8RrPfbo2eaX9hSpDHEtiw9+3Hvx2I3YZCe
	 Hb+UfsWn7lr9q5YpLlIHNNpb3JSBqTTOV+sVr+zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/568] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Date: Wed,  3 Dec 2025 16:22:46 +0100
Message-ID: <20251203152446.728709795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4de3c01bdb67..1c4d225e93290 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3075,8 +3075,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0



