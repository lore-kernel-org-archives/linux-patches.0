Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036833;
	b=Gn62q3CqY3HXXrtGtqrbGO3fHomT+x5o5GCGQwXiqwCqYaH5Om2R/20hefxpGlmznruc
	 BiA9uuWbeLhMNQHbitcHTUItP/COkvQCWc4rpaRK04sai4+g5jUVLSlO9qkL0P3um+kxZ
	 srijzlzPm82ikpYDINX9SiACaAXANi73ESY8gFyCHEzgxqwBPlEdc41PHAqGHg81ekLwd
	 K8cv+Syn7Ka4wqNNL1VRUZ0awY7Pq0oV9fT+fi5mU1IcKVbbq8STgOPgbOPClzu1JVDm6
	 4bLupkGz+kaYObnSN3WGaNOT/7M+4MGCpqfL4ZDeA1W1ynAdWQKdEWmN+1Kw5+vugrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=izuj/2C3aPWZBoiYHHQa3QCkUMLc1oIOW/mILOhw70Y=;
	b=0Y2i9st93rSUmfCpcKul0NtVRQ+1OqyZdpiZC1fJ44LOwEB8GsIr+Js44JzvRzCssXRV
	 PH9eokNMSZG4w/tk90460CaDRDNcqSVhOaFp6Nu8CyZocFyd/8Q9gyEPc9gXYia08JAfC
	 SHvi1qYWL0qcrLp0q7+Ej5JsU2ROUTA0NZq+3iORTpvZvefm30pfD4c3gUUazU5X5THv1
	 7RzMAJ5UiCnDlzH62aEsDQkIDulJJPKIrpVJaV4fJD6DCoM7DoutEtwif157EJ9BI/cuz
	 0SOk+YYziTjtBRldOonavVrg0dg05LtDMX9EV4d3DeH7zcRqEKyb47YpZAlop8nqwRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bkgKBxih;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FEB606A31C;
	Wed, 18 Nov 2026 21:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bkgKBxih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51141F000C4;
	Wed, 18 Nov 2026 21:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036833;
	bh=izuj/2C3aPWZBoiYHHQa3QCkUMLc1oIOW/mILOhw70Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkgKBxihhRiNwMNB3SgeqkEHXMYwVLCTafJ5fqqZXSVzwK/+RnouXyAtlOrB3D9Q5
	 y0Dqc1b4CgLhwZ0GVOtZfaCTlFNuzkRqe+vOL4f2zqYwE4UXIhgu9OWUryea7G+5V5
	 SOfvyOnWLYBjfCUzFtqqEGZti6/t9zgwJGr9smQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1159/3318] f2fs: fix submit accounting for IPU writeback
Date: Wed, 18 Nov 2026 15:29:41 +0100
Message-ID: <20261118150354.877976456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50a362256fab4..8f505bac8c2df 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3720,6 +3720,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	else
 		err = f2fs_submit_page_bio(fio);
 	if (!err) {
+		fio->submitted = 1;
 		f2fs_update_device_state(fio->sbi, fio->ino,
 						fio->new_blkaddr, 1);
 		f2fs_update_iostat(fio->sbi, fio->page->mapping->host,
-- 
2.53.0



