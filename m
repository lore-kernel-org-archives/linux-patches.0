Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B907219303;
	Sat, 30 May 2026 18:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165614; cv=none; b=vAgEmSyngyh00Kv+IvHqFOVfLrCqME/nhUa6w4f5MyyQvoLZffKIDePzieYxfNMVdtTjdg0M1GR4dVU6JcLihOJ+CXLKhWSm1jMEQk9pY3QwINiQ5HFh7Nld0BURfoCWUeZTvJoS5uDjsffTy0Fp6GgDlCCCf8SPsm/q7vRMgH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165614; c=relaxed/simple;
	bh=A3mqkrx/mFOJjt9TUqD+TnVUe88r0qn7yuuNKK97X84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4isXg0HVhbfbMSNqoSm2T437pA7EnsKExeD0iPQLjnyp9FCrTWmBJFa0K3z09IKUm3I/6GX6rZc2ElTPXHIt7sMhn/8fhHVKV0X/bQkOO4NhjzazlbZ7l/6MuLbTmbbTr1+8LCKw10WZhuBHLlPFiRMtsnDckLAaQ64HNDtakM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAD0s1xH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAD0s1xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B2F1F00893;
	Sat, 30 May 2026 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165613;
	bh=ykYhWK55qvT7wpifCRTYGPnIEwK7yH1oNAHB9RpeqSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAD0s1xH5dj39CHVf4cFC+aNl8z4OGYyuR0wQmRdEKsiZrlPxta8o5ZVNTXzwC9mi
	 JK/cQ5uC3HDr7RuaL0EvuKO+wV43ykDI8vXqydL0aJyxuoPWmJ2Zkc70oFWn0pFsUH
	 f7K5SqHTSHsAtUYUNZXHe/FHYjl27fqprYtqy8Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Qi Tang <tpluszz77@gmail.com>,
	Zijun Hu <nightu@northwestern.edu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 129/589] fuse: reject oversized dirents in page cache
Date: Sat, 30 May 2026 18:00:10 +0200
Message-ID: <20260530160228.164344445@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


