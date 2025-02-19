Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0D71C5D69;
	Wed, 19 Feb 2025 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956723; cv=none; b=OOjA3J2hk7a6QcKqV3Lccset5zuWL9oREyKQi44QGiJxqTzrKoW0UVLsHEDZ6YAy9Y65LvOV+cEa57RRXMxaiUsRhaUsXRJvpB6Q50KUByTJ0AZAEkCwMPjmL8o4B+R6WcsdoDDIv+kyoeBeaCgJQRdQ2HcIykFlHZXHKhjvulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956723; c=relaxed/simple;
	bh=8VEyxmeVTq4nOBJ9QvlV5CJQjvAU3xpzYeCZ9+yBKWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYFODOrzzzFWbVnVGGLfYrAQUMv/6DZo9B38q0WABs0YD3AsmyYeYzYEgErMoARHqIvgUQZLXM466XmciUihpFS4s0sU5QfE+St5PfWDSTiWhQgvlX+c15Wdv0UzowUOUb+d8NY67ZsAI+ogy1MuK//RJIcrzcF+922Ws/zAgSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRtliejj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRtliejj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846DBC4CED1;
	Wed, 19 Feb 2025 09:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956722;
	bh=8VEyxmeVTq4nOBJ9QvlV5CJQjvAU3xpzYeCZ9+yBKWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRtliejjuA8eaUMTnLDXAGgIBHXZnxy9xyhE6ueo2ZDTNoqLaMfsbpqEy6DG/ZjoK
	 OonjUJdPbpCIrI64RC3jMtFpUrcaevfBs6m+jRflc7pKNNN0xpHUGYELvXEMGkySD7
	 lReMEsnMdYUGUv1sfWN8i1qtUzo8SJ4EVBQZXflw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. R. Okajima" <hooanon05g@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/578] lockdep: Fix upper limit for LOCKDEP_*_BITS configs
Date: Wed, 19 Feb 2025 09:24:40 +0100
Message-ID: <20250219082703.877329589@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit e638072e61726cae363d48812815197a2a0e097f ]

Lockdep has a set of configs used to determine the size of the static
arrays that it uses. However, the upper limit that was initially setup
for these configs is too high (30 bit shift). This equates to several
GiB of static memory for individual symbols. Using such high values
leads to linker errors:

  $ make defconfig
  $ ./scripts/config -e PROVE_LOCKING --set-val LOCKDEP_BITS 30
  $ make olddefconfig all
  [...]
  ld: kernel image bigger than KERNEL_IMAGE_SIZE
  ld: section .bss VMA wraps around address space

Adjust the upper limits to the maximum values that avoid these issues.
The need for anything more, likely points to a problem elsewhere. Note
that LOCKDEP_CHAINS_BITS was intentionally left out as its upper limit
had a different symptom and has already been fixed [1].

Reported-by: J. R. Okajima <hooanon05g@gmail.com>
Closes: https://lore.kernel.org/all/30795.1620913191@jrobl/ [1]
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20241024183631.643450-2-cmllamas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b2dff19358938..e5fbae585e522 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1409,7 +1409,7 @@ config LOCKDEP_SMALL
 config LOCKDEP_BITS
 	int "Bitsize for MAX_LOCKDEP_ENTRIES"
 	depends on LOCKDEP && !LOCKDEP_SMALL
-	range 10 30
+	range 10 24
 	default 15
 	help
 	  Try increasing this value if you hit "BUG: MAX_LOCKDEP_ENTRIES too low!" message.
@@ -1425,7 +1425,7 @@ config LOCKDEP_CHAINS_BITS
 config LOCKDEP_STACK_TRACE_BITS
 	int "Bitsize for MAX_STACK_TRACE_ENTRIES"
 	depends on LOCKDEP && !LOCKDEP_SMALL
-	range 10 30
+	range 10 26
 	default 19
 	help
 	  Try increasing this value if you hit "BUG: MAX_STACK_TRACE_ENTRIES too low!" message.
@@ -1433,7 +1433,7 @@ config LOCKDEP_STACK_TRACE_BITS
 config LOCKDEP_STACK_TRACE_HASH_BITS
 	int "Bitsize for STACK_TRACE_HASH_SIZE"
 	depends on LOCKDEP && !LOCKDEP_SMALL
-	range 10 30
+	range 10 26
 	default 14
 	help
 	  Try increasing this value if you need large MAX_STACK_TRACE_ENTRIES.
@@ -1441,7 +1441,7 @@ config LOCKDEP_STACK_TRACE_HASH_BITS
 config LOCKDEP_CIRCULAR_QUEUE_BITS
 	int "Bitsize for elements in circular_queue struct"
 	depends on LOCKDEP
-	range 10 30
+	range 10 26
 	default 12
 	help
 	  Try increasing this value if you hit "lockdep bfs error:-1" warning due to __cq_enqueue() failure.
-- 
2.39.5



