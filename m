Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0405453A7;
	Fri,  6 Dec 2024 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497611; cv=none; b=bgnTpy2l4JNGHWrGnwqV8vrJ8x6pnXv+4fmmZjz8rKOxayGUseazJGw4ofvNuimQG4227BHulBVfo8Xf78qt1zFikODw+UtGA92jRx2CKm72Txn06D9UEI7TwHw7LwKbjyfY2PNDVphsEHEhknTaYWpK4qLVEtFWLLsn1LaVoqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497611; c=relaxed/simple;
	bh=1kYx1O1gt3MTdTqSXICawkZ+oWn+71jihpV4CcaVIKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJ2LdOwpPQ4chRnzZcv639r0J0xi2BvbBWGboLWP6H7Gf0j8SL+K9+ho4lQSeDddhJttMyldHDwqbXXBZivjwj2Xg/vKDOXD8AuTUwKSEGie/H+US0VMCXdhOwdDCWqiUM1ucwp2zMT5vOyZW/2zAkYZQoR7zlQYk0scUPbLCuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LqQnsxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LqQnsxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600BFC4CED1;
	Fri,  6 Dec 2024 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497610;
	bh=1kYx1O1gt3MTdTqSXICawkZ+oWn+71jihpV4CcaVIKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LqQnsxaPqMT8ItRaCckI8wXCZgCoEVrUPbHcqfzVSw0CUMcByQYtOFxOhngDhfBs
	 GdfrQjg5RibhlEWxMJYwMpteSYamTI3c22FnLkloTtgKESfcD7atDjijeZmYrDtFXN
	 icY3oRaAoBcyONV0UgADQGu9fwncRjPryaJ3PLsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 339/676] gfs2: Allow immediate GLF_VERIFY_DELETE work
Date: Fri,  6 Dec 2024 15:32:38 +0100
Message-ID: <20241206143706.590103008@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 160bc9555d8654464cbbd7bb1f6687048471d2f6 ]

Add an argument to gfs2_queue_verify_delete() that allows it to queue
GLF_VERIFY_DELETE work for immediate execution.  This is used in the
next patch.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 7c6f714d8847 ("gfs2: Fix unlinked inode cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index eda0d52ae333b..e9b5a8eaf3003 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1028,14 +1028,15 @@ bool gfs2_queue_try_to_evict(struct gfs2_glock *gl)
 				  &gl->gl_delete, 0);
 }
 
-static bool gfs2_queue_verify_delete(struct gfs2_glock *gl)
+static bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
+	unsigned long delay;
 
 	if (test_and_set_bit(GLF_VERIFY_DELETE, &gl->gl_flags))
 		return false;
-	return queue_delayed_work(sdp->sd_delete_wq,
-				  &gl->gl_delete, 5 * HZ);
+	delay = later ? 5 * HZ : 0;
+	return queue_delayed_work(sdp->sd_delete_wq, &gl->gl_delete, delay);
 }
 
 static void delete_work_func(struct work_struct *work)
@@ -1067,7 +1068,7 @@ static void delete_work_func(struct work_struct *work)
 		if (gfs2_try_evict(gl)) {
 			if (test_bit(SDF_KILL, &sdp->sd_flags))
 				goto out;
-			if (gfs2_queue_verify_delete(gl))
+			if (gfs2_queue_verify_delete(gl, true))
 				return;
 		}
 		goto out;
@@ -1079,7 +1080,7 @@ static void delete_work_func(struct work_struct *work)
 		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -EAGAIN &&
 			    !test_bit(SDF_KILL, &sdp->sd_flags) &&
-			    gfs2_queue_verify_delete(gl))
+			    gfs2_queue_verify_delete(gl, true))
 				return;
 		} else {
 			d_prune_aliases(inode);
-- 
2.43.0



