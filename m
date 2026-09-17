Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230073A453A;
	Thu, 17 Sep 2026 17:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666674; cv=none; b=mT9iwChDODZBdOWR66xJsJvvB90MhA/UtZuy5n0pvlzmUtwoWV+N3w9wPYS0frjtJyB6PJTKf+TLpCZXTMpj+zdAEMzHpam31cVHprR7Du4PzvN1IgCALnZnaDAtlFcLhYrCNxXg0X0lRO1WrMwQDAO1++KZYHfcJGol0z6RC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666674; c=relaxed/simple;
	bh=MVR3lOwZUTcUI+DPVWeZO6zmkByfGe31JoS0jUI5upo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyP+X3CTGp6nR/5cN4z/FiSOv4G95asmuhgA3IixDchkX13T/4ez6CrdAXWLGgMOsi/vKKowCahhtm/QOWoDAlrU1bXyzThG+f7pRdjsBplVb7y/DGJbRmxOEg/GHtK4nQGbREKZh6TFav0NGjzTbnuCpCE99lvn1oHq7s4GPHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOFBe2Ki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOFBe2Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7717E1F000FF;
	Thu, 17 Sep 2026 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666672;
	bh=M+c3jdzGOQc1XlBSAOM2Wb3f33kf6Mh+MhLcb5hSnSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOFBe2Ki+vw+U30y1rYxmUN9facrAKwiOXaZQfZoa23OrxrqrWILO4ynHMfnOE0Q6
	 B77chCRKjYkN9OAH48b7LFPCsY2kOi6eobYKiiiPc4O+XOFE5B9ml7pLG6GwUagoQ4
	 h1DCn9bddcWKEjHNSaUU3KgN5oNdHsXU65S2OdhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1116/1250] xfs: dont spin forever on zero-length dirents when salvaging them
Date: Thu, 17 Sep 2026 16:15:11 +0100
Message-ID: <20260917151622.475755159@linuxfoundation.org>
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

commit 9f84792b40d0c96833341602144574bf0bd14a6a upstream.

LOLLM noticed that xrep_dir_recover_data can spin forever if it
encounters an unused dirent that claims to have length zero.  Fix that,
and prevent the same thing from happening with a zero-length entry.

Cc: stable@vger.kernel.org # v6.10
Fixes: b1991ee3e7cf85 ("xfs: online repair of directories")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -484,18 +484,24 @@ xrep_dir_recover_data(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int			advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (!dup->length)
+				break;
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/* Don't walk off the end of the block. */
-		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (!advance)
+			break;
+		offset += advance;
 		if (offset > end)
 			break;
 


