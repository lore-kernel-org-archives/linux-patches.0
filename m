Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625497;
	b=ELgSidh2i+5dYmZHPo6ih2iAHOPvjqpRAM910XymIDEFvl+XHfxBGe4EoylCUGkEbC3p
	 wQAIP7iuCuEF9mDq9R/zyL+IJrEMsD3/3pVIbXN4dnDXsF7xq7QTSZLvm+pwA+kszPSYs
	 Ka09q9e2Nwl/6q1EFwzazWOpsGIr45wO5VTzb8eC+RLo+iKabc6ASQMqyKV+u1+OT68H3
	 zwSX8DpakunexC52xxyfoEEBxC04kchrkrcR6n/7cEVog//Ht+aT/mwo1ruReKeHkPEWz
	 iqSRCnFMe1czYo8OueQzzp1BBwFOh4v9TstjvBJ1Vz6FPypLt+zC3km8lQlHKsQKnuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MNWVb8NNR6KyNo7qRuUYGnpVOA1XNgp4JZn2YChKZnY=;
	b=WphUepCTRV7c/p+g5SfOY34r0nS7Hqcsmqthq7AoulaEr3PzGcKZtuEyc3lFsWObMkxk
	 ea2D6L9FuT9ECUM8IjcBuAlrpCm87SoM1Qwrk8KDNIuo7YXvR3p/I8++f5AUibWCc6pD2
	 e8YWL34hA0NPqMaXmPW6SEBSLYLzbWMoeyfh+rVIp51DmnSUAdR0f3VU/X5Z7D64yP1wZ
	 HWhxTQ7vHhjYqk7KbIpsJh1waOZp4KzMBbDpYrnGYaxaNwZTCC0LlIT1aZy25n1a5VL0x
	 Bs8KvWT1pZgmo1LgU9rOnZFQ+8yUewn458bpYj9/hkaYuT1AANZkilZ5+kSJKwOLbRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJuwjhJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD24C606A321;
	Wed, 25 Nov 2026 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJuwjhJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5781F00A3C;
	Wed, 25 Nov 2026 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625497;
	bh=MNWVb8NNR6KyNo7qRuUYGnpVOA1XNgp4JZn2YChKZnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJuwjhJnjZwcZ90HPywMVNz02jZE/MuP3DZk5HaE8JVdZb5Tqf00OMS5g9wQxRMv+
	 ZsuxlvHSpk6Lk5tX1igQVdOlNlqzAuIVNb8fVPINIR0PVF6rTfFaj/r1qSInsnXL7P
	 x54+oQMDfgzwY39m4pycTW4BXq8QSNJ9mOVPYdeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 536/816] ceph: wait for pending fscache write in write_folio_nounlock()
Date: Wed, 25 Nov 2026 15:34:44 +0100
Message-ID: <20261125143901.595978097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted the context line so the new helper is inserted above ceph_fscache_write_terminated(), which already takes the extra was_async parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7ad96fcdcd20c..01c9800bd8d07 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -560,6 +560,11 @@ static void ceph_set_page_fscache(struct page *page)
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
 }
 
+static void ceph_folio_wait_fscache(struct folio *folio)
+{
+	folio_wait_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_fscache_write_terminated(void *priv, ssize_t error, bool was_async)
 {
 	struct inode *inode = priv;
@@ -581,6 +586,10 @@ static inline void ceph_set_page_fscache(struct page *page)
 {
 }
 
+static inline void ceph_folio_wait_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
 {
 }
@@ -784,6 +793,9 @@ static int write_folio_nounlock(struct folio *folio,
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



