Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFEA51476F;
	Wed, 30 Sep 2026 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789770; cv=none; b=RpoqS9EzZNrsXc5W4VsmSvqDrmYM8KkSLMIWDXWBobXGQAW0u9MBb6UM+fa9Wv+Wez8Mx9kHWKhwAJtyyBFGFocXx+deY8OfZFfj22EwFMQYq+8YVcJgFv2SQjEYSb+eY8SDMqWbnqRxg7kTbrQP4RSCLvI1fPI2tUAwr6Mjtu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789770; c=relaxed/simple;
	bh=GEpboQ4i4phtdL4/eq4n91FdDtHE6rVw4ddDao/r+vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpO2LxwIffwtz5Pxb3XiE0eIW1/eaJH97Vn+DURh7pj0EyX3Wt8+BlvEtASQQpOrFKL41zX0gbNLiBLaPtNvbU/K+eVENl6Pkj19HUSqnJXCXYTIMPrXZ5b7hcVyBoLrXUNx7tkpUlJ2LIj8eEc+F3JbvUq8ippa8Ak40Xowk2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppxecC0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppxecC0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FFE1F000FF;
	Wed, 30 Sep 2026 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789769;
	bh=H6gnGd6LwzW7pVtqC9lUIITPT09CoW2gNT7M2HHp4uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppxecC0ySnC28u7DRyXZ1wcgP1b5bSxanz+e9HTihnH6DIVVvq490tH3HZlKyg82D
	 tqHbEtKQ0E6Y1iXKDOxjcFabhnkXbQERdQ9NI+uDeMkjmpPqslju6r3eabGyhes+Tx
	 rP5tqStAoKbQ9OuZw4qFDaDp8Fzu9cl3xT0+PAHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 549/877] xfs: release orphanage dir inode if chown fails
Date: Wed, 30 Sep 2026 17:24:20 +0200
Message-ID: <20260930152426.486373584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

commit 1c32cdc986467eaffeedb6c5334852809555b82d upstream.

LOLLM points out that we leak the igrab'd reference to the orphanage
directory inode if chowning it fails.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 1e58a8ccf2597c ("xfs: move orphan files to the orphanage")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/orphanage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -193,12 +193,16 @@ xrep_orphanage_create(
 	/* Make sure the orphanage is owned by root. */
 	error = xrep_chown_orphanage(sc, XFS_I(orphanage_inode));
 	if (error)
-		goto out_dput_orphanage;
+		goto out_rele_orphanage;
 
 	/* Stash the reference for later and bail out. */
 	sc->orphanage = XFS_I(orphanage_inode);
 	sc->orphanage_ilock_flags = 0;
+	orphanage_inode = NULL;
 
+out_rele_orphanage:
+	if (orphanage_inode)
+		xchk_irele(sc, XFS_I(orphanage_inode));
 out_dput_orphanage:
 	dput(orphanage_dentry);
 out_unlock_root:


