Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062475;
	b=waQZfzS7NX/P8w1FXQYSzsER1tDz8Mux2Wwenioyv6xfVt/BC1HT88F/ZwATrrF5ldtR
	 8UeWfD9uaocXmWiPbw0nOtimPdRfWO/12uf1MK+SDF5h4q60H/Is/72sjqKkFEckIpere
	 wS5nMBJH72gZkGtb4wwuRo4SKPQwbMGVknEPhIj65WE1eyC+ufF7SARe+atmAdoaOF8Xz
	 kdYewO2MwNUCRsIrs4OMuPihxPIir3Kr5sQruEqB+K8wa+SP2rdfm4QsRPWMkj80CdklI
	 KPWcCiEu/wEZr92q/C+aoefEis8FRAEdzYSpXR38hc0KxS7jyJm+pBZU5Gd9RZbC0qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+CpnRfghLdrP//xZWHNiXI+w5zDnTwpzhkNbyHpeAc=;
	b=dhywmnaLrGXQPRUcIQdrG5EoCxEXuJngnGHEAxp1R6/nW8412y+mIp+EHOuIllo7740J
	 Dzbzy9vmdvV2HwuXtJvdhMh2RA7TU44Btc4Hdll/tuSzI1O272acnlbte7sZrE+8CrDO1
	 1igvlGUzOEvcy2Q37SXc1avvC4SwM4YP0Aoue5W/WRcm9eQ5Nf3VsgizqjHrfhjw4Wu6I
	 lLhEs/Dtk0YT2TuK8inioL6nTt8B6fRGxuFpyddEPCM//Z2MTbK3OoiN5NxYyhL1a3z/8
	 non3f2YV/ozuTYd0dfFdzoTDimIhpCyVssFeEsysXpT8SEWSXadHzmb4NzO2zX2wK7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACr2gmJU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808D4606A33D;
	Sat,  7 Nov 2026 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACr2gmJU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F05C1F0089F;
	Sat,  7 Nov 2026 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062475;
	bh=f+CpnRfghLdrP//xZWHNiXI+w5zDnTwpzhkNbyHpeAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACr2gmJUR9MNqmDXw606N/d2OaEPQ7ELYin/BrjoaIjt05QGraUyD1vPYf5FVGZbw
	 qwU0lfzLCzNbMp7RmJmsR+eCqFQ9Lbx5MNRl4oCyJ2qi4kqeT9VPVsDOiG5Thl8cnT
	 UwltFQSemkOC5OyMF+rr0mvDTGGjnVQQ5gqL2TuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1361/1536] f2fs: fix submit accounting for IPU writeback
Date: Sat,  7 Nov 2026 08:56:17 -0500
Message-ID: <20261107135036.059594839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Seongjae Jeong <jsjlee1020@gmail.com>

[ Upstream commit 6d1f622b9c069378cdb83088be2b15a9b480b8a3 ]

f2fs_write_cache_pages() uses the submitted count, which is set to
fio.submitted in f2fs_write_single_data_page(), to update nwritten
and decrement wbc->nr_to_write.

In the OPU path, f2fs_submit_page_write() sets fio->submitted to 1.
However, in the IPU path, fio->submitted is never set and remains zero.
As a result, successful IPU writes are not accounted for.
This can cause asynchronous writeback to continue beyond its budget.

Set fio->submitted in f2fs_inplace_write_data() after a page is
successfully merged into a bio or submitted, so that successful
IPU writes are included in the writeback accounting.

Cc: stable@kernel.org
Fixes: d68f735b3bc9 ("f2fs: check io submission more precisely")
Signed-off-by: Seongjae Jeong <jsjlee1020@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6abe435b9f0d8..49146476882b1 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3954,6 +3954,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	else
 		err = f2fs_submit_page_bio(fio);
 	if (!err) {
+		fio->submitted = 1;
 		f2fs_update_device_state(fio->sbi, fio->ino,
 						fio->new_blkaddr, 1);
 		f2fs_update_iostat(fio->sbi, fio->page->mapping->host,
-- 
2.53.0



