Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028045;
	b=tyx+zoA7/euVZzJhyVnCunsSOE4uM4E8Ql62lMwLYRc6vPFG9G0fLkEwRrMOkMRBx/sp
	 SWTGgxWyLF+NoCxpfqAPh4vlTBBiH2tV3roYv7XCv6wGayjoABZ/Rwbw3PghD5T2qEcxy
	 0qobJmChr5K7VEh1YccrmnxT/zVzRmcuFMgeCyG6vIzJZgw+4j3yCXJB+SHn5XJJhY6a0
	 EXH2PanQIfLUeQQHFq4MbF+G4sU+4swSx7MLlpYSHIUklRv2q0wKbik4cK9BXhpXnWy6A
	 tc82HJtx2yBsTK5cuROATZAyxZRbDIAi0Z1lwPOH97UKqgOIV4JASmZSxDlFnMkXr8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zljXTwWhfEs/J5CP452FG7Ebr2TFPdy4XagoDpAZVEo=;
	b=KkHOF2OfgayTO7SJ7RRcSBArPjC+N7Pl8iYFXhU+JbQG849w4x64yIEJlssHBo5bjFiv
	 9SNjV/dcUq+tVgJR+LVlgYKH6tm/lwS24XnH0lb02ROopQ6Fd1djFAh3Y4QCcOaNq0hvf
	 KFpb2JKK+LMSwPN2atsPtlSXuXWdzg2zJMVfsBj4NRXJQfX2uK9hXymReFzSy98SX1EVR
	 4NMu0BbPedW/OPZR9kb4NELS5j/Gx0E1fu2+MeMmAxmDgKThlADQHNU9EVmREpT16E/3M
	 NcQyOJ+dbxqi0mmxYYZhu2lWVmfgT5AgQ7AlTxUteYzhwi661Ng8rsyh4f4kdEd/cag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCa7okY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40244606A31C;
	Wed, 18 Nov 2026 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCa7okY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948E91F000C4;
	Wed, 18 Nov 2026 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028045;
	bh=zljXTwWhfEs/J5CP452FG7Ebr2TFPdy4XagoDpAZVEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCa7okY0hBJmymmh7hrdpI68ZkOZnHB7BeKbnDBBpm+AJPAGxVjHvqfosuMy9Vrzd
	 DkdP8E0YSRX9ehxTHAKI5g60LvJf9YCu3Al8GDV6tDNXvMcx45jenjG+5lt+MFnvYV
	 nMkj44+ctPScAKv7IwPvmSN8vV2thiqQRrwd49rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1954/2151] ceph: wait for pending fscache write in write_folio_nounlock()
Date: Wed, 18 Nov 2026 16:01:29 +0100
Message-ID: <20261118150232.944906036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 3f7655f0d9186656c6f1cbc012a39c866d4aaabf ]

write_folio_nounlock() marks the folio with PG_private_2 via
ceph_set_page_fscache() and starts an async write to the cache via
ceph_fscache_write_to_cache(). PG_private_2 is only cleared once that
write completes.

If the OSD write fails, the error paths return without waiting for the
cache write. On retry, ceph_find_incompatible() would wait for
writeback, but not for PG_private_2, before calling
write_folio_nounlock() again, which would trip the VM_BUG_ON_FOLIO() in
folio_start_private_2().

Wait for any pending cache write before starting writeback on the
folio. Do so before bumping the writeback congestion count and
allocating the possibly mempool-backed OSD request, so that a thread
sleeping on the cache I/O does not hold either while it waits.
Add ceph_folio_wait_fscache(), a wrapper for folio_wait_private_2(), and
use it.

Fixes: 1702e7973410 ("ceph: add fscache writeback support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284%40columbia.edu?part=7
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 0046f9261cf01..c10a7a32e5c5e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -567,6 +567,11 @@ static void ceph_set_page_fscache(struct page *page)
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
 }
 
+static void ceph_folio_wait_fscache(struct folio *folio)
+{
+	folio_wait_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_fscache_write_terminated(void *priv, ssize_t error)
 {
 	struct inode *inode = priv;
@@ -588,6 +593,10 @@ static inline void ceph_set_page_fscache(struct page *page)
 {
 }
 
+static inline void ceph_folio_wait_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
 {
 }
@@ -791,6 +800,9 @@ static int write_folio_nounlock(struct folio *folio,
 	      ceph_vinop(inode), folio, folio->index, page_off, wlen, snapc,
 	      snapc->seq);
 
+	/* wait for a cache write left pending by a previously failed attempt */
+	ceph_folio_wait_fscache(folio);
+
 	if (atomic_long_inc_return(&fsc->writeback_count) >
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		fsc->write_congested = true;
-- 
2.53.0



