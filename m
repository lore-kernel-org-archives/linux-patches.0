Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A38822AE5E;
	Mon,  2 Jun 2025 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875537; cv=none; b=IWFcdXkm5oIgsVDv8gl6HE8hjXVWq+IKf++FmszSRlr1j/fN/PgCn/yD3Zy4LCJN2Ez3CSb1M6bmbQMZpQoPQX7EUYARec+4DUC0Y6ShtZUJlWWsVqeld/wQBayFfUNehZPocYx2A+jPhT2/fNiiiVJ8N9o/bKQ4k7n2UbKLNW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875537; c=relaxed/simple;
	bh=yoLOrXsANhTBuIbzfPTk/coZ6iFTtewH6h2f1ED8u+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5Y6E5+DJ8ohsYh/kW6ah3IXs7zNsgCZJ3HapuwednoEImQIdgSjzM8C9+QPMp7y7Tr2wwF/wyG7xwaL8vgyL4RBbI63Lpmhb3PCrJ+97f3b6OtnATmcGD/e7/zsrYPV6rmpmY9EByKRaOlhi0BMTueIvypjVdLwM6MLzVPbIKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIwrz8tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIwrz8tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6283AC4CEEB;
	Mon,  2 Jun 2025 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875536;
	bh=yoLOrXsANhTBuIbzfPTk/coZ6iFTtewH6h2f1ED8u+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIwrz8tg3iqwJc7CGE5PEbqH7pY7M7agwPnK06RWI1NeAkQxmo2jPKtoT7NY34GJc
	 HD6fSDLa5zlvZThipjzUMl0dSsX6HD4myM1SjchZnkUYc42ebTkBg6Gvq2Rdy0Fwtx
	 0WieIfKGWD3tN9lSanZcRUxD9exkmfCqdI+82uW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/270] NFSv4: Treat ENETUNREACH errors as fatal for state recovery
Date: Mon,  2 Jun 2025 15:46:50 +0200
Message-ID: <20250602134312.341945970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 807dd6f17e1bd..e3cabced1aead 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2719,7 +2719,15 @@ static void nfs4_state_manager(struct nfs_client *clp)
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



