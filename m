Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585253;
	b=UKRomwkIYY15t27HA/A35PrENDL1fStKnz6Jb5QyNtsxLwPuymT7lLoc+Mj4HMcz0oUs
	 OvL3VdV/cgrI7kD39d+E2WtV8k34f/Npsvm3onqoksxxs/PfCG0fwuorNV0hbwZGozoaD
	 xA9PbzCvT6I3fmRGLZ2QQ8qqUQOfkqPVIyH08nz4k8Ozgh+16zowKfceXpgnm43qd9Mm4
	 tjgytjECAs7Ry7XzmLWFjhbTphFEST03zlJ5CMTxkRMpOYJFLrxzjCTO90S6/a2dgFnZ+
	 UWjfsqZxJ50D/Q6qJ9stwm5FeNnlwcm7GmpwbdFeKlIvewpb08FNzxng/2ddzVsldtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y6gmMuJmJFFVHmIasUwYI65+iwTO+CD2dYddccL/oU0=;
	b=LLQzaTJiSolkzYNQcKZLt/kI0NgHJQ4fetYdyIILJ1FTyUXCroqQ5jKmX6UODNRAHA+R
	 Rb3OuO0uk6yi1orksrhMNtFg5SwwdvJhDsJzCCXx+JDMxehvrmG05jpPXFkV3glscTPta
	 VIJV6hP6p6TPGsjzuz5nwmcYk6zj3ThD7EGwKVn8d4g8cmAHYSz3B57Rjit3re8NJyukL
	 E2kMJCUJrwlRMQPSqyth8kXhw4YytzrACRGL+153RUS483TK2j9QmXdAcli31UYPVtEi5
	 qXcgrjEvFI+On5UosQe4qbcAfXfsM/36lTjVKxhgoYmbUo52IGehd8IkoAgEXle+tWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anKuSj3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05744606A330;
	Fri, 13 Nov 2026 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anKuSj3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41531F000C7;
	Fri, 13 Nov 2026 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585252;
	bh=y6gmMuJmJFFVHmIasUwYI65+iwTO+CD2dYddccL/oU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anKuSj3SlGm8CQd5pVSJJJPiNrMi1fgSzK2E1oZ0BrxfCV2UvW4qSLUTrha8OTTkU
	 L28uSM4DJUm7DRHEbjduUtDdLivZdC8iPknoJr8aTP/yqqJgTcjdY3dIIxU0fSX4KU
	 +v0rhfHhMFb2oOJISMscDhU1bYzDrENcg/InMB88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 007/507] xfs: check for buffer overruns when examining local/remote xattr entries
Date: Fri, 13 Nov 2026 10:45:11 -0500
Message-ID: <20261113153753.626177760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 91c41f9524906a8ebd2ae68c98a07b4bd5255ddb ]

LOLLM noticed that the xattr scrub and repair code can walk off the end
of the buffer if the xattr entry record starts so close to the end of
the buffer that there's not even space for the entry structure itself.
Strengthen the bounds checking here.

Cc: stable@vger.kernel.org # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c        | 12 ++++++++++++
 fs/xfs/scrub/attr_repair.c | 16 +++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f7c00ea1af5d3..f909e2b25158a 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -306,6 +306,12 @@ xchk_xattr_local_entry(
 	char				*name_end;
 	unsigned int			namesize;
 
+	name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 			be16_to_cpu(lentry->valuelen));
 	name_end = (char *)lentry + namesize;
@@ -335,6 +341,12 @@ xchk_xattr_remote_entry(
 	char				*name_end;
 	unsigned int			namesize;
 
+	name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 	name_end = (char *)rentry + namesize;
 	if (rentry->namelen == 0) {
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7695d4cc8e7c..ad688f9f7ce94 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -285,6 +285,7 @@ xrep_xattr_salvage_local_attr(
 	struct xfs_attr_leaf_name_local	*lentry)
 {
 	struct xchk_xattr_buf		*ab = rx->sc->buf;
+	char				*name_end;
 	unsigned char			*value;
 	unsigned int			valuelen;
 	unsigned int			namesize;
@@ -293,10 +294,14 @@ xrep_xattr_salvage_local_attr(
 	 * Decode the leaf local entry format.  If something seems wrong, we
 	 * junk the attribute.
 	 */
+	name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+	if (name_end > buf_end)
+		return 0;
 	value = &lentry->nameval[lentry->namelen];
 	valuelen = be16_to_cpu(lentry->valuelen);
 	namesize = xfs_attr_leaf_entsize_local(lentry->namelen, valuelen);
-	if ((char *)lentry + namesize > buf_end)
+	name_end = (char *)lentry + namesize;
+	if (name_end > buf_end)
 		return 0;
 	if (!xrep_xattr_want_salvage(rx, ent->flags, lentry->nameval,
 			lentry->namelen, value, valuelen))
@@ -333,8 +338,8 @@ xrep_xattr_salvage_remote_attr(
 		.attr_filter		= ent->flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.namelen		= rentry->namelen,
 		.name			= rentry->name,
-		.valuelen		= be32_to_cpu(rentry->valuelen),
 	};
+	char				*name_end;
 	unsigned int			namesize;
 	int				error;
 
@@ -343,9 +348,14 @@ xrep_xattr_salvage_remote_attr(
 	 * junk the attribute.  Note that we should never find a zero-length
 	 * remote attribute value.
 	 */
+	name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+	if (name_end > buf_end)
+		return 0;
 	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
-	if ((char *)rentry + namesize > buf_end)
+	name_end = (char *)rentry + namesize;
+	if (name_end > buf_end)
 		return 0;
+	args.valuelen = be32_to_cpu(rentry->valuelen);
 	if (args.valuelen == 0 ||
 	    !xrep_xattr_want_salvage(rx, ent->flags, rentry->name,
 			rentry->namelen, NULL, args.valuelen))
-- 
2.53.0



