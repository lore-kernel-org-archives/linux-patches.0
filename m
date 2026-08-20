Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473FF37F72E;
	Thu, 20 Aug 2026 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238990; cv=none; b=YgY+w07BGVzpF8VzDgwdwux7WjDdodBDMmzJOpQZomZLjZW3ORIaZfY0bf2UwO8DMGTpMqo6c/+XmtoesUPcYtPVh/3Z9ZDZKJsKn1z/i0hqmqErI8EdSCdUaPu+E4QrXJr7eVytmoiHhpnsnl2N6H1HW550XCOgvToHgOBSffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238990; c=relaxed/simple;
	bh=ALYH2yQTkmYCm8YNJc8yNsGE4UNVPhbMZXV6xj0xW60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3t8PsMYWgX376uSTwjHfiEPbpEqVrV5OV3GVibvtjNqQir/cIXf1HrehsJBMK8rM2bkkMlaUNojtiTYJAelw0iQZc3OZwKyIMuV9ussp1w20y5Jy3H+63OVR038pX/A9A9N5uuE20upS4PgtLhOGcGXbF4n3C00AB9P0fwdBB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8F9QAnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8F9QAnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769A91F000E9;
	Thu, 20 Aug 2026 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238989;
	bh=8Z2xnQvgRpUM8ZpVeuJdcITrWAxGL/AwFS0dD3OGels=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8F9QAnv4uNlPST9xNUYCjdlYRGZS7R5/PuES1Hg/GvcghwaSAGb+PwYV0s3uE/0M
	 O1QwC8/XrOF6LJCILkyIpBgVTzTVxRd+i+NErQmgtDqXXeaWGwlif00FBkiqKdNWM8
	 tP+Ja2wMFQWSzmApH32Ro3z3n/CVORj6kOZzNYfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 110/217] xfs: zero i_nlink before repair puts inode on unlinked list
Date: Thu, 20 Aug 2026 16:54:38 +0200
Message-ID: <20260820145241.050242405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
 


