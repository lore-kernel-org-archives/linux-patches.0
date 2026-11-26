Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705213;
	b=PWS06uFe35lkKwIFFEhIEmt3g19q6H6vJjFKyR6mXXTGLC9YQM4F+qiFYj3Mmfy/CckV
	 VA/Ab3drna959znT28PrkPtqPxomJWKjgD5HEBavTyXN89BO710WIiz3xUQB90Je4sTzQ
	 l/DscHWAFRsPOkN+WY5zAcXHnWrsh2jzgQOpRLloo8iLDBTecM1I/i4xxBGaM1s8IBND1
	 Dt7g0IA7PFO0buQjrpyuME7mUNntA2nW0T4Mj6KfBQr3QSGEE8v1dfFIODU3j3TbMX3E6
	 NoNhihMQeDn1JgMoWALGYhBD0HOBxQaoVi/d0l9jmkNrcAF7hklVfdRifqiC2zfxzDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gjU68egAeTHKVwxVwSdWf0iLse4r+UV3vsCQg/Y9xGI=;
	b=lZ61KsIUXnAcoq8x8954dlE1Lx3ssxpn0xZFWK8ycXE2qeN2ZGzsfDXgVQT/s0EJiXj1
	 RDzScbGo+e0YUQKpKM6IIMuegoW9Lx0iz31kNsjVabV25ZmI5iURKNSOHFMDIuHlEQ2Ss
	 gQ83niN37F+GKTQCfL/6owU4WenhhzeEMYFKmeK4DqYDI/WzPnDLpViGAn6YHFZJJq0JT
	 De0Zr3zjgA3+nHaSMvJaqJZrGeEMo1b3ilhcUCRWnB3OynsLaxBI5AgjLG8hNvj+O1Mih
	 zht9NmQjYtrziBNlRXHZQnJcpkT6dhZn0QhZ1Bo1fpKNmCgNwUNqL/cyJ3qWgxQFO/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gw4qkeyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34627606A327;
	Thu, 26 Nov 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gw4qkeyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773BE1F000C6;
	Thu, 26 Nov 2026 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705212;
	bh=gjU68egAeTHKVwxVwSdWf0iLse4r+UV3vsCQg/Y9xGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gw4qkeyYo0v1P46PGvz6AzRM5yTn5psj8sW5xQO/aSTaUZN40JVfYhjRuEEXzdaNA
	 QZP561Lc7PNxM05VXlMux54o9VY0fsv8svTlxl7m8cGB6RtqMm+e1nWe0KOUzxj3Bp
	 xhjRjofYEkiGR68kdSKJ87Gr7nrUmYBo/+O8j1bA=
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
Subject: [PATCH 5.15 120/319] locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering
Date: Thu, 26 Nov 2026 15:38:08 +0100
Message-ID: <20261126144009.455111686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ebb1493915ce9..b3748ed287ebb 100644
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



