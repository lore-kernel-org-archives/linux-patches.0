Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2281B35F8B9;
	Thu, 16 Jul 2026 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210034; cv=none; b=Xm7KzBSZ8j/0zgnnlkexnczC3KIPTkmISS6rNv0lAbDE7RQzITHKZWwCzV3M/yzcru3WCzzC/6uEaygWDYCE+Byxrq91xnPgGg3v6+Y7BnI/mo8nPJwpuOOPcbhFKKt7o1AnSOi6spzPtac4Lqs1e2ehCkXXKq3Cw2CC1ONXZsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210034; c=relaxed/simple;
	bh=lug1osK5A+TyUIA0m+pDJsLPEtMzZRBFCGcVBIqlGnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxnX1Ygrmbrpm9xL/zXGO/Dfpwzt0AGIqJz0Jvfk2NKm5lVnPqY5FHXwG2Xe2PE+AcxzgglDyjrGIp1yGWjfrMd5ThOJDPTW7yCcvqafPNDYx65TyNTr20q5u3p+pRVy2t5AxntMfweSQhCtEHMgAAK0iOL96EJzceFTmuyTJfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMc3zgZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMc3zgZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879691F000E9;
	Thu, 16 Jul 2026 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210033;
	bh=z/xHVkvFg3zdFhGMYO5ATo7J6CnvEwqNZ5I4xvoBYJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMc3zgZhE0cE4aJlNMbvWAIUpizaP0mbx6kh2i/JE2A92abO95h2z3+TXrveLs7Mv
	 DPf1eit1WDCGMwv3XAvez6nCJuYtra964B4RLsbg0EDnql09CpvlzfksiJjAzQRP16
	 EBJ97GCZgz/r6IzV85Ms8y2fvMxc4CsFxj2Inn6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.1 413/518] NFSv4: include MAY_WRITE in open permission mask for O_TRUNC
Date: Thu, 16 Jul 2026 15:31:21 +0200
Message-ID: <20260716133056.871682469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 5140f099ecd8a2f2808b7f7b720ee1bad8468974 upstream.

POSIX requires write permission to truncate a file, so an open() that
specifies O_TRUNC must be authorized for write access regardless of the
O_ACCMODE access mode.

nfs_open_permission_mask() builds the access mask passed to
nfs_may_open(), which is the local authorization gate for OPENs the
client serves itself from a cached write delegation via the
can_open_delegated() path in nfs4_try_open_cached().  The mask is
derived from O_ACCMODE alone, so an open(O_RDONLY | O_TRUNC) against a
file the caller cannot write requests only MAY_READ and passes the
local check.  The OPEN is then satisfied locally and the truncation is
issued to the server as a SETATTR(size=0) over the delegation stateid,
which the server accepts under standard write-delegation semantics.
POSIX requires that this open fail with EACCES.

Include MAY_WRITE in the mask whenever O_TRUNC is set so the local
check matches the access the server would have enforced.

Suggested-by: Trond Myklebust <trondmy@kernel.org>
Fixes: af22f94ae02a ("NFSv4: Simplify _nfs4_do_access()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -3344,6 +3344,8 @@ static int nfs_open_permission_mask(int
 			mask |= MAY_READ;
 		if ((openflags & O_ACCMODE) != O_RDONLY)
 			mask |= MAY_WRITE;
+		if (openflags & O_TRUNC)
+			mask |= MAY_WRITE;
 	}
 
 	return mask;


