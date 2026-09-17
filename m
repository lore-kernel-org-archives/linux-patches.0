Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5456E51CF64;
	Thu, 17 Sep 2026 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666608; cv=none; b=KTxa+9p/mSkcXxpbJPajZp422DeqMMqCu/rkmd+CeBpVwFWRqdiIFqKSS48tCdqfWqPKtARc2qBuOPdeCNCxlMp/JQGuP167rTax3uGMK03liMg7omD2woyvOoZx5cKA110dnty6rkRzOne+CbZzPo7WSDjTm7eM7YsZPZXIpms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666608; c=relaxed/simple;
	bh=DeOTFYlYMsSOHUUubNNTrdPBx7lsMi2ltMgM3tVBYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRaHTgSCsTvAsLGQc9+aIy2CMErAbKzHgCbBiafcAj9s19VxLI6M7sXVam4vNqkOpZ9+4hflWi/dPoVPwL+Ou1oIn7wLDdWQ8bBHFzEPy47Obrw3+VcpHglynmIsyareGs6S+lxTqu2a4Q0gl1yDdjUrWcMELol9vjveBiOvU90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7dt9kCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7dt9kCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC61F000FF;
	Thu, 17 Sep 2026 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666607;
	bh=utZgP+o6hy4i2+5fSxBiIPGVcyKZpzUuvz/tSPKfWjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7dt9kCENm4ZhB96eJsAjxLt5aSRvcKIClXFak2kSqMSmIciD8WEs0GvZCmBR0toH
	 gzI8W/SbDdqhx1D/C/xQsc9gUwSpGOffNznEzB/2oXo7bKduMB96BkWG2z2R1aDi7I
	 1Wq6/EqR3/mf667m4+ZoMmGPmx7eJ06wkZv+oUY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1093/1250] xfs: signal inode btree xref error if get_rec returns an error
Date: Thu, 17 Sep 2026 16:14:48 +0100
Message-ID: <20260917151621.793467398@linuxfoundation.org>
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
 


