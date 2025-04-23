Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD2F27FD42;
	Wed, 23 Apr 2025 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421706; cv=none; b=q+7zjYIfQCgJE95pbeZM6s0phRl71Y+lV11MOU3OGdN5fvgOal9bPKwglgtMOGwNrxBOYa95c4dpsNKlBIS7EIw57DjKEoxCd/UW4ZlnWXQpNe9ixCczaQDsUFrDm5+CF3z5v20DsE4a2C3GhKeZvf+YwYBjqq1ZsEuN/VD7JiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421706; c=relaxed/simple;
	bh=v5IvUSzEGUQ/wZAj6+QxV3fRzzjyRTSU1yyjUs2nFEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViCwj7d/rG/AwgGolqBim15U4TSkApI0muexnsfoZeC8X2k6wALcDm9ZC0AAjeQrUSvm9GzC1il2XFNEVZwHY9E/YrH/G0g3SRVe3gOKg4HzNRmEPRB/YCOUICArjYf+NfDAQwosQC5OapxeP6PQK+7tXrnvN0HdFRv/rTN+3vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwi7xanq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwi7xanq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EA1C4CEE2;
	Wed, 23 Apr 2025 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421705;
	bh=v5IvUSzEGUQ/wZAj6+QxV3fRzzjyRTSU1yyjUs2nFEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwi7xanqaxx1l9DEPX5XrTtRrZcuCV8Gl09je+mcUmvnbZj3k6UCCHlyQkE6/mwZF
	 rE1pqiQkWPQ0RMPhU+Yudqa6GE0abnO3OdS1zSKtyHXK18REBs4NCDOJqoN3Oh4PWj
	 PTZBB29D4bPgLDxBLGyQ8Zx2twp8RIEiZD7za7ek=
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
Subject: [PATCH 6.6 193/393] mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock
Date: Wed, 23 Apr 2025 16:41:29 +0200
Message-ID: <20250423142651.362162877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8115,7 +8115,7 @@ int node_reclaim(struct pglist_data *pgd
 		return NODE_RECLAIM_NOSCAN;
 
 	ret = __node_reclaim(pgdat, gfp_mask, order);
-	clear_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
+	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (!ret)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);


