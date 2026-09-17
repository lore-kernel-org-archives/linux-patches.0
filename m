Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567F14F93DC;
	Thu, 17 Sep 2026 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666814; cv=none; b=SY7tB0eK9OuUUnR5QK3WLjWebyktocNuw5CB2qUKjugYikzkYIlBG5PZI3D3t0EzogcEcoq5KLwPA5edC3+GYA4z4KLSLAFkOXinNDFBt0AJLA0s9L7dKmLlzHdwXv1/aByj73e91YYnUssgSziqdSWZhHANwzJnJkxZSvHEYYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666814; c=relaxed/simple;
	bh=6sdQYFqZH6X/LgdVVzEnOF34QoxFkG9dUQg7nT+xyu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oovLzPFG26XphrN0p3/58hwqzGem3043C6aWmX9SZ78UCt7kAJhspYJz/nKJDhE2SCVx/NaFKr0oV9/hU8O7ealQKnsRoKcS90nu4uC3IlbZtPlpy3wqnjaza5qIJkPvYSvN06vkcOFGAV3eRWBzFKQlu52FPr6xrUzSn0keaMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlVhGiDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlVhGiDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEE41F000FF;
	Thu, 17 Sep 2026 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666813;
	bh=oKvnGLKrQIMl7zxyQMAEHL9wLRDBfamVw0bHFqfXAlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlVhGiDELEQhjENNA1uC8+N+XX4ptlFRMAMKnU6009glmQStD49BXE3IYssWegVVh
	 bfnliFXMPfW0gVNvUWWO8gOERxpd4OANF8BVHEOGvQFNhZTzxiSUef1rQ0ZUgqrVsS
	 HrLD3SFbLt7zisNQCs88t1q225T5YgR0BaXiQ6/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1106/1250] xfs: fix rtrmap cross-referencing elision logic
Date: Thu, 17 Sep 2026 16:15:01 +0100
Message-ID: <20260917151622.165333902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 3bdbf472a608aeb7e8e4dc70ee86738ad5256356 upstream.

LOLLM points out that xchk_bmap_xref_rmap_cow skips the cross-reference
if the data-section rmapbt cursor is not present.  However, this is
broken for realtime file data fork scanning, because they will have an
rtrmapbt cursor and not an rmapbt cursor.  Fix the behavior by removing
the cursor checks because xchk_bmap_get_rmap already accounts for that.

Cc: stable@vger.kernel.org # v6.14
Fixes: 037a44d8277adf ("xfs: cross-reference the realtime rmapbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -274,7 +274,7 @@ xchk_bmap_xref_rmap_cow(
 	unsigned long long	rmap_end;
 	uint64_t		owner = XFS_RMAP_OWN_COW;
 
-	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
+	if (xchk_skip_xref(info->sc->sm))
 		return;
 
 	/* Find the rmap record for this irec. */


