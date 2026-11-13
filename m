Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585980;
	b=iCWsmUkopE4h9Y4HM2olmXD1d0FNUT25enA0AvYfaqPWv6HVd8lsyeu3KM9Ux1LX/AN2
	 0w/NhNqAOd0y3jGhC81ogLycNG6+mS1vQ6ZV8IqsLrPWC/XXbszchUPhZxPqszKtJzhzg
	 2Rn/1qAyr6OTkUhVO8JBMQ7BYC60ed0znjToFrn46S8Tq2NsZ7PRtvEHTioSlDLNsQTBn
	 6JhFbYM4AFIw06LNbLr9AMC26u1wNPTmuQyeHXNE8hZOE3VS2Usxj8xB1171gEVrQRuud
	 Dh/2Ej9h7ZRa0TU1xSpks11TmprMO/USOlz89f9XebTDGWrzve/hY+mkQB9wOm9baCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6sL1KcqORrS6QNV5BFn9JE85Gvq/B1TcBFaDTXvZ5tw=;
	b=XfcrxqFQ6MqhqenHkbT8a+fmx3CmgADiexO7tZ+Q74s1LznOd1K1oNK0daSLuDqdG7fG
	 t8VnYtQXeLKClf1UH74M4nf97FCAI+m8yTBTEOf+o7rXRPqozdHwix330oOwd8CQnBfZT
	 O149PTET7Au8jq7uN+UDDAAKok+bjR9Fq6uQ7na7AOVBzhTpXfBqnDDXRAjjyrwL54KDm
	 qdU+ZRBNFTdmS/nBAUzsEHF4MNsM4DngIpsoD5Z+mP2Gf9jCOdqmW8sX0CZRCkSTUA4BY
	 fYMlJlE6CGYBUCJYWq/xmhUyCe5dPSeUpIcu0TnbSmz5arZ4I2EYDqe/PvNwRHIvKBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THniErR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DDA607232B;
	Fri, 13 Nov 2026 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THniErR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846421F000C5;
	Fri, 13 Nov 2026 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585980;
	bh=6sL1KcqORrS6QNV5BFn9JE85Gvq/B1TcBFaDTXvZ5tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THniErR9gDN72hBOK8Yf5kl+Bo+6NXyNcHG657TdFmSs6KUvBIEoMO9W7mgHS0Q22
	 oeyXjvCvrAKKEYRpExsEcYThUAfv1UtlcYJf91fhbiWZlnIo6i1bvPU1KDkwVqAXWO
	 1Pqw6YP8anudIL/OH0Vfuw1pSqVqec8I3TkCoq/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/686] xfs: check for buffer overruns when examining local/remote xattr entries
Date: Fri, 13 Nov 2026 10:42:40 -0500
Message-ID: <20261113153821.900906496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 84507c80cf945..68d9666ab201a 100644
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
index ab5bd7a4d4abb..2c573897c0c6a 100644
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



