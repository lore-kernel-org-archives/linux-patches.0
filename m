Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE637C902;
	Thu, 20 Aug 2026 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238422; cv=none; b=ZfDbRJhofPl7ZNspv3pSHwzEyFs+rKVBJnNf1UK0gJJtmEjzxZg3sBTXxyTugkqrjJ2haP/n2r017RAiKgyLjr4/kRAupC5NV3W6s3iqxzhPpTCiPUB92DoxEAaeZ4yVZ7GYbax4sUFTbNoO5wutFm+zvEgwpm7v9NKtyxl+JLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238422; c=relaxed/simple;
	bh=vQU/3hXKXXznJwVE+atmEMUsT7qXLY9rO2Ckr6q4P6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqanMEzKZEfE1vIAMO4YwoOlJHyTVsICqXhOGEbqkB+ZgF/wXP60PLgbMLYROxb+ZbtxyTDKhT7J/NRchgUM8IYrvINzwqxGvMNC69oyuzukTj7UjM/W3PlneEcFfeD9ubEq+izYRlT+5SmH5aHUkfbOi1N8d9g6D8C97znc9Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceikGDvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceikGDvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB2E1F00A3A;
	Thu, 20 Aug 2026 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238421;
	bh=4vBe4/Vbeub93JHCPI4qpDQhlN9Opb3ZfnfJ8KGhaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceikGDvhAkbeYCsxtF8hmNVkWb4RHLGJ0SmHo7vk7FIIjUkgvpnuB9AaXPe34AvIP
	 4BzxYUhgZhbg+2cL5m2ImdxOkhxkaXTkwj9gfYFPnsnzCBlANPp//LvLu6yhha6SwB
	 pXObxLGMknNpZ9fOnzgGqfSXfBJuDbPv0MZN7na8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 140/228] xfs: dont zap the attr fork on repair when there are queued pptr updates
Date: Thu, 20 Aug 2026 16:54:42 +0200
Message-ID: <20260820145248.859622879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 5ee37132ea81abd36213b31a72140660c2aac54b upstream.

LOLLM noticed that xrep_xattr_rebuild_tree doesn't check for queued
parent pointer updates when it decides that it's going to zap the attr
fork.  This is obviously incorrect, so fix that.  We hold the IOLOCK and
the ILOCK of sc->ip at that point in time, so we can't race with any
/new/ operations.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1427,7 +1427,8 @@ xrep_xattr_rebuild_tree(
 	 * If we didn't find any attributes to salvage, repair the file by
 	 * zapping its attr fork.
 	 */
-	if (rx->attrs_found == 0) {
+	if (rx->attrs_found == 0 &&
+	    (!xfs_has_parent(sc->mp) || xfarray_length(rx->pptr_recs) == 0)) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		error = xrep_xattr_reset_fork(sc);
 		if (error)


