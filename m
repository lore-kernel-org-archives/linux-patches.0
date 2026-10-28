Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216182;
	b=Tpjlop1EN8MFqJ3e49TpeZSbWxUbuRW61cXBGVS4a7O4fEGETnpGk9n8cid7G+Kt+X7c
	 HKZfUgYG91Dj/99vXi1avOoX2jaUftTJHedGRQMvXg9p2LRX9rfJAltCMNKdFt0knIdCp
	 X5FksBWblkkzPbYI/Pu6CLD1e3+b7An2OQ7z8Z04PE+2aLjynlTQ3KCWqwzhjRkbRSrr0
	 cqAMtO1GP/LljYg1ND3R0GMbqhfLYIe2dTpds4rMjUVrJO4Vz9e7MI9EDHfw86wW1E5/i
	 +69Nv2J7qbmXA1RPl6sx6dW/r8/iHXnZpgeY2eepnz1AZ45zFHAa0bqHdu0TOZTCgBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p6To0uV/nrNoUN8tGXGhjH+6m94EtxzPn1gnDySWeqw=;
	b=Fw3lZUA5rvbZOLqgvRKX1Yd5pIsM6UjGgCH8jnSR6liwZpRgu3yT50kj3lsqYVfrJsOI
	 ItkK+CfRMLbOc2akIRUwRhxB2OZ/JspaZQ8gvptHiTGyYUbGLJIDxsGfLflLtPIim18jF
	 B37RH6SVBUhwLpeBldvjBXtxRENKYmT710JxU175BVfKDRv/B39io/OVI0vpwzxEHsUoc
	 6rXFwYGdRqbOEwp0CsJsLbTv1PUZxKehtwOtXoCwCHIRIK+IomDof5VHKGmBmy5Td/+KJ
	 PbyoOXXjeJ6PQRrvlltjzmHwa0zoj7LyvXGXEXbsIXLbiGhsIqx/20ev0rQEEyrPy5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmxDcEap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F097C606A321;
	Wed, 28 Oct 2026 19:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmxDcEap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568FA1F01825;
	Wed, 28 Oct 2026 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216181;
	bh=p6To0uV/nrNoUN8tGXGhjH+6m94EtxzPn1gnDySWeqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmxDcEap4zWeoaSf37pcbXtPs4Eo4/aC7V+4JbvpcBTkrO7r9vMOP9bILHB3daOjQ
	 OM/UEj7QkQegwx79tHWyD2/RrUmFx3GkJ7zqEnYohvf2izJd2nvlS2jum2szKt3J4D
	 +17cYo/PXedccNU1CybGZjDpIf5JwI1jPWsR69bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Cromie <jim.cromie@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1470/1887] kmemleak: drop (age <increasing>) from leak record
Date: Wed, 28 Oct 2026 17:59:26 +0100
Message-ID: <20261028170532.907796723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jim Cromie <jim.cromie@gmail.com>

[ Upstream commit 88f9ee2b3040991ff40628fa9e3516ebe36dd6fa ]

Patch series "tweak kmemleak report format".

These 2 patches make minor changes to the report:

1st strips "age <increasing>" from output.  This makes the output
idempotent; unchanging until a new leak is reported.

2nd adds the backtrace.checksum to the "backtrace:" line.  This lets a
user see repeats without actually reading the whole backtrace.  So now
the backtrace line looks like this:

  backtrace (crc 603070071):

I surveyed for un-wanted effects upon users:

Syzkaller parses kmemleak in executor/common_linux.h:
static void check_leaks(char** frames, int nframes)

It just counts occurrences of "unreferenced object", specifically it
does not look for "age", nor would it choke on "crc" being added.

github has 3 repos with "kmemleak" mentioned, all are moribund.
gitlab has 0 hits on "kmemleak".

This patch (of 2):

Displaying age is pretty, but counter-productive; it changes with
current-time, so it surrenders idempotency of the output, which breaks
simple hash-based cataloging of the records by the user.

The trouble: sequential reads, wo new leaks, get new results:

  :#> sum /sys/kernel/debug/kmemleak
  53439    74 /sys/kernel/debug/kmemleak
  :#> sum /sys/kernel/debug/kmemleak
  59066    74 /sys/kernel/debug/kmemleak

and age is why (nothing else changes):

  :#> grep -v age /sys/kernel/debug/kmemleak | sum
  58894    67
  :#> grep -v age /sys/kernel/debug/kmemleak | sum
  58894    67

Since jiffies is already printed in the "comm" line, age adds nothing.

Notably, syzkaller reads kmemleak only for "unreferenced object", and
won't care about this reform of age-ism.  A few moribund github repos
mention it, but don't compile.

Link: https://lkml.kernel.org/r/20231116224318.124209-1-jim.cromie@gmail.com
Link: https://lkml.kernel.org/r/20231116224318.124209-2-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 5d10d4e19e6d ("mm/kmemleak: avoid soft lockup when scanning task stacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index ca1a3855de07c..448c2267551fa 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -355,14 +355,12 @@ static void print_unreferenced(struct seq_file *seq,
 	int i;
 	unsigned long *entries;
 	unsigned int nr_entries;
-	unsigned int msecs_age = jiffies_to_msecs(jiffies - object->jiffies);
 
 	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
 	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
 			  object->pointer, object->size);
-	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
-			   object->comm, object->pid, object->jiffies,
-			   msecs_age / 1000, msecs_age % 1000);
+	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
+			   object->comm, object->pid, object->jiffies);
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
-- 
2.53.0



