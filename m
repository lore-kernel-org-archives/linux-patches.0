Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05442BE98;
	Thu, 16 Jul 2026 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212383; cv=none; b=FVtA0DRlC9azdyuxvydOYV3USWULjGlnLmBz91UViAsY8h5b2pBi3yMPX5Dj+QYJ+RHQ60ZXybdEedYt6pBYi3Pex4GzzNr3Nvgv1a8JrQFINH7LMkwHR+ZW1tbgrLgX6zq/GweRKr+IF4PRft9atlBoDv1vDbeQ0gC5xI/vJ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212383; c=relaxed/simple;
	bh=4CNy360/D22Kjxq+8fPJpecjS/tbw/sS1wGZ3jMImjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lriGwZSmXU6a+8vWzOM9MMW4/l/7LbmKN3sWBUG7XHPuxs1g0SJ8X0RCPBrAwEJff+Q6F+URaimesNNkTNURTAYrYVBQ6CvPxGr2czqmoce2lyb5npPI4XQzYanK26C5gWpJvHr6qdWt4RQwsusnf7aT0e+1F8P2QEEVSIea/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWFaTJUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWFaTJUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8611F000E9;
	Thu, 16 Jul 2026 14:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212382;
	bh=s0kpd1AEzm4gZ4ggFpPKa6m+BLBMjKbW/jHXA6YJCQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWFaTJUbSzSnVYgZYkTw+jb5AfsABYgNBeqVwIKTyEPHLQvPMRI571C0P2ENKXf+2
	 izdIUWaic8hvi2flG+bEU7GimcKikuEelViLlHJZEAGWOha/Y25LlV849CgOMnfTen
	 wU8OnNzcEi78V7wW4gRzvVb0JsJaYoOwIHFQ1hjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.12 306/349] NFSv4: include MAY_WRITE in open permission mask for O_TRUNC
Date: Thu, 16 Jul 2026 15:34:00 +0200
Message-ID: <20260716133040.167335284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -3318,6 +3318,8 @@ static int nfs_open_permission_mask(int
 			mask |= MAY_READ;
 		if ((openflags & O_ACCMODE) != O_RDONLY)
 			mask |= MAY_WRITE;
+		if (openflags & O_TRUNC)
+			mask |= MAY_WRITE;
 	}
 
 	return mask;


