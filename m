Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C396314A088;
	Tue,  3 Dec 2024 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242684; cv=none; b=cNo3dRHz28hJz4zQ0/ISzuAnkL51DCKLbilI4DvP1OW2DATuVM/3YoD+FQxQBqKjcdqyDZ1G+hBkCfKT4zVyZooCejxbHrNfBCPAnSIeHJPWk3PdFmpEeLGn7RjwR6N3Lwk2gQQZZE+mDZFoK5jDWrTuISwODTVtR+YDtp1VT7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242684; c=relaxed/simple;
	bh=IEqozqj1PHEDxnZKDwQdTtHAsv8d8YS9h8uiMlTzuTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9Jd+q4oHWsn4bCG9TTr3CcEMbreMjiNCKfkQvmJ/KkNy2ePqcF28yJhzxfo4ZFGr+b0EFBuuYHwPBOJ3swW3fVE4fwKJPwNx5jL3sxdObB75jQET0RVkDU2/2+pgnFNxu4saiNl0Wgwhma3dZs++ufPr2adNKKWJuw48PcHHu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk834+vX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk834+vX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49616C4CECF;
	Tue,  3 Dec 2024 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242684;
	bh=IEqozqj1PHEDxnZKDwQdTtHAsv8d8YS9h8uiMlTzuTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk834+vXK+eqc/aKpU2mkx0j6vL96iSq70yn5oIYGuea6ZmYg4Z/x35kE5qSLjIXW
	 z8nYiwxe27rRW02h9NUBp2DtFhHCPu1EASCKzz8PpIJkTsHt3iyFTwS5qNFkPgB3rx
	 cXN7TZ3BEq9rGfjgmsfdcTIhR+pEYnjzWRWE4gxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 778/826] nfs/localio: must clear res.replen in nfs_local_read_done
Date: Tue,  3 Dec 2024 15:48:25 +0100
Message-ID: <20241203144814.113938942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 650703bc4ed3edf841e851c99ab8e7ba9e5262a3 ]

Otherwise memory corruption can occur due to NFSv3 LOCALIO reads
leaving garbage in res.replen:
- nfs3_read_done() copies that into server->read_hdrsize; from there
  nfs3_proc_read_setup() copies it to args.replen in new requests.
- nfs3_xdr_enc_read3args() passes that to rpc_prepare_reply_pages()
  which includes it in hdrsize for xdr_init_pages, so that rq_rcv_buf
  contains a ridiculous len.
- This is copied to rq_private_buf and xs_read_stream_request()
  eventually passes the kvec to sock_recvmsg() which receives incoming
  data into entirely the wrong place.

This is easily reproduced with NFSv3 LOCALIO that is servicing reads
when it is made to pivot back to using normal RPC.  This switch back
to using normal NFSv3 with RPC can occur for a few reasons but this
issue was exposed with a test that stops and then restarts the NFSv3
server while LOCALIO is performing heavy read IO.

Fixes: 70ba381e1a43 ("nfs: add LOCALIO support")
Reported-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Co-developed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 8f0ce82a677e1..637528e6368ef 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -354,6 +354,12 @@ nfs_local_read_done(struct nfs_local_kiocb *iocb, long status)
 
 	nfs_local_pgio_done(hdr, status);
 
+	/*
+	 * Must clear replen otherwise NFSv3 data corruption will occur
+	 * if/when switching from LOCALIO back to using normal RPC.
+	 */
+	hdr->res.replen = 0;
+
 	if (hdr->res.count != hdr->args.count ||
 	    hdr->args.offset + hdr->res.count >= i_size_read(file_inode(filp)))
 		hdr->res.eof = true;
-- 
2.43.0



