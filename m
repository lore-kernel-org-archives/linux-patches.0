Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39743BE642;
	Wed, 30 Sep 2026 19:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795755; cv=none; b=o4OZaTkOw2nXGrCdTcr3mcPGpac+iT1rvl8TLqXumWztTwU7R6H79MGMiGG+BwQeuPvw+tB3OEUFrU4+QTq4sRjxXhNUhl1M2c/0suqc8Cy/kEQaTMCTBHIE2nmMTuqbcrcSYm3+oUrb5x+rqdkPMQg1ynDLrp87p45a00Bf96o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795755; c=relaxed/simple;
	bh=SOAxtD+9+EczoOgW045XFQCHRtUagCPfFtQ6eMdqoCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyALuhzaPR0ic/i2kniv26f8yUJgxPjApTgrAd+O37BWhWIAFtjGJvgLALGe0Fkt4dPHeWgYhMgC3CiTJ5bVxD0hDfGEWUf2RqSpixuBABaAR22656Io2iWQpb4WB7a0z37TZCELmKtob2QPehzzkb0pFBA7uxXd/Vu1yiFFiQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1zACXwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1zACXwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B481F000FF;
	Wed, 30 Sep 2026 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795753;
	bh=QQ4fgZid114dOy81wY5/m8LDQUsNoox/UTCYyUB3W34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1zACXwa6ZqRSIqHt5+1EOt4pZocxfHNlYujM85k/20GaSDoE1Flvn6C9rCnJ+msj
	 1zVcnaNGUlC7bjXoN19scLsvwKHZXqMEZxb3WbtNnHcrAKEko4x6hL16F26T/KfHfQ
	 rKotFBM4wY7jftHiaQTSEAwPIL3wT+XABvthPH3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0673/1193] xfs: signal inode btree xref error if get_rec returns an error
Date: Wed, 30 Sep 2026 17:22:37 +0200
Message-ID: <20260930152449.196967261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 8c71ad4d4f3e20c30b663bd292526fcbc4d3913f upstream.

LOLLM points out that xchk_finobt_xref_inobt and xchk_inobt_xref_finobt
both ignore errors being returned from the xfs_btree_get_rec function
and proceed with a (possibly stale) "true" value for has_record.  If the
*simple* btree record checks fail during cross-referencing, we can
immediately conclude that there's a cross-referncing error in the other
btree.  On those grounds, we can bubble up the returned error instead of
wasting time cross-referencing with garbage.

Cc: stable@vger.kernel.org # v6.4
Fixes: bc0f3b55467e1b ("xfs: directly cross-reference the inode btrees with each other")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/ialloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -85,6 +85,8 @@ xchk_inobt_xref_finobt(
 		goto no_record;
 
 	error = xfs_inobt_get_rec(cur, &frec, &has_record);
+	if (error)
+		return error;
 	if (!has_record)
 		return -EFSCORRUPTED;
 
@@ -188,6 +190,8 @@ xchk_finobt_xref_inobt(
 		goto no_record;
 
 	error = xfs_inobt_get_rec(cur, &irec, &has_record);
+	if (error)
+		return error;
 	if (!has_record)
 		return -EFSCORRUPTED;
 


