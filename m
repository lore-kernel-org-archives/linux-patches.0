Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982CDC148;
	Tue, 29 Apr 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948746; cv=none; b=iMhMufEQZGgij7AZIZCDPmHZgoXikhfxsawB0R0ijXDdqk4aT+Id5g/cU3KmK0/nqhDKUj7Bcut2S+9p8RkPvL2Ojp7tB2D3YAxpcjVDSlWnFKE6FZBer8IKE0D+2KrkS2QS1HDLmbahFJnsgZ+9TKgL7tHShomaNlYpNNFCYaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948746; c=relaxed/simple;
	bh=hB1akbcDku3jpLr8DH+hAnSrD/2nyL5wuSU9rI8ekFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajN1QZtGbspWQZo0aXjVbAPHpHXhGfPd69Zh5CDLbVLYDINnH4AKmmwDSJgP9Dpy3k+MUa5e3kXAn27SdQnpS709Evff9xUOPs31GZQUzbuZ31hCHzQ5exqQo5CHAMUtMnASiK/jMLwooaQh3iNZ5z+K99YDVAtiPlAmMbZdd/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8dSRTg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8dSRTg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C21C4CEE3;
	Tue, 29 Apr 2025 17:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948746;
	bh=hB1akbcDku3jpLr8DH+hAnSrD/2nyL5wuSU9rI8ekFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8dSRTg1DLE12bWfUUPgmPtIA7z1tRmwDygcu7zkKEZmwdmDP2sKS29+9MhQiJ05q
	 ERA2HyekkfHn6k7wfeuRBAuGPtOi3Hn4+T319Ma9G/9Tag6PLyEKflMRTk2+l9XoxF
	 34m1+CFQA9utLJZGlP6+ZX9vJ/jwvYL6Jg0S9/ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Jade Alglave <j.alglave@ucl.ac.uk>,
	Luc Maranget <luc.maranget@inria.fr>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 100/373] mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock
Date: Tue, 29 Apr 2025 18:39:37 +0200
Message-ID: <20250429161127.270171497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit c0ebbb3841e07c4493e6fe351698806b09a87a37 upstream.

The PGDAT_RECLAIM_LOCKED bit is used to provide mutual exclusion of node
reclaim for struct pglist_data using a single bit.

It is "locked" with a test_and_set_bit (similarly to a try lock) which
provides full ordering with respect to loads and stores done within
__node_reclaim().

It is "unlocked" with clear_bit(), which does not provide any ordering
with respect to loads and stores done before clearing the bit.

The lack of clear_bit() memory ordering with respect to stores within
__node_reclaim() can cause a subsequent CPU to fail to observe stores from
a prior node reclaim.  This is not an issue in practice on TSO (e.g.
x86), but it is an issue on weakly-ordered architectures (e.g.  arm64).

Fix this by using clear_bit_unlock rather than clear_bit to clear
PGDAT_RECLAIM_LOCKED with a release memory ordering semantic.

This provides stronger memory ordering (release rather than relaxed).

Link: https://lkml.kernel.org/r/20250312141014.129725-1-mathieu.desnoyers@efficios.com
Fixes: d773ed6b856a ("mm: test and set zone reclaim lock before starting reclaim")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jade Alglave <j.alglave@ucl.ac.uk>
Cc: Luc Maranget <luc.maranget@inria.fr>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4581,7 +4581,7 @@ int node_reclaim(struct pglist_data *pgd
 		return NODE_RECLAIM_NOSCAN;
 
 	ret = __node_reclaim(pgdat, gfp_mask, order);
-	clear_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
+	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (!ret)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);


