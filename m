Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE05B412BE7;
	Fri,  4 Sep 2026 05:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498793; cv=none; b=F6RhjQghrXWW4DUepA7PaiuLbDe3tNmjSA2Q5DlafCNAWjFDfm7HRtMjffoXtaPzmzp3a3+tju0nxg9u1IRdanLTJpQ1mHaMG/ZxHp/O5r8wnq6bXBY8/K8w8FW+IEysIMDGdZSXbIZGyLXg4yqm2ZSzO/iJbtZ+uHsIwvwmfNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498793; c=relaxed/simple;
	bh=a2axMRWXUdGpa/ylwcjFMxCeD/GDROcbUkyXNz/YdZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6QOjN/eFrN5i+kQicCLacDb3U9x/M8hjxGs+yLbFd+Cr4N1oWARu9smPVmSSZzURmGqvBSIkcYgDSnISTRTc+tfXY1pl4KZdTDeNCb+iSrHGYkgAnfN01SVMgtuyyI7ArwRxsW6LG34JwE6xAH2lUbGiaehmM/C+DMXwI+EWyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fH/nE4iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fH/nE4iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330E91F00A3D;
	Fri,  4 Sep 2026 05:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498792;
	bh=2kGB25baV5oC4xQSDMBS3hnT9jJ7eh2DVa3ZVVM1UFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH/nE4iWIqP6hBO561t7+G0XiJ9f7hSsWu8q0tf0EQkZBpmdvWUN7G3i1Gehkb64i
	 007FcHa1BFuCt7ZgDL8P64srz1nIGtVnCVMcYmEODu61H3Zw0xdJbgYRVKtSxOvpth
	 5Wa3XzZF8WUJXBsKqoTQLul2QIRYWHPv7P41K2nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 189/713] nfsd: fix reply size estimate for GET_DIR_DELEGATION
Date: Fri,  4 Sep 2026 06:52:37 +0200
Message-ID: <20260904045808.049715001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 46f929b907b3bc488593c006f0c97e35baba9ea4 upstream.

nfsd4_get_dir_delegation_rsize() returns its estimate in XDR words, but
the COMPOUND reply-size machinery works in bytes: every other op's
_rsize helper multiplies its word count by sizeof(__be32). Since
GET_DIR_DELEGATION is OP_MODIFIES_SOMETHING, this estimate is consulted
before the op executes to ensure the reply will fit. The ~4x too-small
estimate lets a compound near the session/reply limit pass the check,
grant a directory delegation, and then fail to encode the reply with
NFS4ERR_RESOURCE/REP_TOO_BIG, leaving the client without the returned
stateid.

Multiply the estimate by sizeof(__be32) like the other _rsize helpers.

Fixes: 33a1e6ea73e5 ("nfsd: trivial GET_DIR_DELEGATION support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260616-dir-deleg-v7-17-6cbc7eac0ade@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -3540,7 +3540,7 @@ static u32 nfsd4_get_dir_delegation_rsiz
 		op_encode_stateid_maxsz +
 		2 /* gddr_notification */ +
 		2 /* gddr_child_attributes */ +
-		2 /* gddr_dir_attributes */);
+		2 /* gddr_dir_attributes */) * sizeof(__be32);
 }
 
 #ifdef CONFIG_NFSD_PNFS


