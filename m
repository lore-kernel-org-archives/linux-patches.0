Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D91C5D72;
	Mon,  2 Jun 2025 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874656; cv=none; b=tCag4AWy3U/D3YbZJRZR4wUbiBIMxR829FgeOGf8HfB9QuTLM7FZoULyvemEnr1LkCv3ZM4Co6b99/MTqcQgPRyyq9LLs7duvdyYqd+8OjDDw2uMZdXse9R6IA+Pf75zFil54YZCvoRz+EEQqYZ+67PBxSgtjFbiqrC4oZg+Bzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874656; c=relaxed/simple;
	bh=28eQU9y5DXDBDWwjMEdvZHxFfqveTEzBjiWhhftUVIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyRv2990MW+qiuDmuN9VIf0g9RaWi41lnbABvUCOGU9yCbTM1aE1IyhWEUL08g6dp56eBt5KaX5nFnsSxAiMKTKh1fDxvWJsgqnaumKhCh6vbJurh2PnkuNeE0ycdICyr4SKdqQo0midngZjrOsey1lA/pCUhBUZH3dm7okaS6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYzefLJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYzefLJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D032BC4CEEB;
	Mon,  2 Jun 2025 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874656;
	bh=28eQU9y5DXDBDWwjMEdvZHxFfqveTEzBjiWhhftUVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYzefLJbcKR1ZEnA1Q9pzsjepSUMiNO+/r9sbnbidwDSNatKRyGMBACiV0qpKda1m
	 bdNrMq3/PjXgozohTspX2OH5JvsmrnzYmaiPXx8cBcAacCCORzSqTOCOzeS5q4XdD+
	 Cg8X/eU8qAPzSjegwVPJZJdO42TRidOx+3S4GNZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/204] NFSv4: Treat ENETUNREACH errors as fatal for state recovery
Date: Mon,  2 Jun 2025 15:47:06 +0200
Message-ID: <20250602134259.314595779@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 0af5fb5ed3d2fd9e110c6112271f022b744a849a ]

If a containerised process is killed and causes an ENETUNREACH or
ENETDOWN error to be propagated to the state manager, then mark the
nfs_client as being dead so that we don't loop in functions that are
expecting recovery to succeed.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 1d38484e0a53b..b64a3751c3e4a 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2655,7 +2655,15 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	pr_warn_ratelimited("NFS: state manager%s%s failed on NFSv4 server %s"
 			" with error %d\n", section_sep, section,
 			clp->cl_hostname, -status);
-	ssleep(1);
+	switch (status) {
+	case -ENETDOWN:
+	case -ENETUNREACH:
+		nfs_mark_client_ready(clp, -EIO);
+		break;
+	default:
+		ssleep(1);
+		break;
+	}
 out_drain:
 	memalloc_nofs_restore(memflags);
 	nfs4_end_drain_session(clp);
-- 
2.39.5



