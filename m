Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2547FAEA;
	Thu, 20 Aug 2026 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246954; cv=none; b=tMlzR6wPLylm3G/NRNEN3Ypg7akyc3+iVX7ugdljtoZ6HFtTOsy/sviM5IY++S2d2+/rCeu/dgWFGyMcQMNv+ge1R4knjDtqcxq+6OQzC76rA5+7dvMMod+AGakx/N0Fw/Wb+Bkpv1r+VVGx0NhKUgasT6be/qaIRIBz2jimGEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246954; c=relaxed/simple;
	bh=+EABBlaO/25gjzc0A9WhiaCCqSk8tqV8bD4wPMhNUNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYjUTyZwD1xYtmqv6DxysDaQVuVkAgXVfG3n0DDmt4k02T2sgjSGt19m90rCnmZsMGQB5A98IFMvAzdZ3IAf0lV9vonGOLuKGeMXUka2dUpDoikEoHS0QtY5jpUJUhoLRsbxBUukwCWSzL4qooDhuWhiAgRpfqN0iKpoPvA2kA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOVIAp2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOVIAp2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583681F000E9;
	Thu, 20 Aug 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246952;
	bh=TJaygpVGQcViTvwZI1ReHrKTS/CS+Wzmp3zA2jclYa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOVIAp2WZCsFZo7nkK6FDzgYwW4yh5V+a/tVhBc5C38pX9XBzwsfYi0GjLwZ+s5Fr
	 9ihVbPSS5FwPGeOYpK31mHTJrUnKssW9jZJJ2+Yk1UOTemUU3O4ZFv9OakIRE1fijh
	 cCu+rL8QbyK9G9TNAPs1ma9ZoscP7maUe6nAvdTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 096/220] xfs: set the prev pointer when reinserting an inode on the unlinked list
Date: Thu, 20 Aug 2026 16:54:46 +0200
Message-ID: <20260820145226.365805291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1438,6 +1438,10 @@ xrep_iunlink_add_to_bucket(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_store_prev(ragi, agino, NULLAGINO);
+	if (error)
+		return error;
+
 	/* Remember the head inode's previous pointer. */
 	if (current_head != NULLAGINO) {
 		error = xrep_iunlink_store_prev(ragi, current_head, agino);


