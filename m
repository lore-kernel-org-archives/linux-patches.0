Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7577E44AB91;
	Tue, 21 Jul 2026 22:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673372; cv=none; b=W/F849b7jU8KUamHKU/RF8mb0YUeyOL0wLAXVJr1aRmm39cW85HvuQADx43oQ/ULLnM4V1c6Rz1e29pwaIGfyW6KA72beSAnCaNxSQxW9Tjzgn33ARZFua4baGIowIONOzqTZuyO4xg/Wg9Wbz7mBhQq06hF3qv8K18EXnaKr3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673372; c=relaxed/simple;
	bh=Mvqz4A25IYcwe9gFSWNmqA1Jo2t8HsocHBEPfkESn6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lqrl4RIRvLdwM2uAavOxfm5sHd062a8VpzdloEzO5Rs4sHxqd1d1i1CsL5+PJao/Xe5xXrscY/WSJ4XOrOiN/fnceGc4Ua46VM0CVkP/tFHHrXemfSkD4IGveCH3x+Yt4tZpGC5YrDtZeZVz8/J8nTVLfGeT5DW3mYTHm6bxRIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SB01bbDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SB01bbDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA581F000E9;
	Tue, 21 Jul 2026 22:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673370;
	bh=vDANF5ZAkdkI2ERNmZn9g9/pAUynu7tOVlPOzhQ7mt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SB01bbDX72NSH7ExrzRvXW/jQSRn3UjZJlLPp7IaVBtEheiHVyMvdTIwxmeflpluE
	 c70KVlG+apsPEx6bfsLNWcCnRxp8eXQuBXE1gQ5/5fPyMT6PGVzmjNqJkkcPlKD9wX
	 TathYaOyRmOq7QOuGXouA4hfWd7jHkpdRBHnHAA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.10 138/699] NFSv4: include MAY_WRITE in open permission mask for O_TRUNC
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152358.822795855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -2803,6 +2803,8 @@ static int nfs_open_permission_mask(int
 			mask |= MAY_READ;
 		if ((openflags & O_ACCMODE) != O_RDONLY)
 			mask |= MAY_WRITE;
+		if (openflags & O_TRUNC)
+			mask |= MAY_WRITE;
 	}
 
 	return mask;


