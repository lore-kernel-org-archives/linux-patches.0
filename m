Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843B729B764;
	Mon, 12 May 2025 18:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073095; cv=none; b=gkJiuhBb32CbNU6nIA8Hqdx3RdtNskzFeA/BCDwnWak9VdSU0N9jRq8bUSFQYheMCgrPOgPZUO5NLQfJPKDevHr/Li25yLMRL7q3tzw6nnm6e6tN9r1pUGmU0CoNZpljvlQgj5dz3xQ2bgLG23As1r0jtzd4CoqRppmeCR8A8Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073095; c=relaxed/simple;
	bh=JUmgEvpH8oyO33xkz719wxgM0QDrT9JlC52zsOjlHkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4JtbO6g0WfEbQzMGuROOIaoOutXdknK2GJ4BoV65LrfcFjKR2U4uR2dzNrK/Ddp/i/7vyypi31xoLLDF+O1pCQ3SQ/4jneIB/2tMgF0avMHzE4WXcKHjNbXAqygYeWcVKO2mSe9h/n/CILtyLnhCoDQRmn0AqWcBOhIlhc/nGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdkDa+o1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdkDa+o1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B7DC4CEF1;
	Mon, 12 May 2025 18:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073095;
	bh=JUmgEvpH8oyO33xkz719wxgM0QDrT9JlC52zsOjlHkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdkDa+o1fZUg3dwyzwIG8NnD7RRRLKmjFP2kdyM+ZFq93V49V1PVMA0nK8rSV5Ce0
	 r5ep47LRSfUh+8YqEHdUIoRpatZLcyg71ceIEx2d81ELGMiaHbpXvfnTSO/KybBz3G
	 Z6p5JsyVZf9ovHnjOnKFRqXA+Ktf8A/u2ySyDZH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/184] do_umount(): add missing barrier before refcount checks in sync case
Date: Mon, 12 May 2025 19:45:53 +0200
Message-ID: <20250512172048.006385679@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 65781e19dcfcb4aed1167d87a3ffcc2a0c071d47 ]

do_umount() analogue of the race fixed in 119e1ef80ecf "fix
__legitimize_mnt()/mntput() race".  Here we want to make sure that
if __legitimize_mnt() doesn't notice our lock_mount_hash(), we will
notice their refcount increment.  Harder to hit than mntput_no_expire()
one, fortunately, and consequences are milder (sync umount acting
like umount -l on a rare race with RCU pathwalk hitting at just the
wrong time instead of use-after-free galore mntput_no_expire()
counterpart used to be hit).  Still a bug...

Fixes: 48a066e72d97 ("RCU'd vfsmounts")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bd601ab26e781..c3c1e8c644f2e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -747,7 +747,7 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 		return 0;
 	mnt = real_mount(bastard);
 	mnt_add_count(mnt, 1);
-	smp_mb();			// see mntput_no_expire()
+	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
 	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
@@ -1916,6 +1916,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, UMOUNT_PROPAGATE);
 		retval = 0;
 	} else {
+		smp_mb(); // paired with __legitimize_mnt()
 		shrink_submounts(mnt);
 		retval = -EBUSY;
 		if (!propagate_mount_busy(mnt, 2)) {
-- 
2.39.5



