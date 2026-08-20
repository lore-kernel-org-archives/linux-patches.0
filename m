Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F537E2ED;
	Thu, 20 Aug 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238397; cv=none; b=jhsU2qsejP6qnELk840qqtGiPQJZNyLc+5bCmmuJxSAlYNSpbpncRrNLli4nAMASPx5Otdg+0w+l4cc0rwm0xyJ0+gdVzy0ydKxk+QnGix0aG/EDcv4q6MvNuxZUqTz+nzUMoTjpzfOXb8NXOWOBwiB0MHI67lcI47ycbBXEkJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238397; c=relaxed/simple;
	bh=MpPsjhlGxSiTxxnnTm7l4C735QWrg+bmGOStszWXVXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFv+a4ITEVmZlFC3BUcJ2F84oTk7RADr2unZVAiXI5+Rixpoxx7XdMlbjwG/Y50JdJw3VSeb4xYWhDM/GyKneUp9Xvw8XeM3WufrxOrHq4oSKboFbmEEU4KYdKRczZAsihkyKoDRvr5EinqVW1z+6tWdRqSvxF1XVkDOAdYOEig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3Gjp8EQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3Gjp8EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB981F000E9;
	Thu, 20 Aug 2026 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238396;
	bh=SAuPZqer/sNiXWndo/AT+NjNn3NUhbQsWZwbIeTfCd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3Gjp8EQ1W7TDKgXBI8q2nAcJ2t8oi7klDsklhFXJDqEGUoxsu8hjsey2ArJDX/e2
	 WLxHgI8lIs4pLvEv73Jtr9eXMUwh8so7qDafQ6GyKVYqGB6p2RVML0phSF4yDrDLLt
	 CLdaF1pucPcL9Lrk6owxoYnbDHMzo/JzVah4l7+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 132/228] xfs: zero i_nlink before repair puts inode on unlinked list
Date: Thu, 20 Aug 2026 16:54:34 +0200
Message-ID: <20260820145248.621806115@linuxfoundation.org>
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

commit 49933254ba8d421ed706cbe6ed0fbc264e572cab upstream.

LOLLM observes that we don't reset i_nlink if we encounter a file with
no parent that isn't on the unlinked list.  This causes unnecessary
assertion trips on debugging kernels and an inconsistent file, so let's
fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 669dfe883c8e20 ("xfs: update the unlinked list when repairing link counts")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/nlinks_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -232,9 +232,14 @@ xrep_nlinks_repair_inode(
 	 * unlinked list, put it on the unlinked list.
 	 */
 	if (total_links == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		if (actual_nlink)
+			clear_nlink(VFS_I(ip));
 		error = xfs_iunlink(sc->tp, ip);
-		if (error)
+		if (error) {
+			if (actual_nlink)
+				set_nlink(VFS_I(ip), actual_nlink);
 			goto out_trans;
+		}
 		dirty = true;
 	}
 


