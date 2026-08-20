Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED60037C925;
	Thu, 20 Aug 2026 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238406; cv=none; b=liprIdtKPRkotIBSxQH/ZhWGc2GtC8VfKJTJHKzcTElTCnC1+rNoqSu4//JlIsA0xoTVFuUeF6XrOMeF76zVowE9oyzDRkZ0vUzJR8Vbh3xOZcHk+SMat7OY8rlGKTjwoe+8ME05/a4Bu2XtIWFAfqKnO4czAyNVITPF/bB8Wwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238406; c=relaxed/simple;
	bh=NBGIGHulS5ggtvKrWKRVzex1rXFvAAtqXT10yKzpjVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGqQXVy711CmNvSFL9eHdrWZ7i1pmShCV2EajajpJiY2eXpAxVrAbNkBKLatbHfTuhteeDQkpjdxepTp7N2JZJM/64btLtfGL7pDZmNxi9rEqpSjFnvHGbIATBTq58JQa2fH0J/BBkjrl6qk7cGRDCl/CVVbwBmM8o/ItRwF1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGKiADeg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGKiADeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF951F000E9;
	Thu, 20 Aug 2026 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238404;
	bh=yISwS9Cuorla6E4FZq0KGC0by7wvrPfHuSO4BDYiEz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGKiADegn+dZbBTKZDGZV7RxOQLhn1VgrmW+xWl8gl5NJ/vJEmDD5cK5ugO3soenR
	 psM/HOLl+MMlf79tJMh6NJk48sehmMa4bb8DhCWU2GaSWHDXi/p+P4c8VKxVKzIgTt
	 FqtFJZP1bauf3cYFpy8lEJ6eIMvFanj8Z1j0Br1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 135/228] xfs: set the prev pointer when reinserting an inode on the unlinked list
Date: Thu, 20 Aug 2026 16:54:37 +0200
Message-ID: <20260820145248.711277759@linuxfoundation.org>
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

commit af146cb7ff8ff5c54162f35c238f3ff1d5ad110f upstream.

If we find a rogue free inode and decide to reinsert it into the
unlinked list, we need to set the prev pointer to NULLAGINO so that the
incore list gets updated.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1434,6 +1434,10 @@ xrep_iunlink_add_to_bucket(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_store_prev(ragi, agino, NULLAGINO);
+	if (error)
+		return error;
+
 	/* Remember the head inode's previous pointer. */
 	if (current_head != NULLAGINO) {
 		error = xrep_iunlink_store_prev(ragi, current_head, agino);


