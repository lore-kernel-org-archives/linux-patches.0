Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027925;
	b=TDu8OzOrSQCfciQSoN7Mcpih6dc6UZjfVYBLxvHjFGVAxLGcb7t8qmciHF1ekwta2O70
	 /HX8FAMFXbHjZfhQbepjU6aW+4JPB4Hx23mkfS/4lWWFvkbarpPC8oWP+7993InwZEtsu
	 3K+ax+euQoGqiN5BI7U5arDTRS5KvRNQydDSPIwMrSaZyXQ/b3GDwYWmT5qtQb+11to9/
	 lotT2P1jkaUA3ONAu5HvRo1aiQdvrXVXpLSVfeBs3XyDeSeis1VSGqghmvAea3bZO9Tyh
	 CGlWDvbXcBey/1f6FHodOqU/Icf0Zyzie/A00q1XGTMMR+kLK2fabWQGETZ+pJenkTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YuTKXkktnIfmYDbwazWYJS8dkwSZR59etjJ2BQVHDUM=;
	b=HV7vHfjnwFRGUK5afF1rOCWjyll2ECNo9fXnjr7VLfqDHFKSpchThz7bqwC6b28b7zsl
	 ryqXBy9ClhEjYHod+a4GU4U7jV8X5Vcdhnkc1eU7gxKB0lg2Ned34Ub16gT7EOe4qn2/3
	 5zv/wYdZnOVhEwvyOcpnHfVrmDIkJ2xcn2CiQ6llMsdH/pu8EuQaaTSJlxhDGX36VX32b
	 001l3dEjCL2EJvHsmTbZN6+lJIHn52VYqm9hITMLdBU5o8W+r0sfmcQtNKAc0Og9BMR1Y
	 cCFdAZ8jGNgpM1g1kXV5fE+w31W4RUsHUFIF8hVWr8Q/5ihjtJRdqV9XNCOu+dw1D3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYPVJVDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858BD606A320;
	Wed, 18 Nov 2026 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYPVJVDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D718B1F000C4;
	Wed, 18 Nov 2026 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027925;
	bh=YuTKXkktnIfmYDbwazWYJS8dkwSZR59etjJ2BQVHDUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYPVJVDx/zwmbEJyThDu2NpQPG6qgnjbzaFq1vUtfgmp8OiVX1j44An8liu6yHlSn
	 TmRqu8aQWVBzoO2wbToz/MVMmHYjp/N3EbYPWmAIXFlcW5wMj8FR6w3UblP50PsvMc
	 VmONpJDEBvb1A42Dr77IzOgAzRYLyRFdVT2ftnIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1955/2151] ceph: fix writeback_count leak when a bounce page allocation fails
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150232.979086547@linuxfoundation.org>
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

[ Upstream commit 7807710d88ad03e7ca9b5f79f518f040db2a4e09 ]

ceph_process_folio_batch() calls is_write_congestion_happened(), which
increments fsc->writeback_count, before calling
move_dirty_folio_in_page_array(). If the fscrypt bounce page allocation
there fails, the folio is redirtied and never makes it into the page
array, but the count is never dropped.

write_congested is only cleared when a decrement falls below
CONGESTION_OFF_THRESH, so the leaked counts set congestion early and
eventually leave write_congested set for good. Every WB_SYNC_NONE
writeback then returns 0 and background writeback stops entirely.

Bump the count only once the folio is in the page array.

Fixes: d55207717ded ("ceph: add encryption support to writepage and writepages")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260902-remove-wait-on-page-writeback-v5-0-0b512e77e75b%40columbia.edu?part=1
Assisted-by: Claude:fable-5.1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c10a7a32e5c5e..9e123f8e72720 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1408,8 +1408,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		doutc(cl, "%llx.%llx will write folio %p idx %lu\n",
 		      ceph_vinop(inode), folio, folio->index);
 
-		fsc->write_congested = is_write_congestion_happened(fsc);
-
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
@@ -1423,6 +1421,8 @@ int ceph_process_folio_batch(struct address_space *mapping,
 			break;
 		}
 
+		fsc->write_congested = is_write_congestion_happened(fsc);
+
 		ceph_wbc->fbatch.folios[i] = NULL;
 		ceph_wbc->len += folio_size(folio);
 	}
-- 
2.53.0



