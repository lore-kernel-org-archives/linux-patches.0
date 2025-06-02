Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0544224247;
	Mon,  2 Jun 2025 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875272; cv=none; b=Rxi/knYwvY4HNAYTB63wae9j3v38I4mI6DHjuEyN/RMz0WWhFqCz9r5WEHladuCG8rx7NVuW2GDRaq7YiV7tbYdTNQI1tKw5d2VQz5qO2hBkbeCY/sqL8Z7KMo1ogxGpXAkYsXKy8RclOXeKZeflIPkF8RcECKbuVq3Q9QI9InE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875272; c=relaxed/simple;
	bh=U85LASC22LjKEJ25q0YN6rAPF9ca85mjadhb+Y4lGDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQwaQvdNtXyapogluqtKzk1xJCA9q2B73VgrZvLKYvM/cioHIJ6q/A3636h32gMXOrUr2MTNE38hL11+QOm/GN1V4k7nbOUaoVOBiBZ7+nYTCCLdoeL/C1P2+NsAnMr7x2lai0ahNgntpUbqJjJpq5DAh4sTf6H2KHv/Ccfxk2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fx02iHdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fx02iHdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409C3C4CEEB;
	Mon,  2 Jun 2025 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875272;
	bh=U85LASC22LjKEJ25q0YN6rAPF9ca85mjadhb+Y4lGDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fx02iHdgbwWstpDBgE4xKihiPYGNf3VnzMnYJNLoBO+PiMFzU9P7/R6Q7tfOWmK8G
	 Ast1DlaC+BwKkGsRcwWhLEJSH3uy8iU+dR/qXTJP/0czeAD3SNBwyMnGpaiiDXxSPA
	 erfUC8Egku0WCrIbKo2rLunDgJ/XE5wuhUFaWH2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/270] do_umount(): add missing barrier before refcount checks in sync case
Date: Mon,  2 Jun 2025 15:46:07 +0200
Message-ID: <20250602134310.525069482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2f97112657adc..e46267e7d29d1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -569,7 +569,7 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 		return 0;
 	mnt = real_mount(bastard);
 	mnt_add_count(mnt, 1);
-	smp_mb();			// see mntput_no_expire()
+	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
 	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
@@ -1638,6 +1638,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, UMOUNT_PROPAGATE);
 		retval = 0;
 	} else {
+		smp_mb(); // paired with __legitimize_mnt()
 		shrink_submounts(mnt);
 		retval = -EBUSY;
 		if (!propagate_mount_busy(mnt, 2)) {
-- 
2.39.5



