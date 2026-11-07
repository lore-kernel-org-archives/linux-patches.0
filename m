Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063550;
	b=LwWf25wNDM/Z6QC4bfIR5+VFh180s+/fJV7gY+QkVPDOCY35nlXUHjgsrV6hCedrRKDw
	 h1NXeQCfAnrvfzWRmpmECU837c45aTpjSQwsv8swynPNNcw3UOJtVAhUnQ2N8KDwls9pl
	 cZfGZ36XtPwcD9w8b+ZuwMrlCyPhrvAH0LmTkmDvm+JVNdw3IPS8wfhwmQrwdZHgIambO
	 l3kDV/lPT7iLZQAKiDuNwTwWjGeqJhXC/fTQqqf+WfESC9Q0HLDwAmLIEHFZHzvv+qY1G
	 Gh+sdSuzwXVKLplRDpaK7O8MNNzhpkP4lePy6dd6drcRctIK6JqDMzkuG2bCN60CnMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDDY9k1pmSVkAtZSrhaGqXAeuzvvLp+S1tXKVL8xkWk=;
	b=vGl9pMp2IyNAUzSefjBpP2lDVaeT+/8pGT/5G99NFxTDAwgTrnpuJBegZCTtDALzxp5R
	 B+aR17vRNjKRPcmEvFZpdWR71zNiwOJUh6JPiCU2tDqZ/JRr7p9ezvo0PLmZaKpVwgvUp
	 x8gZbflfih6UEXqsekDl6l7pRr8UsIv0bcA7hRLIv0w1bLkL+nP93uCi7K03D+4ANYx4v
	 1FL/0o/wJzfv8kqf3m9vrpL7j9t2SWSOfMeg0+q5n+cRWXvS7drYk5Q9hNx1L0GOoF90j
	 43Czwl/7/HbhctYGb1VrNXXNs3MJM8jn2CPn/qpWkkM8KEtl5HQH0ylngucGr+vhfPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiAZqLmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A3D608361F;
	Sat,  7 Nov 2026 14:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiAZqLmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B41F008A6;
	Sat,  7 Nov 2026 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063550;
	bh=dDDY9k1pmSVkAtZSrhaGqXAeuzvvLp+S1tXKVL8xkWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiAZqLmV/MLTL8TTsmNFZuf9tjElB6RYFu+bJ8Xpv2iOMndJqXF1lpV21KohRllqY
	 T7bV626QAAbtbRZ5kt2HAgjndJildiaG0mtM10SyG2Zsxr8PlY5fGGf3ps3erGALEM
	 /K7n7E7LwZWytkTJQdfp56d82P4CVkwidMlXGlmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 647/869] f2fs: fix submit accounting for IPU writeback
Date: Sat,  7 Nov 2026 08:55:29 -0500
Message-ID: <20261107134914.916898852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 23f9b76ee0145..46f14f891843c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4087,6 +4087,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	else
 		err = f2fs_submit_page_bio(fio);
 	if (!err) {
+		fio->submitted = 1;
 		f2fs_update_device_state(fio->sbi, fio->ino,
 						fio->new_blkaddr, 1);
 		f2fs_update_iostat(fio->sbi, fio_inode(fio),
-- 
2.53.0



