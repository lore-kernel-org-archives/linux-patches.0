Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585491;
	b=cxCtN2zwl50DtQyZeu2WpktMh02QRgt9DM1OEekjZN+66g98pwQuOPXGw9GtOiaawHL3
	 51eXefuq14hX+49NPUafGIC1IAVzyjc2pPIX1GswSBn4/dpFRiOByJlMzA7o6setmLB+M
	 8fwA376/rFgKC9JQmNQcPd/2EOCLYo2XHlELYSIIaZR4iaJC9ECTaZZiuMv3O5a118GC9
	 sMYYRvCn+bUdpVofdEni4sfsMtrh3nNrZaSfLPuXYBuG7jG9Up0LlyLZq1upsC2vsJpn3
	 IvYg8d97CAzuPTy8tRVZnufuifdNpetUOzquzJiTuaQBB7dT6SXM5vvwgZGT8E3r1nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=II4t0YMNxtJgdnI8Vi0sBlRE23G1puxqQgKP8F6DNmk=;
	b=SwHFCLQWCcYwwvx/mMMY+zZhPMK2iStqXRL5Qqukkdlm337+jgjrqHCvoYkte0TGAKef
	 LRliW3i/OhopjC3EeFLp1oRyTTxUB7YX+BCcIbuYeNmAz6oDoa3cSX4H1G4Ep0RJNsKOB
	 j3FBPMX12staeqg1f4sgIYnSSMlNLn7qTfdeuVeJXF5OmIS8jOj2Dqx5sGZi5vz6rIvW7
	 8LfaI0M0RAokoa8xol3G590+4+8f3XRxj9TVN57TdhSf2IKvXmLex80qA/wNECSuqKEIx
	 fZrEmXI9NBIEtQW/Jd5DJiC5Yq8Ni5N/bphfu9la5JAkNddRpky7kDTESljjcOYe8Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhbpFHBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCCB606AE06;
	Fri, 13 Nov 2026 15:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhbpFHBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0151F000C4;
	Fri, 13 Nov 2026 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585491;
	bh=II4t0YMNxtJgdnI8Vi0sBlRE23G1puxqQgKP8F6DNmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhbpFHBvlPbPqPXO4ebxn8CJoU3yEKqcPhPUX3I6iIkBojERwGsiSx+tnxIeyvmqR
	 H4tUrVSrNjHdLUT9avgfiL39uJcMP0X/QnhfWvkZx8E5RdFuXLVxJDy3ehGb8fKa9P
	 lRi6i3xOJc0Uxo5A7EiJhyexiMQSy1K9qSsjuphA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 139/507] mm/shmem: rescan after nonuniform folio splitting
Date: Fri, 13 Nov 2026 10:47:23 -0500
Message-ID: <20261113153759.160956257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f0d67b3d0a464847337d5063766d55e16041323e ]

The final scan in shmem_undo_range() restarts after a successful split
only if the original folio is no longer large. A nonuniform split can
leave that folio large, so the scan skips the newly created folios.
Hole punching then leaves pages within the hole allocated even though
they could be discarded.

For example, a fault below the hole can allocate a 2 MiB folio after
boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
folio successfully but leaves the original folio at order 4. The scan
continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
The hole reads as zero, but the pages and their block charges remain.

Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-10-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7d9083c482a4e..90fd180c924cc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1272,18 +1272,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-					 * If we split a page, reset the loop so
-					 * that we pick up the new sub pages.
-					 * Otherwise the THP was entirely
-					 * dropped or the target range was
-					 * zeroed, so just continue the loop as
-					 * is.
+					 * The folio was split. Retry the scan
+					 * to find the split folios.
 					 */
-					if (!folio_test_large(folio)) {
-						folio_unlock(folio);
-						index = start;
-						break;
-					}
+					folio_unlock(folio);
+					index = start;
+					break;
 				} else if (folio->mapping) {
 					/*
 					 * Splitting failed, but the part in the
-- 
2.53.0



