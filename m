Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704496;
	b=m6q1n1jiDV2DmNX+QRASoeJaA24OEOuQFXUAkHDilALfDUcPGhBFFChD9FwGHEnpLdVe
	 2+61Z2ng7UpA//l+po6Bk8C/TNPMxd/w370L0yK8nzYGrA7fcWNsVEH5sG+m5LailFeAg
	 eY+Im4cNp3oEoHycgaKrtbvVpe9H5WJqZZrH7d+x0eorHuTZ6TgFHq7yRSCEq/v8hhJOs
	 3BN1JrEzVU/l3wFODlV2ZfIij3XJ0vCcGjAT9L0w9J+ZJtlOp5cKzod/a+7YTgASvJ919
	 GsqOYClH09Cu+XQ1rm4ny24YiOImi2HRJAqT81n24eNqvLrKxWmFE50Zue78RFhYIWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KCdkhweQg1yn8VPq+iyRkkY3iPMRzveAYPCNpLjU4lQ=;
	b=3j9CI2s3m8Zcf6usoafjopYSZA4F+prb+3/DnhVN0n+LT1TGQUSSkjyQZdGpPYA6GabP
	 OVv2U5nZHQzg2tAsMGmckhw6FQkQMRB/m/y18pAV2CiXQgnTWz+j4qAE3dTVOZtyk7Yjw
	 XY7QpCoPbRj7JajjyZzGUSr9ylsJpo5jeivwMQgfS7fSURmSNsqPfJv8+PyUnTpPPHqsb
	 5Xser1mru31q0sZ3aJYt5bSdRJ9helbiDxVmalC2KumLyDaAG6GdaBNriaydCa9JNuqQO
	 yyIRAjO9uCie44ynZEV8U6g8jjWZW0oPodUqu4jNVGeueBXGw/PPpjVUjhkMztljaJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8USxSLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E17606A332;
	Thu, 26 Nov 2026 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8USxSLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9025E1F000C0;
	Thu, 26 Nov 2026 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704496;
	bh=KCdkhweQg1yn8VPq+iyRkkY3iPMRzveAYPCNpLjU4lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8USxSLzNJNbcHbKCdH7G+aEWa9Pxq7c4qfS5ADhMhLOyhmPPGAx6LOa6b+L4hmiF
	 okRfd4gvAShzTTzmAhvIE6j3nVCM4K/4PcbOYJGXmjTca8MaPokoQsIDy8LGz7QlZI
	 TnhCZF4S6jpoQORS9ZsVspyqgG7MZcNK8BMfSbTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/265] locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering
Date: Thu, 26 Nov 2026 15:37:10 +0100
Message-ID: <20261126143611.991099588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1b9e01fcc47aff00d2fd64693c5dcd620eff5865 ]

The atomic_cmpxchg() in osq_wait_next() removes the current CPU's node
from the tail of the queue and puts @old_cpu back.

This is very much like an 'unlock', which is RELEASE, rather than
ACQUIRE.

Additionally, on success (the only case where the ordering is
effective), this returns NULL which means both callsites will do nothing
more, there are no subsequent operations to order against.

Furthermore, the osq_lock() caller will then return false, indicating
failure to acquire -- the mutex must go block. Again, not making a case
for ACQUIRE.  Neither atomics nor locks provide ordering on failure.

Since ACQUIRE makes no sense, while RELEASE makes it more symmetric with
osq_unlock(), switch the ordering. This then makes osq_unlock()
consistently RELEASE.

Fixes: c55a6ffa6285 ("locking/osq: Relax atomic semantics")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index 6772f35c078c5..aded61b363d0f 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -53,7 +53,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 
 	for (;;) {
 		if (atomic_read(&lock->tail) == curr &&
-		    atomic_cmpxchg_acquire(&lock->tail, curr, old_cpu) == curr) {
+		    atomic_cmpxchg_release(&lock->tail, curr, old_cpu) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
-- 
2.53.0



