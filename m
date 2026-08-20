Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23CA1A9FBA;
	Thu, 20 Aug 2026 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246945; cv=none; b=CFVOIjf9AHjFc71vjXoi3q1ubBBTHph0rsAQsvAQhRFsW2/fEcZ26clmsngvLV7JDo5W5S/8O/npEXijvB+hHEeXlqys6o2EsiuxN02peYwYeOMMLqQWY3OxSu+Flgbe3wE8nWiNNT8mmE8Y0QHsS4sw8LSugpe9yflVZBOUZZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246945; c=relaxed/simple;
	bh=mjpJngenZWNevfjfOwoDi+jucvPRaSsHykFpLNoC4bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiiV6fD+RV08UDbnWmzKcF1h5rAV0IJsnF/HAIIqCh1XGAOjdn1mUUGGO6hkUcWfb8QQYWzOmPU/DPXGu8Km8BXaPisXI9EFhpC5QS4uOK5SH9u4AmwiBVdNotdWNKnITgDE8NcNDtQINhCkZPrGa4GYiBI9/pQK2l89e+FIBis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wppx/lPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wppx/lPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67491F00A3A;
	Thu, 20 Aug 2026 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246944;
	bh=ZwDKrl88syzujOhpxM0qDcD0PNQsVZqitIxO+VZPJVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wppx/lPEIOSJ17x9axAXNAoxIUSNz0PvHBAyZwWAi1lGGBai5b5WHJEmJIZCOdtr3
	 CH+A/Lwf8JVbKPZVJs1qgcVF76KGWeGStqCbXbdMn5flVmZlTfXNufgFxsRhCtZn9Z
	 l9zMVfJuZE1bviJkJb4Ix31G6D2m18720gnO97/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 093/220] xfs: zero i_nlink before repair puts inode on unlinked list
Date: Thu, 20 Aug 2026 16:54:43 +0200
Message-ID: <20260820145226.274812113@linuxfoundation.org>
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
@@ -234,9 +234,14 @@ xrep_nlinks_repair_inode(
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
 


