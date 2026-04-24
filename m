Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4563D3D04;
	Fri, 24 Apr 2026 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037991; cv=none; b=fCu3kWbLNC4AXDC6u2pq5eywsRMbIJYCvB9StpwQqYQ1YascRkIogHdQx93HcWvxbz+tgOdpI37jaXw4p9F3/QGdO1Pl3QwSuSbWXuNMbOY1DJz96g2zVe/hD6F06gQ6cyw0dyvgByKUQTz6M26CNifgNRtuEaKqbEKWolC5fhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037991; c=relaxed/simple;
	bh=l//CQKOaBjmfxjumba+U0HijTfvrLM4OOUVuAQRYScI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdVIpvj65rM+f8wp81+nDSrA0PoMMHP/IVvJxXTN4mCVNV6V/6l8dHWfnEnIdmImueKMzM/9bIuKqr4aQghiC+Bme6CKvFiwCBmFQghChwhx+wzkOTke4FUdGaOhnKQK5WuEAPQlukwl9nv2OFjJ8HqiF82BaagBwWlTLkTpXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Q1Ne0mS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Q1Ne0mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAF3C19425;
	Fri, 24 Apr 2026 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037991;
	bh=l//CQKOaBjmfxjumba+U0HijTfvrLM4OOUVuAQRYScI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Q1Ne0mSPnhj/1u6dbNUN9vAEvNqQJLTQ21fCLH3Ggi3UuZMhFSgsBHsVX8eDzySW
	 EQ5hh+9vMCdj+kXzTKRq/VUTvlw+SLqhYMR/IY03ygThOi8VIeMc1TuKxuwAQ+hKxB
	 8uMPvuumS5QhJuQt86/b7u0nmMptdYIEm2qf5zsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Qi Tang <tpluszz77@gmail.com>,
	Zijun Hu <nightu@northwestern.edu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 147/166] fuse: reject oversized dirents in page cache
Date: Fri, 24 Apr 2026 15:31:01 +0200
Message-ID: <20260424132603.883061538@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Page <sam@bynar.io>

commit 51a8de6c50bf947c8f534cd73da4c8f0a13e7bed upstream.

fuse_add_dirent_to_cache() computes a serialized dirent size from the
server-controlled namelen field and copies the dirent into a single
page-cache page. The existing logic only checks whether the dirent fits
in the remaining space of the current page and advances to a fresh page
if not. It never checks whether the dirent itself exceeds PAGE_SIZE.

As a result, a malicious FUSE server can return a dirent with
namelen=4095, producing a serialized record size of 4120 bytes. On 4 KiB
page systems this causes memcpy() to overflow the cache page by 24 bytes
into the following kernel page.

Reject dirents that cannot fit in a single page before copying them into
the readdir cache.

Fixes: 69e34551152a ("fuse: allow caching readdir")
Cc: stable@vger.kernel.org # v6.16+
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Reported-by: Qi Tang <tpluszz77@gmail.com>
Reported-by: Zijun Hu <nightu@northwestern.edu>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260420090139.662772-1-mszeredi@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/readdir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -41,6 +41,10 @@ static void fuse_add_dirent_to_cache(str
 	unsigned int offset;
 	void *addr;
 
+	/* Dirent doesn't fit in readdir cache page?  Skip caching. */
+	if (reclen > PAGE_SIZE)
+		return;
+
 	spin_lock(&fi->rdc.lock);
 	/*
 	 * Is cache already completed?  Or this entry does not go at the end of


