Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036E1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9B2C433D2;
	Wed, 28 Dec 2022 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242970;
	bh=KU5932pjdhrvglRKigLEN1WSCikHdkmqEQYKAcOC468=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYYiz4lsdZ7GAVlXfGIpysrd6b9oiFnjeufDYB9yRfAkrLJWdFE9w9XLVKT6sSYRE
	 Czo0Lgeys/K2zWf3tGJuqmUs3d8r6P1nUloSvLVUFYdC472F9vCkHNk0bFL5Pmwy6q
	 rYYVJSIxI8b6wNiFrkLLbhzhF6qM1kHsiiEWBbhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0474/1073] NFS: Allow very small rsize & wsize again
Date: Wed, 28 Dec 2022 15:34:22 +0100
Message-Id: <20221228144340.909541821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit a60214c2465493aac0b014d87ee19327b6204c42 ]

940261a19508 introduced nfs_io_size() to clamp the iosize to a multiple
of PAGE_SIZE. This had the unintended side effect of no longer allowing
iosizes less than a page, which could be useful in some situations.

UDP already has an exception that causes it to fall back on the
power-of-two style sizes instead. This patch adds an additional
exception for very small iosizes.

Reported-by: Jeff Layton <jlayton@kernel.org>
Fixes: 940261a19508 ("NFS: Allow setting rsize / wsize to a multiple of PAGE_SIZE")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 898dd95bc7a7..c194a1e50f0b 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -741,12 +741,10 @@ unsigned long nfs_io_size(unsigned long iosize, enum xprt_transports proto)
 		iosize = NFS_DEF_FILE_IO_SIZE;
 	else if (iosize >= NFS_MAX_FILE_IO_SIZE)
 		iosize = NFS_MAX_FILE_IO_SIZE;
-	else
-		iosize = iosize & PAGE_MASK;
 
-	if (proto == XPRT_TRANSPORT_UDP)
+	if (proto == XPRT_TRANSPORT_UDP || iosize < PAGE_SIZE)
 		return nfs_block_bits(iosize, NULL);
-	return iosize;
+	return iosize & PAGE_MASK;
 }
 
 /*
-- 
2.35.1



