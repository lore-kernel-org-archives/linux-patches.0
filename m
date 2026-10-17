Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEF138654F;
	Sat, 17 Oct 2026 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254160; cv=none; b=uIQkFpvvvPq2zzts4/FhP4YqRQkilrDuKVKgoQPhNNhleMCj4ZR5zx+fOvSBBfXtUg8MgMEvbABIFy1+qAhbERNYSsHnOx5hVSw2OyEGXYG+bU1am+wcrZ/uZc+GDnpPPXOaAJFnCyB3PdguFpHGtt8PV6Z09YHYoVGLNeGQTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254160; c=relaxed/simple;
	bh=I+cJsK5AgfDPOpzRTkc5P+BhttIEP0p1/9HIEs/3Dog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHSI917fLjUkj+4/rtGRqc6yXInO1koK5CS0tnGgktoeAwOd1SD6+W2R1m2YaeUQp46G31SsZ7DT38d+57tVRSiZhU3hgAZr301wLxIQPUw1ozSHi4m507BXa5enZrn1xpwG0BDI6nxc8vKMV2PcNOEhbitz1qmIvIsthn3BYqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJbRIacF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJbRIacF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40D01F000C4;
	Sat, 17 Oct 2026 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254159;
	bh=Y2wohOPA0pR9+KUKyFDJOjpEw67R0mtDm4FgoDnZHlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJbRIacFsmXuLXBaMd3wLuYy74CRBLWK/kAUYCib3l4FqUyQcNR1frE72ejli3EX7
	 PFpDYJZToJ9YDcbpmedSgcuh26XEeolZg0ESqxCbu7lw3QjhY5ISB8rQnNnv1R3PNz
	 CUKvx8DFwA1ey6u4eFEVR/zJjFxKVjVNoaW01c7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/869] netfs: Fix leak of request in netfs_write_begin() error handling
Date: Sat, 17 Oct 2026 17:53:16 +0200
Message-ID: <20261017160046.203895768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5046a34f0643441f05b0253ea64e1a3af87efe14 ]

Fix netfs_write_begin() to not leak our ref on the request in the event
that we get an error from netfs_wait_for_read().

Fixes: 4090b31422a6 ("netfs: Add a function to consolidate beginning a read")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-19-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 562c59f421334..ec78ad094cf4a 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -753,9 +753,9 @@ int netfs_write_begin(struct netfs_inode *ctx,
 
 	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
+	netfs_put_request(rreq, false, netfs_rreq_trace_put_return);
 	if (ret < 0)
 		goto error;
-	netfs_put_request(rreq, false, netfs_rreq_trace_put_return);
 
 have_folio:
 	ret = folio_wait_private_2_killable(folio);
-- 
2.53.0



