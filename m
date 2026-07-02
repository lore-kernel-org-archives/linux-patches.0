Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB7322D7B9;
	Thu,  2 Jul 2026 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011444; cv=none; b=rjYWgzaUDyLpmKLNmrbRMA/jg/GDBDWcK8Qucxk6gZA+8fk73WmobZoE9mM4q9zOwzT0SKooh8jz0jmpmwVxibqmWKkzULhDoWZFZKT9YaXJDSkzLmE7d+MJVmYFAUnA9g+dvCyYSUVXi4762O/Bp+05Vaq9RiabyrR1bcFZeXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011444; c=relaxed/simple;
	bh=f1YJX/WDL3juz3AD0SrSxaUlsAMuMqnwlvWZDFc2Oqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxNVV8QLhpUD2fCgTQf/HwWD7m3w1dBF5MwYXqv1paZL+SukA3vQXCxB7BMbO8MAvGA+Soi3BqMokOlAJN1VOk0duXqemoVTwQxJprVANc+qmdMHBEvpxYIXDP/N1AR1BluvI2LnL5/8RHHGnVjOwkAK1lLVl24AReZf2j76J9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWdyj4mA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWdyj4mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366F81F000E9;
	Thu,  2 Jul 2026 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011443;
	bh=/TTjVrqMtrCRThYA11gLcgL78Ldbra6T5Ubd499xyP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWdyj4mAM30JyNmex4P9WH8ery5Q0qVqglxDQFwbcb8oEBmtLUlRHMgzlsPLlbQI8
	 Mc5s9b9PbhVdXyZeSLiJukHX18fixPcPbevZhL6abf6aW/a1mPRU2WuBPYXJraxP8c
	 tGovG23R5DS5Wzoik9Ue2ZrPvyceZc3L/y/ueZow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 099/108] nfsd: avoid leaking pre-allocated openowner on unconfirmed retry race
Date: Thu,  2 Jul 2026 18:21:36 +0200
Message-ID: <20260702155114.164890800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 57aee7a35bb12753057c5b65d72d1f46c0e95b07 upstream.

When find_or_alloc_open_stateowner() encounters an unconfirmed owner, it
calls release_openowner() and sets oo = NULL. Control then falls through
past the `if (oo)` guard -- which would have freed any pre-allocated
`new` -- and unconditionally executes `new = alloc_stateowner(...)`. If
`new` was already allocated on a prior iteration, the pointer is
silently overwritten and the previous allocation (slab object + owner
name buffer) is leaked.

This requires a race: two NFSv4.0 OPEN threads with the same owner
string, where a concurrent thread inserts a new unconfirmed owner into
the hash between retry iterations. The window is narrow but repeatable
under adversarial conditions.

Fix by adding `goto retry` after `oo = NULL` so the already-allocated
`new` is reused on the next iteration rather than overwritten.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 23df17788c62 ("nfsd: perform all find_openstateowner_str calls in the one place.")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5176,6 +5176,7 @@ retry:
 		/* Replace unconfirmed owners without checking for replay. */
 		release_openowner(oo);
 		oo = NULL;
+		goto retry;
 	}
 	if (oo) {
 		if (new)


