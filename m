Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30930C374;
	Mon, 13 Oct 2025 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368905; cv=none; b=UosRmXR5eU3cBZrpN7zybOVMwzcTKzqU95Wpo4lFLUU9pnraZwDjF2f5r9NVVLu/pNnjfAvlG5LKHX7TfcZpP/SlBFDF5gEGFs6fk+CJYlA/5E/VT03lS9DLhHUeirZ9E0r5EZ97gBhC94w2rrBhdDHGEd6XOx7vMfcUlMxEKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368905; c=relaxed/simple;
	bh=dDDXF/h97/zpLyo2LT7ElsZI8HNnIaFgbRvChfIEn9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g273i8+MtKBAvSopwCkYEcSV5m/0P642e9kIPczK6R2xaxiBd9YN+wZNZeMvpqSOJs5lWOjG24geIB9boI51UhMcDuB7BAC/PHoZphmk2AeLGttiPdPBJD2ZLJ1hfEArzon/erhWXKE/uV0BQCWJYityveJ70IZBOV0flaDfAyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrogzfDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrogzfDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C417C4CEE7;
	Mon, 13 Oct 2025 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368904;
	bh=dDDXF/h97/zpLyo2LT7ElsZI8HNnIaFgbRvChfIEn9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrogzfDePkCsspyaRZuj5hABRb/xzKFnfRfd/ysbI9+nqxFwYGbki2+V4U83ImFib
	 ZXGy1QVvGbnN6PBn1wA6m4Zt5TWswQPgjYjCHj2w5bKhqZcWAAqu8RujaIrVdk8em1
	 pPhwVzp0eNqL7wojfPmrfNJi+mUGPIdMfKgw+y2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 016/563] gfs2: Remove duplicate check in do_xmote
Date: Mon, 13 Oct 2025 16:37:57 +0200
Message-ID: <20251013144411.878955952@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 9b54770b68ae793a3a8d378be4cda2bb7be6c8cc ]

In do_xmote(), remove the duplicate check for the ->go_sync and
->go_inval glock operations.  They are either both defined, or none of
them are.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Stable-dep-of: bddb53b776fb ("gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5edf125b39fe3..93aae10d78f30 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -714,25 +714,24 @@ __acquires(&gl->gl_lockref.lock)
 				     &gl->gl_flags))
 			return;
 	}
-	if (!glops->go_inval && !glops->go_sync)
+	if (!glops->go_inval || !glops->go_sync)
 		goto skip_inval;
 
 	spin_unlock(&gl->gl_lockref.lock);
-	if (glops->go_sync) {
-		ret = glops->go_sync(gl);
-		/* If we had a problem syncing (due to io errors or whatever,
-		 * we should not invalidate the metadata or tell dlm to
-		 * release the glock to other nodes.
-		 */
-		if (ret) {
-			if (cmpxchg(&sdp->sd_log_error, 0, ret)) {
-				fs_err(sdp, "Error %d syncing glock\n", ret);
-				gfs2_dump_glock(NULL, gl, true);
-			}
-			spin_lock(&gl->gl_lockref.lock);
-			goto skip_inval;
+	ret = glops->go_sync(gl);
+	/* If we had a problem syncing (due to io errors or whatever,
+	 * we should not invalidate the metadata or tell dlm to
+	 * release the glock to other nodes.
+	 */
+	if (ret) {
+		if (cmpxchg(&sdp->sd_log_error, 0, ret)) {
+			fs_err(sdp, "Error %d syncing glock\n", ret);
+			gfs2_dump_glock(NULL, gl, true);
 		}
+		spin_lock(&gl->gl_lockref.lock);
+		goto skip_inval;
 	}
+
 	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags)) {
 		/*
 		 * The call to go_sync should have cleared out the ail list.
-- 
2.51.0



