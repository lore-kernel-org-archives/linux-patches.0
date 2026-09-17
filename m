Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446874E5350;
	Thu, 17 Sep 2026 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666712; cv=none; b=F6PlePrwRGopGy2QBROkCZjoMh19By4/2+taPbMYLWwr9UQVV2/MIkP11Qa2vImZ6yCN9DPG/Kv0JKhhlzuULO5RqDlHv+FrJ60XjDrOOWKaQEQ6kOqWPKufK1VRZthOwlFK6xl5qwHFZ5u+Hz3l1sDbAw7QKgjBR6mETXctX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666712; c=relaxed/simple;
	bh=A7ath27qBEy/nq0w2bmkCqIUnlclit6p6N6ZpytixE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF6Q/lrCbM7DC6b0B2OWgnn1/RVjNZcnHojpZlEiEtJUiA3i2tF/K7S5QXziHI/6gf9C6uycwBSXjdCIyZhieGSr+c10dAyHM8WAI/CjPb6SQ6sqDsz3Y4tBJYJsM2OyYQ8bCYPYP+eWo3OjrniOdsMYiFZmsQvQREjPFh1h8AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZA1KTrJk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZA1KTrJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD6A1F000FF;
	Thu, 17 Sep 2026 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666710;
	bh=ilFx5QMblg7NykqhIci3DR8M9Dd+Bdauvch4/0/zzrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZA1KTrJkm1GRmR17PRYW38RntsF6E7kL8Vm06Qh2+xje2GH9LBmRfUjIvjrIsweXI
	 Yv9GnBlMJQkj1Bita1dE5ClHZgZ4jQhomZckYn9tB4u3K0mkSXSh3WZXuk/2vlisWE
	 R+h3Gu0Hl5oAUPfws1QHlfsPxdhY0hEVaMaesPzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 1128/1250] smb: client: fix UBSAN array-index-out-of-bounds in smb2_copychunk_range
Date: Thu, 17 Sep 2026 16:15:23 +0100
Message-ID: <20260917151622.823907683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -1970,6 +1970,12 @@ retry:
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


