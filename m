Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1D1E7C01;
	Mon, 21 Oct 2024 10:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506513; cv=none; b=pqb3tDtfHiCU5RAnk8lPIx5YwrUPAJ+KzdJnhQDLlh4cgDS/Pdg0tRRBFx0h5vPhvFkXxQSjweQ4YTvzFD20W7A0w8V9FGPEPluQkeUzWKUEU6gsB3DgFH2klTiC8lXxRkMpghrfV7nfaUrauUinHvUvSuZ8lNzoMK0H5pzQFvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506513; c=relaxed/simple;
	bh=+Dbywfda9YHir6yBWN5rhcumZI3vz9396P0kvzJ+l3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDW3nTBhX2f+zKbxY9sTA4Fuj2608GyJD3VwXul7hz9JfnIoWi9cCoZeUQMLa/rz/5RfLuZCOErv39pZgUolYj7n4JBYqR/2szvRSVyCyRwnTdydum2/0gVUsFlQx3EhVXy2+1Uq+PK2ANRwJ+jpl5cpxrMAXKr/VohBnq6uDqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWg5R+Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWg5R+Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B765C4CEC3;
	Mon, 21 Oct 2024 10:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506512;
	bh=+Dbywfda9YHir6yBWN5rhcumZI3vz9396P0kvzJ+l3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWg5R+WqV6Csi60wKiUWli2aPKF8O4aAnZr24Zmpq5f8dg4N8sBPm8UfkKU70XRrm
	 K0F/P64aHOwj5AtwV9o8NHx7iDYYzOTmiKH8/B6BLixVCM93ZjV8+sCxKUMwwN68+z
	 47vFTnxC9hOSXgWRn0/46NZhLqAzqNGda6OLvSh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Xu <weixugc@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Jan Alexander Steffens <heftig@archlinux.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 029/135] mm/mglru: only clear kswapd_failures if reclaimable
Date: Mon, 21 Oct 2024 12:23:05 +0200
Message-ID: <20241021102300.476022129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Xu <weixugc@google.com>

commit b130ba4a6259f6b64d8af15e9e7ab1e912bcb7ad upstream.

lru_gen_shrink_node() unconditionally clears kswapd_failures, which can
prevent kswapd from sleeping and cause 100% kswapd cpu usage even when
kswapd repeatedly fails to make progress in reclaim.

Only clear kswap_failures in lru_gen_shrink_node() if reclaim makes some
progress, similar to shrink_node().

I happened to run into this problem in one of my tests recently.  It
requires a combination of several conditions: The allocator needs to
allocate a right amount of pages such that it can wake up kswapd
without itself being OOM killed; there is no memory for kswapd to
reclaim (My test disables swap and cleans page cache first); no other
process frees enough memory at the same time.

Link: https://lkml.kernel.org/r/20241014221211.832591-1-weixugc@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Wei Xu <weixugc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4940,8 +4940,8 @@ static void lru_gen_shrink_node(struct p
 
 	blk_finish_plug(&plug);
 done:
-	/* kswapd should never fail */
-	pgdat->kswapd_failures = 0;
+	if (sc->nr_reclaimed > reclaimed)
+		pgdat->kswapd_failures = 0;
 }
 
 /******************************************************************************


