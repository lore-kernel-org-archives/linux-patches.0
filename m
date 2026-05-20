Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8093E29B8D0;
	Wed, 20 May 2026 17:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299816; cv=none; b=IlEX941QigDk1nAy4qxo5eX/1IJHM3+DAToeTr8kDUUSlEdz/ai3ek+RqtXgO2HXFQrdgGKc4bCcBoFa8WBMZ7Zoamz0h0S34c3XF1EfeuffY7AnuAA54etLMnLxTuff0NU2Zvu3aggHLJWWrmJVZo+O9MvpQkzKl8q/g6PK+xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299816; c=relaxed/simple;
	bh=Nn6/O0vlAbieHmxvq3lQFfMP9BYzPw5TQkL3gtob7qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQdXnoc1ImngW0qSzQWCHD8cPsYDTNaCEDqUbH7DWbD6tjqnO3YEa/hU3KF+AfQ2oQMBwDc/GgD/gsWnqB8HRjZmyYlI4JncP+RrMnBdwmvgkkX7Qkp1c9DYNhkTogHd25R8qZ6Om+Um2+ps8I22VDY/l9PfyH5SROWSPjnSSvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFI765q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFI765q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C091F00894;
	Wed, 20 May 2026 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299815;
	bh=hpjjqxy42siUggU8eJuX0k6mb+PiibEnKHaMACa2Oj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFI765q0hDepCWXoVc+69W+xByhKJANbiY7yNPOcYIshqX1TFpMzZAOp6o7ah6ubR
	 f/1Xspui/GDtPdayLfVEz/yBT76D3YnYD+nw1h6FDYcqNPOVqUtHvAJnwNBOJlX3vr
	 d3nMsIpNw3oS4OIGl3niNgzpqc8MN9PHu40olvWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Vlad Poenaru <vlad.wing@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 898/957] fuse: avoid 0x10 fault in fuse_readahead when max_pages == 0
Date: Wed, 20 May 2026 18:23:01 +0200
Message-ID: <20260520162154.048212277@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Poenaru <vlad.wing@gmail.com>

[ Upstream commit 4ea907108a5c ("fuse: use iomap for readahead") ]

The upstream fix is the iomap conversion in commit 4ea907108a5c
("fuse: use iomap for readahead"), which rewrote fuse_readahead()
entirely and removed the buggy loop along with it.  That refactor
is too invasive to backport to the pre-iomap readahead path still
used by 6.18.y (and earlier stable branches), so this is a minimal,
equivalent fix to the same bug on those branches.

When fc->max_read is smaller than PAGE_SIZE (common on aarch64 with
64K base pages if the FUSE server advertises a small max_read in INIT),
max_pages = min(fc->max_pages, fc->max_read / PAGE_SIZE) is 0, so
cur_pages is 0 on every outer iteration.

fuse_io_alloc(NULL, 0) then calls fuse_folios_alloc(0, ...), which
calls kzalloc(0, ...) and gets back ZERO_SIZE_PTR == (void *)16.
The "if (!ia->ap.folios)" guard in fuse_io_alloc does not catch
ZERO_SIZE_PTR, so fuse_io_alloc happily returns an ia whose
ap.folios is 0x10.

The inner "while (pages < cur_pages)" loop runs zero times, then
fuse_send_readpages(ia, ...) dereferences ap->folios[0] in
folio_pos(), faulting at virtual address 0x10:

  Unable to handle kernel NULL pointer dereference at virtual address
  0000000000000010
   fuse_readahead+0x14c/0x490
   read_pages+0x80/0x318
   page_cache_ra_unbounded+0x1c0/0x2b0
   page_cache_ra_order+0xb8/0x368
   page_cache_sync_ra+0x210/0x320
   filemap_get_pages+0x290/0xdb0
   generic_file_read_iter+0xd0/0x540
   fuse_file_read_iter+0x8c/0x158
   __arm64_sys_read+0x1a0/0x488

addr2line on the aarch64 vmlinux maps fuse_readahead+0x14c to
fs/fuse/file.c:897 inlined into :999, i.e. "folio_pos(ap->folios[0])"
inside fuse_send_readpages.  The faulting instruction "ldr x8, [x8]"
loads ap->folios[0]; ap->folios was previously loaded as 0x10
(ZERO_SIZE_PTR).

Without this fix the function would also spin forever, since
"nr_pages -= pages" makes no progress when pages stays 0; in practice
the NULL deref masks the spin.

Bail out of the outer loop if cur_pages is 0 -- there is no work we
can issue via FUSE in this iteration, and remaining folios will be
handled by read_pages() falling back to ->read_folio.

Fixes: 3eab9d7bc2f4 ("fuse: convert readahead to use folios")
Reported-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 00ff6374dc76b..50ade371298b3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -974,6 +974,16 @@ static void fuse_readahead(struct readahead_control *rac)
 		unsigned cur_pages = min(max_pages, nr_pages);
 		unsigned int pages = 0;
 
+		/*
+		 * If max_pages == 0 (e.g. fc->max_read < PAGE_SIZE on a
+		 * 64K-page kernel), cur_pages is 0 and we cannot make
+		 * progress.  Bailing here avoids passing 0 to fuse_io_alloc,
+		 * which would return an ia whose ap.folios is ZERO_SIZE_PTR
+		 * (0x10) -- later dereferenced by fuse_send_readpages.
+		 */
+		if (!cur_pages)
+			break;
+
 		if (fc->num_background >= fc->congestion_threshold &&
 		    rac->ra->async_size >= readahead_count(rac))
 			/*
-- 
2.53.0



