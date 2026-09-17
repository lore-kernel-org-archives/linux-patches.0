Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210B51DAE2;
	Thu, 17 Sep 2026 17:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666620; cv=none; b=IDXe/I/W/lzRdcbiDu5shMKi3ZrkRgI1mwbzCCffeCgKgE4ZHIqr6LBNc/CIvvusyaSUeIOMGGS6oHjOWetqbH+1SuhPhN/hBfTIhR6hCZ/gexkShimYUs5HiuQQy1zkQHwXEmnjiyFkLoBvouMc/+Ahx53Z4OGBRPssFu5nQHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666620; c=relaxed/simple;
	bh=hh7/ZSdxgTXTOgpCmIn5pTlA2SrI3/JJmmRG/YV8Yf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiJ4zDYrHb5kqyiNkTCjHO5WDMNkPeHkuD1BjEFuWJunJjxHjLxpgCA2+UeqqdYUttNH7Hl8LPF5hrVkl2n6YBHFVXLutLD5XX1De0YCga4FqnG33jKI6/hNXQAtX0nuqxg5nH4O7YQhXD5B/N1fnjXDMOuAZQFGHDb0wuEBdV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GKPyBK0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GKPyBK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84181F000FF;
	Thu, 17 Sep 2026 17:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666619;
	bh=xFJ9NZ+zR9aBNBOHIcPh6PlsVEAroNWDQE2BxE+aULk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GKPyBK0cF6yQEqhY9NMUsyXS2pVOFMZjGX7t7d6UK37OMgOXQ9XM53VjygszJtR1
	 N0UCXWyHt2UaLJeUDxSWmeFbqmM/+hosE0jMpBPmijvKGRfCIgoqSBQNcV2ttBszMY
	 9AeJyghBNQMwqygpZPjRlxBLhgVh9bhKp6wOpbBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anuj Gupta <anuj20.g@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1097/1250] xfs: release alleged child inode on metapath unlink error
Date: Thu, 17 Sep 2026 16:14:52 +0100
Message-ID: <20260917151621.909853850@linuxfoundation.org>
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

From: Anuj Gupta <anuj20.g@samsung.com>

commit 48d2b8351bae6d40b44f544fe5540868a55872b2 upstream.

If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
succeeds, release the inode reference before returning.

Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")
Cc: stable@vger.kernel.org # v6.13
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -556,6 +556,8 @@ xrep_metapath_try_unlink(
 	error = xchk_metapath_ilock_parent_and_child(mpath, ip);
 	if (error) {
 		xchk_trans_cancel(sc);
+		if (ip)
+			xchk_irele(sc, ip);
 		return error;
 	}
 	xfs_trans_ijoin(sc->tp, mpath->dp, 0);


