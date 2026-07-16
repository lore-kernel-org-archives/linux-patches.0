Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4AC2FDC53;
	Thu, 16 Jul 2026 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211347; cv=none; b=MRRFJVGXTWfK3gf18exC+CyHGTus9Du1LyDBWxU/Jw8wLN7vt3B972161kUqa6TyrQMt0PboRy4MPzTdghsWgoz32t8Uw6gEtfcsElP91ddlhQfbB2QTlwEuvK/7PcRVFHco5T7XhuhMCEzQ341apaJpyKw0JdPIqZBaJ6ooS9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211347; c=relaxed/simple;
	bh=u6spkd5JCVGZCWRMuDK8E0p4eZ54jUuECyPFGsrWBwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWeKGGMaTZd2RK6jzo42pYOYfxWVff/o+SjLY7cPsKs/aYJ5tDNgaDv78tcXVPmQSmLjK8Oa60TYcCGiS93+tmdH9z4FuZKGAl+/gGjqnaVokeJXHphej0iLUJrQ3n1XuKuVhqkyHkCHC/wBtHi+G+jKVfQJ2lu//o1v/t6OWkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRRRSbTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRRRSbTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD831F000E9;
	Thu, 16 Jul 2026 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211346;
	bh=5vu238qOtNKPcVYTZDDm3aQc3HKOWLlk+g6k24yuCGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRRRSbToKZet0EqCHwXTu1ggJGW5kCfYommQ1hzEdXPhepjTVN7bc9K5rv6DOVPRn
	 a3/2tRxaBIxHvie79Rr9KQOAHMS/zKCBxSoHDBQ49JCqB/ZmVhYhDiL6QUstWPL6xc
	 jlYwiKIFGPb6yMkwysdD/HizCJJq6JDa9OiVNrYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 393/480] NFSv4: include MAY_WRITE in open permission mask for O_TRUNC
Date: Thu, 16 Jul 2026 15:32:20 +0200
Message-ID: <20260716133053.301692605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -3302,6 +3302,8 @@ static int nfs_open_permission_mask(int
 			mask |= MAY_READ;
 		if ((openflags & O_ACCMODE) != O_RDONLY)
 			mask |= MAY_WRITE;
+		if (openflags & O_TRUNC)
+			mask |= MAY_WRITE;
 	}
 
 	return mask;


