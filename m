Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA46396D35;
	Wed, 21 Jan 2026 18:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019971; cv=none; b=SEQPKEZYnKUPd4XJ6GhditwjEeWeah+0RmgDo69bELtrRsayDEOlOeSjmL/WE3LNN5I0vW8seROPQd2epSdshPSUtadtpjRcwsAJmT/mhHJlXLOPp493It/3ANOzIrzfhQOfCCgoBb0Ok/TPF6SxoUDtUE8V5SCLLJ7b+qwQU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019971; c=relaxed/simple;
	bh=xw16w4gMmKr0C5q02sI1bGw7JXF++zeu9S2ovThVRgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eknhpBi5VH6tCYF+PPf036YRQlRdOcavnVh1oxWbzl8IkN5+j7wOOU84Xs0/sRNaij/WSmgKF/m4ODN8LmYZ6uLiSpRC/vjgjcIr2bEOfO6r0Cd+H+nAHYDmxsEYcP7Xtqk54ILhORzVcWNZ0o6byRyFlXaxyln9Y73FV8n6rsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2gVVQ4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2gVVQ4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2883C4CEF1;
	Wed, 21 Jan 2026 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019971;
	bh=xw16w4gMmKr0C5q02sI1bGw7JXF++zeu9S2ovThVRgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2gVVQ4Jo3Aar6ZF6LPl4XV9gDxNkK4MBKevXAADJHSEcyZzHEjpSqJGazFxKWTsH
	 Whq5PgQo/q4WSfGjkv7eb0ZCdnyJAF+bDg1/aDYo5liJkx8YH1YPk8HuBrViXQzYHp
	 iam6cYbtxWw3aTLvCSGZej8eJh3v+lDLlmxNc33A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/198] NFS/localio: Deal with page bases that are > PAGE_SIZE
Date: Wed, 21 Jan 2026 19:14:09 +0100
Message-ID: <20260121181419.317312255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 60699ab7cbf0a4eb19929cce243002b39c67917d ]

When resending requests, etc, the page base can quickly grow larger than
the page size.

Fixes: 091bdcfcece0 ("nfs/localio: refactor iocb and iov_iter_bvec initialization")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index ed2a7efaf8f20..f537bc3386bf2 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -461,6 +461,8 @@ nfs_local_iters_init(struct nfs_local_kiocb *iocb, int rw)
 	v = 0;
 	total = hdr->args.count;
 	base = hdr->args.pgbase;
+	pagevec += base >> PAGE_SHIFT;
+	base &= ~PAGE_MASK;
 	while (total && v < hdr->page_array.npages) {
 		len = min_t(size_t, total, PAGE_SIZE - base);
 		bvec_set_page(&iocb->bvec[v], *pagevec, len, base);
-- 
2.51.0



