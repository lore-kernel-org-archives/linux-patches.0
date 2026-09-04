Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3695041D21E;
	Fri,  4 Sep 2026 06:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502586; cv=none; b=dRuYz+Phlt0EZeMapftGVBPr/uTCC7iOhe6xczFRzmejneC9is5JBsvXYuMsFBaGC3czaqTdr+mXY5lZUihUX3zVbOkvsW93ai5MotnAwCaocEXd2H0E0nCGCEDTA65aPrufpIK+XOscP+2dwzhpkg6q4mi8vKyyspcMhJGJWEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502586; c=relaxed/simple;
	bh=PEoKl2w6zElZydyqJ7A7UK7M7Uu/xkQanlrjfbF7Ugk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDUtxfl0it0Cc4zopo5uHuoA6KOMYJE7Bb5K+TnTMhCH2nxL7G67KxnvvTRoQbOrJWJ+cfkarkqdBI+1LDHvMIsXKkGfKLH3xcOKxEWkjrzmImoFMH91TQWKUSlWcaljwFHZErelcsD0uVPGI+5Z/ubkfOfheVdWc53RQZMc5vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guxtykpk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guxtykpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB511F00A3D;
	Fri,  4 Sep 2026 06:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502584;
	bh=ZeElOof1kgpz8ea5lAqSqWorDsYeMFwia4EVukA0sLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guxtykpkUTMgiP8C9I7FOyE924r5uGHDobhfCpZpg/m+rAUR/y/6QY7ppSXNdh/ls
	 P0o+WELbLtgfXnE/kj/aTD1blSKpGCq1J90U7f0MRqoKGmTxS3RMbe1GvYyt3Af/Tv
	 dMJLUUej8NSsvyTp+oj/V3NRb/wK9UEoh7fY5h1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.12 258/403] lockd: fix NULL dereference on lockowner allocation failure
Date: Fri,  4 Sep 2026 07:01:01 +0200
Message-ID: <20260904045740.733022305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 4c7fc129db061c7daab841c4f3c342d894832362 upstream.

nlmclnt_locks_init_private() installs NLM file lock operations even when
nlmclnt_find_lockowner() fails to allocate a lockowner. nlmclnt_proc()
then returns -ENOMEM, but the VFS still tears down the partially
initialized file_lock and calls locks_release_private().

That invokes nlmclnt_locks_release_private(), which dereferences
fl->fl_u.nfs_fl.owner and crashes because the owner was never installed.

Clear fl_ops before attempting to initialize the NLM private state, and
install the NLM lock operations only after a lockowner has been allocated
successfully.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/clntproc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -487,9 +487,12 @@ static const struct file_lock_operations
 static void nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host)
 {
 	fl->fl_u.nfs_fl.state = 0;
+	fl->fl_ops = NULL;
 	fl->fl_u.nfs_fl.owner = nlmclnt_find_lockowner(host,
 						       fl->c.flc_owner);
 	INIT_LIST_HEAD(&fl->fl_u.nfs_fl.list);
+	if (!fl->fl_u.nfs_fl.owner)
+		return;
 	fl->fl_ops = &nlmclnt_lock_ops;
 }
 


