Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747C4E0B7D;
	Thu, 17 Sep 2026 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671293; cv=none; b=ekuukQuoZoblzwyJNtbN+laiGdPUWcYQcrJ2thZYYf1ZHm9IV4Oi8WIJrmmvIRfiruSrY33qaT8JnvMiSPryJRYL08bQHjhZgxS6xCl1tY9Y2kgfD/DoMR/jSIwEKYjblt162ABjeGCT1EBaG+UaDdBYYPTIOzyhCSNR3wlXupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671293; c=relaxed/simple;
	bh=TjFXGGGxa/TAGvHplUeO+miCEdoX7L3Y5LQn0QaR4Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7IWpF8gUsfYIBJqUwM4rEYsHdgfeV2oiBEW3F9CbfCdL7/FhQPONj5F7TyRURrtPse8Z1oFWtHsettrWavrlWaw5OGZnumoxl/DKz5quyjR4L+9C3nzFFOfPBNXMGoSqNaP8Z6XV/j1z56CicuAjrZeuU6Pdt7wPJld8BOxgIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVlTLyyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVlTLyyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B201F00893;
	Thu, 17 Sep 2026 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671291;
	bh=Ll6Kc4/0WetRp2h4+EX5mJ9LsR5U14mdo6rgfH9baqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVlTLyyw12ZyOVbz2ER/GULxfj+2AihqVl5mRBkAxuQcXxkb+7LWjNuZzsMH6Wut7
	 6c+wp733iYMYc5No4P+SXXiQUq3+2UqGnKPU/RMu45XhNpqCDHPsLsHDqfLr0xNXus
	 QFRB6Xu51zQwBS4mQzMXwXYUQidYTzaHsD6aOff0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 0921/1102] smb: client: fix UBSAN array-index-out-of-bounds in smb2_copychunk_range
Date: Thu, 17 Sep 2026 16:14:24 +0100
Message-ID: <20260917151603.754622880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit fa2fd0b10f66b08bc44745feed1761d7c1539d6e upstream.

struct copychunk_ioctl_req::ChunkCount is annotated with
__counted_by_le() as the number of elements in Chunks[].

smb2_copychunk_range reuses ChunkCount to store the number of chunks
sent in the current iteration. If a later iteration populates more
chunks than a previous one, the stale smaller value trips UBSAN.

Set ChunkCount to chunk_count (allocated capacity) before populating
Chunks[].

Fixes: cc26f593dc19 ("smb: move copychunk definitions to common/smb2pdu.h")
Link: https://lore.kernel.org/linux-cifs/CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com
Tested-by: Youling Tang <tangyouling@kylinos.cn>
Acked-by:  ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1977,6 +1977,12 @@ retry:
 		src_off_prev = src_off;
 		dst_off_prev = dst_off;
 
+		/*
+		 * __counted_by_le(ChunkCount): set to allocated chunks before
+		 * populating Chunks[]
+		 */
+		cc_req->ChunkCount = cpu_to_le32(chunk_count);
+
 		chunks = 0;
 		copy_bytes = 0;
 		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);


