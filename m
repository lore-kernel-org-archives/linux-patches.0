Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B6D1DFD1;
	Tue,  8 Oct 2024 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392657; cv=none; b=r5bEE2SC7DL0A9qDzv39G/rIYfG10Yw7h1bnF0ZYerd7dWmm+W4Cqw7fPukO997LHU6+vWAkDMKaIOMf0yBfEgw1b3rWlgJEH37sOm/IyjejBetNkzgLDD0IUzJAktTKTByJJTtD1raZXGNr8AT30DzmmDAXug+E/s/CLfY+2gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392657; c=relaxed/simple;
	bh=EC37W11r2ShW6b0rk8ojWyKorAnH3Xsl3FqOAWxUeOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF2KRPpmJZoaN6Xqk2Zj1lLIxPR88VYMgE4WtAixc9bGFRjs+Uo2rFbV74KEZqc8SHfMb9aUyKwoSb+poz3eyG7i8M3H5rOGCt4KvmD+9yOaKsoAEJ4WF7AyAlNLA5nsJha48d6i//BTBh8NYQ/3CkfHyX+h2CkBsBJGf3GpV5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0dMsdQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0dMsdQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A79DC4CECD;
	Tue,  8 Oct 2024 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392656;
	bh=EC37W11r2ShW6b0rk8ojWyKorAnH3Xsl3FqOAWxUeOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0dMsdQvSaFESoHsOrCZmVWNmCU0EPj1EowYP6ZQlixb/Ct3sb8FOR9k9Ti5hePdL
	 mh7HM7OuLKCaeqOMQT6OnCaWU1EY+RNMuqdfcB7fNaZQIr910U1jAP98NdUPBHyDHg
	 D3igw9XYD0/6FayCRYLigk/+L4OAHJ6/kAfs6DT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d34c2a269ed512c531b0@syzkaller.appspotmail.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.11 449/558] gfs2: fix double destroy_workqueue error
Date: Tue,  8 Oct 2024 14:07:59 +0200
Message-ID: <20241008115719.931287189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao2870@gmail.com>

commit 6cb9df81a2c462b89d2f9611009ab43ae8717841 upstream.

When gfs2_fill_super() fails, destroy_workqueue() is called within
gfs2_gl_hash_clear(), and the subsequent code path calls
destroy_workqueue() on the same work queue again.

This issue can be fixed by setting the work queue pointer to NULL after
the first destroy_workqueue() call and checking for a NULL pointer
before attempting to destroy the work queue again.

Reported-by: syzbot+d34c2a269ed512c531b0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d34c2a269ed512c531b0
Fixes: 30e388d57367 ("gfs2: Switch to a per-filesystem glock workqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glock.c      |    1 +
 fs/gfs2/ops_fstype.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2249,6 +2249,7 @@ void gfs2_gl_hash_clear(struct gfs2_sbd
 	gfs2_free_dead_glocks(sdp);
 	glock_hash_walk(dump_glock_func, sdp);
 	destroy_workqueue(sdp->sd_glock_wq);
+	sdp->sd_glock_wq = NULL;
 }
 
 static const char *state2str(unsigned state)
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1307,7 +1307,8 @@ fail_debug:
 fail_delete_wq:
 	destroy_workqueue(sdp->sd_delete_wq);
 fail_glock_wq:
-	destroy_workqueue(sdp->sd_glock_wq);
+	if (sdp->sd_glock_wq)
+		destroy_workqueue(sdp->sd_glock_wq);
 fail_free:
 	free_sbd(sdp);
 	sb->s_fs_info = NULL;


