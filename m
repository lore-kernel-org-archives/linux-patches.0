Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104D7EF02;
	Mon,  8 Apr 2024 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584090; cv=none; b=HiZNvNn+paNXu1CtmIfvGy9a7VN7O76oj7Rrk0aZKoqT/2cygj2ejNYt/SOczYEZ6V223igLDgFHdJOPjDu0OdOhKtN1yBwRQf/G1VpYnd/iS4k2oem08pTTZi3EA70PBCIknefoUN7ohcmHaN7c2OCd4H5JX2MeFzSIAsgP5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584090; c=relaxed/simple;
	bh=qqMelK+x0EpMJ8l1YYUBZcDdrL3Qm/8YB/s6+W5URXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zbc7KVUwnKxdIITDswpNBP7jbThNUHRwOKkCZiy01z+emaU2cRG8eb3MZir0UmT95D8KHgL84+bBgA2u7gXPguZ5cKoIOMJo2x5wUN9xDz/QEp1eleMZX7FeU+ohbdCHyQtQZJw3MSzjX/pRu7ZRIO9I4I4miWwaUpUdS+tw7UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I783YBoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I783YBoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC23C433F1;
	Mon,  8 Apr 2024 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584089;
	bh=qqMelK+x0EpMJ8l1YYUBZcDdrL3Qm/8YB/s6+W5URXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I783YBoGIaGbXlTUa2mSYl8/fJ3uUSn0ju1+oYn+imbXqUimuDOCJvioIhdfLs/S+
	 PXBvbCClxeIgtmolbpxDzLxWHnMhDIVZCgzBrTM9uKa6EB2f7ynUytByeFAgTcmqpk
	 OX/PP7s/z0G32/1PfJDiQXjs7cVRGCqcLJrk+zAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 332/690] NFSD: Fix potential use-after-free in nfsd_file_put()
Date: Mon,  8 Apr 2024 14:53:18 +0200
Message-ID: <20240408125411.630313466@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b6c71c66b0ad8f2b59d9bc08c7a5079b110bec01 ]

nfsd_file_put_noref() can free @nf, so don't dereference @nf
immediately upon return from nfsd_file_put_noref().

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 999397926ab3 ("nfsd: Clean up nfsd_file_put()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 27952e2f3aa14..1d3d13b78be0e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -302,11 +302,12 @@ nfsd_file_put(struct nfsd_file *nf)
 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
-	} else {
+	} else if (nf->nf_file) {
 		nfsd_file_put_noref(nf);
-		if (nf->nf_file)
-			nfsd_file_schedule_laundrette();
-	}
+		nfsd_file_schedule_laundrette();
+	} else
+		nfsd_file_put_noref(nf);
+
 	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
 		nfsd_file_gc();
 }
-- 
2.43.0



