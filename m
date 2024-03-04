Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786601F92C;
	Mon,  4 Mar 2024 21:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588947; cv=none; b=hDYOy7Xy2Nn4Fl+X8tSMEjGtmoD4mD96f58ALS0Lqmp5TXHuPFFUWYSaPX+VWUYgNPG9OjQAy/fv2BqAvGdVnXKorM7WQeQbJOm78YvuA3GbN3mJE+a4O6SJZAWYHSjtj/A+ZAhX98oqhv+P7f5Jfz0cO9dtJ6X25W8VvztVhvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588947; c=relaxed/simple;
	bh=AmRdIBxVA4+aB74YiWp7RyEdwbhLnPlH5oZpYOde/Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjYTNo3QQYetwPXaQqCTQQJM01vpM+4RnBuIohFPqz438QdtAHv7Jo5BAy9xwO2hv2LmQXBylUlQxCB6mt9YsO6z6u8LZUypONA12CqyDNdt5B/RKtJP/3qGgLoq/NEf8q4p/RXsoyAnY2Rq4EfYotGzKY6IaFHVA4iKY5/6EDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+VJ0/V3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+VJ0/V3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB4EC433C7;
	Mon,  4 Mar 2024 21:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588947;
	bh=AmRdIBxVA4+aB74YiWp7RyEdwbhLnPlH5oZpYOde/Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+VJ0/V3rLcqWtnYMr0Xd4w9i21SHueX9rLOCq0b60Y9RQ6IRgSAG79F78uVpRkJ9
	 Qnxg0Z3VPUx5cZaU4IdGL3XiumD3VGJrJlYGt02PQRIGwqvFS42hngUVuSUfDG46NO
	 DBuw4DrjO8JikujcRVF3V5wqjcOLnxsAIVWel5yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-nfs@vger.kernel.org,  Jacek Tomaka" <Jacek.Tomaka@poczta.fm>,
	NeilBrown <neilb@suse.de>,
	Jacek Tomaka <Jacek.Tomaka@poczta.fm>
Subject: [PATCH 6.1 142/215] NFS: Fix data corruption caused by congestion.
Date: Mon,  4 Mar 2024 21:23:25 +0000
Message-ID: <20240304211601.558292823@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "NeilBrown" <neilb@suse.de>

when AOP_WRITEPAGE_ACTIVATE is returned (as NFS does when it detects
congestion) it is important that the page is redirtied.
nfs_writepage_locked() doesn't do this, so files can become corrupted as
writes can be lost.

Note that this is not needed in v6.8 as AOP_WRITEPAGE_ACTIVATE cannot be
returned.  It is needed for kernels v5.18..v6.7.  From 6.3 onward the patch
is different as it needs to mention "folio", not "page".

Reported-and-tested-by: Jacek Tomaka <Jacek.Tomaka@poczta.fm>
Fixes: 6df25e58532b ("nfs: remove reliance on bdi congestion")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index f41d24b54fd1..6a0606668417 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -667,8 +667,10 @@ static int nfs_writepage_locked(struct page *page,
 	int err;
 
 	if (wbc->sync_mode == WB_SYNC_NONE &&
-	    NFS_SERVER(inode)->write_congested)
+	    NFS_SERVER(inode)->write_congested) {
+		redirty_page_for_writepage(wbc, page);
 		return AOP_WRITEPAGE_ACTIVATE;
+	}
 
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
 	nfs_pageio_init_write(&pgio, inode, 0,
-- 
2.43.0



