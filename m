Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5CF2F9DA1;
	Fri,  4 Sep 2026 06:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502209; cv=none; b=RlW/Ld53hEBJpI+z50bHjJVbSiq0dzIeE11tRWg3Xq+rfl853rtmGHciZV4lSHbXgL984xh3j/fBhmEoTQb+CK9Nc05HmFBdE0RjOy+oZWhJFV1GWxtWmdhDR/vdKlk+CbCboSOMBgu9omCtu56i8xNJ3kDz9lzQoO/yOfaJ0HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502209; c=relaxed/simple;
	bh=myUb1PGLHTtj7BZmQ3FboJc4LAE4For8llFWUfeH/ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jixgeYOPBJy1ixmkHtWLdcXsGOR2xpixVZwOqhKDkDWnAqQQ3HgcEDiv4TkVblGbIpcmsPbLWGIBQ3+0PnDDcnO2wKZ5bh1+nNod55rvU4v6HgxYGuETyNanVwYgkSGOa8Dv/IqSoNQOfVIAH0IBNuIXm5+TdzrXJpVxgVGLZsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMpwbfFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMpwbfFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A201F00A3D;
	Fri,  4 Sep 2026 06:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502208;
	bh=SlEqudfNoV2v6fynp6dTamTf8Y7Nhew/CynLPdttrkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMpwbfFDyjBi9TksbVD76apxSyX1WuGGJCOh+4uBAUUH9DOY+GyR3RXEnsBdCT2kP
	 fjO6t716/EHiw0dm1f0kTd6miQBGH+gjpU0lDm3KvjH11qsydNJwrbYdnPa4imaHpL
	 m7NVocvWeFVdNzWSbEl16cgwdkYACmb/O4Ou7f6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 090/403] nfsd: drop the stateid, not the stateowner, on seqid_op replay retry
Date: Fri,  4 Sep 2026 06:58:13 +0200
Message-ID: <20260904045736.880976577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 5e4627d3513e60accfce9d5f4c7fa95251ef93d6 upstream.

In nfs4_preprocess_seqid_op() the stateid is obtained from
nfsd4_lookup_stateid(), which holds a reference on the nfs4_stid
(sc_count) but takes no reference on the stateowner. openlockstateid()
merely casts that stid and likewise takes no reference.

When nfsd4_cstate_assign_replay() returns -EAGAIN (the replay owner is
being torn down, RP_UNHASHED) it has not taken a stateowner reference on
that path. The error handling nevertheless called
nfs4_put_stateowner(stp->st_stateowner), dropping an so_count reference
the function never acquired -- risking a stateowner refcount underflow and
use-after-free -- while leaking the sc_count reference held on the stid.
The leaked stid reference can also stall a concurrent
nfsd4_close_open_stateid() waiting for sc_count to drop.

Drop the reference actually held -- the stid -- before retrying. The
stateowner stays alive through the reference held by the stid. This mirrors
the open path in nfsd4_process_open1(), where the put balances a reference
that path explicitly holds on the stateowner.

Fixes: eec762080008 ("nfsd: replace rp_mutex to avoid deadlock in move_to_close_lru()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-21-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7405,7 +7405,7 @@ retry:
 		return status;
 	stp = openlockstateid(s);
 	if (nfsd4_cstate_assign_replay(cstate, stp->st_stateowner) == -EAGAIN) {
-		nfs4_put_stateowner(stp->st_stateowner);
+		nfs4_put_stid(&stp->st_stid);
 		goto retry;
 	}
 


