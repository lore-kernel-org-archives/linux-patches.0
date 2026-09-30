Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38091521224;
	Wed, 30 Sep 2026 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793666; cv=none; b=cPOpT5+yiDEtvf3cf8HZjouRJgaprgGgrqgZsV8M8StpVryUbzL5ALg1XDpAazhswXAgNGp6e46n3JbsyVaUvMHOqube+54KKEe3c8EeIrsaukN/xXBmH+OEHp6tUcTD0IuXaqEYTWNABku/UFDEVIxBY60ZbP5XqnW04mQK5Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793666; c=relaxed/simple;
	bh=k+/DlSud6dfLZv/uTqURL8CTS3m8k7iqwLIM+8j/xAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMPp9XUH1SLdRohjGzikpAE0dYtK8L4IsDoG0HNLlIceNSkcktf6aq4/kuZSJbZZ+XC71nBKhXUIVVFyRkW8pcwj7MC+XRv+n7iKH4seNn/ZjAb02Iupr1z9W0qDY8ybxVVGFnV2Pod7XVoRnNxA1ox+5NlKGzgoVxM4k0vDGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6F4W7in; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6F4W7in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723301F000FF;
	Wed, 30 Sep 2026 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793665;
	bh=cbeO+HVO3/9/O/qwOfQneJcHlpR6afsRAfsg+hj/ccU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6F4W7in89tO0ZOX/DnT8Sx7TOVeHG5dmtR4tLMihfRJb8A2XyDdS/X15rPt1DKhr
	 iV0/LRX7f9i5AUEkTtAdArlxFupUW1oYxr9FUqanxDQtFpnSAXnnsKL+e0IECo7IkU
	 c5JAUk9bT6tAb7aIDfQU+N5+By5YcqWmRq/UZds8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 335/395] xfs: release orphanage dir inode if chown fails
Date: Wed, 30 Sep 2026 17:29:57 +0200
Message-ID: <20260930152347.931194224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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


