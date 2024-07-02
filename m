Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2436315218A;
	Tue,  2 Jul 2024 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940224; cv=none; b=eGwn430BrsJA9tosNDWAiyBjpEPpseqbA5DFD3G//CuHGBLZQfQLPtsn469ZMCumXvdZoWFDPdyx/9pTugrC2KddM/jvPqtdjYRw+FA8By8BTC/sFoZud08Dagsf3Pu9w2yH781BeORD8amzhtzi9k+zXJczSgx0FmRowfXMMc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940224; c=relaxed/simple;
	bh=tiTqfn78M7gMYBNmCS1w5BHe7j5Pl9RkaD+6LexcobE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkPH+JU4yVOpYU9uhtl8AbiPujrXS0At5VnGLzV+qRfBJc7/VQ6TTG/mDgwpOkKDeEilZFoKwxsag2ivLbOxEqRlXGaebZuasp3ZuzCugOwPmqLlSuojjWG4U/D5ZUVz9Ymm+IouNWLBvBoHOtw7cErPsRF8KEzFRJ6zCI7jm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9LnUP2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9LnUP2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92202C116B1;
	Tue,  2 Jul 2024 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940224;
	bh=tiTqfn78M7gMYBNmCS1w5BHe7j5Pl9RkaD+6LexcobE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9LnUP2WonuIPzQbY9J3TaMbL34m+onQgslhbaBddKwGlNRbo+dU6aWwBnDn4jmwk
	 6Yiw+1ltUxttaGHjbCtOwQdQHeFTeJUSHCoGwLy07m5NdPqiVfk3PCQNEY/QurbS7A
	 onLLf39YyC2KteIg+ncfVtSRGajv3ObBkbQpmlyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 090/222] gfs2: Fix NULL pointer dereference in gfs2_log_flush
Date: Tue,  2 Jul 2024 19:02:08 +0200
Message-ID: <20240702170247.415604116@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 35264909e9d1973ab9aaa2a1b07cda70f12bb828 ]

In gfs2_jindex_free(), set sdp->sd_jdesc to NULL under the log flush
lock to provide exclusion against gfs2_log_flush().

In gfs2_log_flush(), check if sdp->sd_jdesc is non-NULL before
dereferencing it.  Otherwise, we could run into a NULL pointer
dereference when outstanding glock work races with an unmount
(glock_work_func -> run_queue -> do_xmote -> inode_go_sync ->
gfs2_log_flush).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c   | 3 ++-
 fs/gfs2/super.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 8cddf955ebc0c..a6dd68b458cec 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1108,7 +1108,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	lops_before_commit(sdp, tr);
 	if (gfs2_withdrawing_or_withdrawn(sdp))
 		goto out_withdraw;
-	gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
+	if (sdp->sd_jdesc)
+		gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
 	if (gfs2_withdrawing_or_withdrawn(sdp))
 		goto out_withdraw;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2d780b4701a23..ee61fcb7f200d 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -67,9 +67,13 @@ void gfs2_jindex_free(struct gfs2_sbd *sdp)
 	sdp->sd_journals = 0;
 	spin_unlock(&sdp->sd_jindex_spin);
 
+	down_write(&sdp->sd_log_flush_lock);
 	sdp->sd_jdesc = NULL;
+	up_write(&sdp->sd_log_flush_lock);
+
 	while (!list_empty(&list)) {
 		jd = list_first_entry(&list, struct gfs2_jdesc, jd_list);
+		BUG_ON(jd->jd_log_bio);
 		gfs2_free_journal_extents(jd);
 		list_del(&jd->jd_list);
 		iput(jd->jd_inode);
-- 
2.43.0



