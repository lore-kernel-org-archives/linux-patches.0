Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FA14B7A29;
	Thu, 17 Sep 2026 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666624; cv=none; b=StcR5alhRgvZNe2r7fDtsV0IIFuO40RZIiEoxsRqNA879ZXJ+WrgEtqrtZ4U/mEYub0Ttp1V3iv/ovH2qtvxpOBkJmEwF8kNFpsqUYH3U+f/nhjvSqPq1/KOoHfOouWC9WRb1gXedB4FJxps5x4lVHS6qPNv/a/LDGUYCIvnme4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666624; c=relaxed/simple;
	bh=2i+k6iXY5ndnDaECCjHjlJheWLB+Mg9SL4xjauVpK+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i48GIj11nPmdgXPYY8I2tr3RJgwPZ3n4mSdv8fClMYBbBd9Vt17vwPhaZTUde2TSOK8ZIDFgR6AcWGsrxM9fzowVC3uKJLlUq0HbnEVN8wV8NwE8Wg7VNk/Afev2rZc5xYJOMQO1ptSWdb9ffa5TA0KivAQX01ZqlGwhjOUWqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgeAUsZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgeAUsZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B851F000FF;
	Thu, 17 Sep 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666622;
	bh=ZJzo8k5NmSQ/p6cON6NEVpSIWX4YQlwIqxZGlY8pBzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgeAUsZtb2NWjz3+/byW61MsWhYxtW0Lja59jOvpzA/ST58w14fnbHa/pla8WNXPF
	 ZQivxsaxWQVQybqJu7Fp0yYZhhd/2IA5DmxPNxUvB1GKwqwhJB7togzVVIK+thRJW0
	 ABaLOCNOQL4XIIfEL1mLt3pikBX2E23f/s6GfURc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1098/1250] xfs: preserve owner on in-memory btree creation
Date: Thu, 17 Sep 2026 16:14:53 +0100
Message-ID: <20260917151621.937770879@linuxfoundation.org>
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

commit 5287e56cba3be4a64bff9f73bce5964fda2590dc upstream.

LOLLM points out a minor bug where a higher level function creating an
in-memory btree is required to pass in an owner number, but the creation
function erases that.  In-memory btrees are ephemeral so this really
doesn't matter except for debugging.  But let's fix this papercut.

Cc: stable@vger.kernel.org # v6.9
Fixes: a095686a238352 ("xfs: support in-memory btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -117,6 +117,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
+	unsigned long long		owner = xfbt->owner;
 	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
 	unsigned int			keyptr_len;
 	int				error;
@@ -133,6 +134,7 @@ xfbtree_init(
 
 	memset(xfbt, 0, sizeof(*xfbt));
 	xfbt->target = btp;
+	xfbt->owner = owner;
 
 	/* Set up min/maxrecs for this btree. */
 	keyptr_len = ops->key_len + sizeof(__be64);


