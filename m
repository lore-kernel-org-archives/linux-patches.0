Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA66527585;
	Wed, 30 Sep 2026 18:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793706; cv=none; b=tyhShqEB1O0Hbbto/523pYnLZZQBuSVtZPUTGn9UqEgM/hZTBYwj+++sqL+DfJYGk3ypSUjiHMVgddCzd6KHYPqGQ7er6XhgF2jA7kwagYQ6dmZOjc1wtyXBOvXOnz0PldvNo/b4X4HFKiZdxG9GI8fSmh6EFgoB5Ye3pvKcHa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793706; c=relaxed/simple;
	bh=BXla7pNVpL6m/TCDpD1FefyT3EXDfeIrAi2wyQgXL/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqqXZbImkG1lwpcctDAaP99KoKZ1YfmRARkqxLaxS8ORLxKXLQxqD4jn0zrMZBiyuAG+/uz0khkR7B0Z9AQfspmzqldJQeXjo4wUtmU8XVcwQcHVOiYPK9SQDO8Abl4eaFNrLTNTm4X5beRC1Z+GorXXWND/XcHHNyv3d6KDMxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRdQNeIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRdQNeIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC8F1F00898;
	Wed, 30 Sep 2026 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793704;
	bh=VfHNInFzx0KVi3DtDlausdJx+00rrNsseRUTxhL6/iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRdQNeIaQ80tcqe8CZrPjTtEPoTZzdf8pBRI2I+1D2TK1SXPqtek2F6Jxh26mXClZ
	 o1pbKD9/v5unh9KQQuq8S7cWRzJ3w3mMAKftVKJ9iXVoOqm3PMFcscKbwOlo5eWaEU
	 Y6KazdBoKei4matDolVsRqY7ydSR9rBNlsiXRcQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/395] net: tls: fix silent data drop under pipe back-pressure
Date: Wed, 30 Sep 2026 17:30:10 +0200
Message-ID: <20260930152348.225635637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e7be31bfdb066c1c780dcd6b1224078fc54063f ]

tls_sw_splice_read() uses len when advancing rxm->offset / rxm->full_len
after skb_splice_bits(), rather than copied (the actual number of bytes
successfully spliced into the pipe). When the destination pipe cannot
accept all the requested bytes, splice_to_pipe() returns fewer bytes
than len, and 'len - copied' of data is effectively skipped over.

Fixes: e062fe99cccd ("tls: splice_read: fix accessing pre-processed records")
Link: https://patch.msgid.link/20260429222944.2139041-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ea78e2ce754fb..ad6c0d61d5474 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2372,9 +2372,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (copied < 0)
 		goto splice_requeue;
 
-	if (chunk < rxm->full_len) {
-		rxm->offset += len;
-		rxm->full_len -= len;
+	if (copied < rxm->full_len) {
+		rxm->offset += copied;
+		rxm->full_len -= copied;
 		goto splice_requeue;
 	}
 
-- 
2.53.0



