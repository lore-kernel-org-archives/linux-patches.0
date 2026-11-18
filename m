Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039726;
	b=wbvAEXP5NTW1SyUqYAvK0eb3BjDgRgdj+iYKricJ+ZsHtj7eJJhwkEn0U4xtMAGZaGFg
	 5FHeIJWzYWPpfJrvKuI1b2dfz3VcK3Zx8NOEC4CcpFmeBVmqLVX89pAjVGTyhzVE+1GA1
	 tUTECjPfg91KhV5kb54iW/Ntrm1zZvKVIS/qtfdVIkR/+AwqNgENAekmIB+UfvuCmzgkU
	 H5dXHRhg4lXv9TPTPzzFl4VLz7BnaCr7fOulpaAR3sF1/E/WcnzlWTUVy1CHMl9uOiAEw
	 /XPFEhue/825DMBbWQOAfecocW1SBfuanzI06cxZCrX/1ehzHcR4R4kZr+fjA2vKYxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=83wQPsAsOj72UbKgDApZk58PH+MbjmO5wylzIQQNZbA=;
	b=Lq1McydhpT/rroWAUdx3nmA4/JrX0GUhUHSJdw4Ou54q3g66OOrtOzH2sTNZP85luMD+
	 xqvr2CtL5xCLY1s6MR1iyBNA+OPCaNFRiBPEBmQcMvxlgJk1UzaEvV2sXK9q3SyQU11/2
	 zc4kky77bSpc6Spp54teOX/qgEfv5B0wirfn7y3CBexf5S1lKPdSQXpjjx6GeKvJ6iXam
	 SfQv+Vph0ap8+EotrYYbO3H4xlc//fQcR4HuXjRYkuZ+9qulXVPoP+sn/p3PZWvgUF1xu
	 aluig7MAvtsBjourrhpoPejaB2Odw7qnbvehITjc5e6DPl3NwitKwlvsyusbwb4DywQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0AGCPt7k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9507D606A320;
	Wed, 18 Nov 2026 22:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0AGCPt7k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4CB1F000C4;
	Wed, 18 Nov 2026 22:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039726;
	bh=83wQPsAsOj72UbKgDApZk58PH+MbjmO5wylzIQQNZbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AGCPt7kjQHA1KD3fgpu12UX9j/HzY7PAO4XhHu4J4jE7uWW9z/fbt///QiaPWuPT
	 PXZd5PCyU/6U/PSp5IPcx5UBfd5JBjPPu77tiLuoB9s+bqGPZmE3lEKRfWlgGOUy/K
	 lzPd/1KmJ9KeGcZEbmRHBphlN8WkO3SBxijFu7SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2203/3318] fs/ntfs3: take run_lock when freeing offs_folio in ni_decompress_file
Date: Wed, 18 Nov 2026 15:47:05 +0100
Message-ID: <20261118150428.018380042@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit ad39d8d90fa0fd99b2714d4c84c6f4e1c399f1f4 ]

attr_wof_frame_info() allocates, caches and dereferences
ni->file.offs_folio under down_write(&ni->file.run_lock).
ni_decompress_file() frees the same folio with folio_put() without
taking run_lock. When a WOF externally-compressed file is opened for
write, ni_decompress_file() can drop the last reference while a
concurrent O_RDONLY reader is dereferencing the folio in
attr_wof_frame_info(), leading to a use-after-free:

 BUG: KASAN: use-after-free in attr_wof_frame_info (fs/ntfs3/attrib.c:1619)
 Read of size 4 at addr ffff8880120c9000 by task exploit
 Call Trace:
  attr_wof_frame_info (fs/ntfs3/attrib.c:1619)
  ni_read_frame (fs/ntfs3/frecord.c:2421)
  ni_read_folio_cmpr (fs/ntfs3/frecord.c:1916)
  ntfs_read_folio (fs/ntfs3/inode.c:648)
  read_pages (mm/readahead.c:181)
  page_cache_ra_unbounded (mm/readahead.c:292)
  force_page_cache_ra (mm/readahead.c:364)
  page_cache_sync_ra (mm/readahead.c:573)
  filemap_get_pages (mm/filemap.c:2688)
  filemap_read (mm/filemap.c:2806)
  generic_file_read_iter (mm/filemap.c:2994)
  ntfs_file_read_iter (fs/ntfs3/file.c:842)
  vfs_read (fs/read_write.c:574)
  __x64_sys_pread64 (fs/read_write.c:773)

Take run_lock around the folio_put(), as is done for every other
access to ni->file.offs_folio.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 33520848db87c..8e743343c2c94 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2395,10 +2395,13 @@ int ni_decompress_file(struct ntfs_inode *ni)
 
 	/* Clear cached flag. */
 	ni->ni_flags &= ~NI_FLAG_COMPRESSED_MASK;
+	/* offs_folio is accessed under run_lock in attr_wof_frame_info(). */
+	down_write(&ni->file.run_lock);
 	if (ni->file.offs_folio) {
 		folio_put(ni->file.offs_folio);
 		ni->file.offs_folio = NULL;
 	}
+	up_write(&ni->file.run_lock);
 	mapping->a_ops = &ntfs_aops;
 
 out:
-- 
2.53.0



