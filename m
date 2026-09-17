Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0CD4F3928;
	Thu, 17 Sep 2026 15:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660622; cv=none; b=oOzu9kKGQhPmXJcjOv+Eg2CLTEeWF7UvdlVzYnBT52wlya2Vnfd+EeXVfIEQ1xy7dsi7BnqIlgBaWA+YdHZoUwhgNR0IaC6/E8bSfm8Byas7AHdW/N5TlYDzxL7qnosvebnHTKXt25WeI1L840OuAZATFPE4xG2qBl3GaAeuRio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660622; c=relaxed/simple;
	bh=r2vxysVNa3c86NR64pGihQ7VPCCb+mRytwgz3BA1SYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqol4Z4rxoIpQIuUMpdSFdlXbvqRRXO9zsNxwiv6sW3xQmyghsD6qtp+h33rThpbjHCHWAKG34g4NHWoGeSYHsUF6tKEwzlXloolcQdObnZ0Nj9n1ZFesoIRwCD0xbjAQ+JloSDxOr/Nl28j7HvFdH3jjQUgGvYJJBSf7Qq1PZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX+Xz/Zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX+Xz/Zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466631F00898;
	Thu, 17 Sep 2026 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660620;
	bh=L6SKZlpeIw5d2Gtkg0D95zCWRbRow5ruQplPH4aVQ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kX+Xz/ZgNCJ2ebwi65tEvLDue3mW8ZdFHw1K8q5E8X+B9fJLJ+3MsGzNXvHVA/erE
	 kjGCmH5Q+nj54+0SpB8c4fX6LX1phJFFDtuee3iDb+g1tqhXZkOt+OCp0iSBggR0y+
	 qGtNE/C66IEwxJMePLS2gYbSvunBKI+O1cVtWWqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 652/733] xfs: make the rtsummary repair fix the file size too
Date: Thu, 17 Sep 2026 16:16:00 +0100
Message-ID: <20260917151408.879821244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 6b760b3232b3efc8bcc7c165e76300bc1c9140c5 upstream.

LOLLM noticed that the rtsummary repair code will create a new rtsummary
with the correct file size, but it won't force the new file size to be
set on the existing rtsummary file, leaving the rtsummary corrupt.  Fix
this by setting up the tempfile mapping-exchange to run to the end of
both files, which is the magic offset needed to reset the file size.

Cc: stable@vger.kernel.org # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtsummary_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -164,9 +164,10 @@ xrep_rtsummary(
 	/*
 	 * Now exchange the contents.  Nothing in repair uses the temporary
 	 * buffer, so we can reuse it for the tempfile exchrange information.
+	 * Use XFS_MAX_FILEOFF here so that we correct the rtsummary file size.
 	 */
 	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, 0,
-			rts->rsumblocks, &rts->tempexch);
+			XFS_MAX_FILEOFF, &rts->tempexch);
 	if (error)
 		return error;
 


