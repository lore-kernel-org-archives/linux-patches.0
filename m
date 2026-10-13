Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C1F3D5241;
	Tue, 13 Oct 2026 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892549; cv=none; b=AJ+DvI/4jrXkawgMpce1YbP5YhQ7h+9tgaG7zXddJ+IOMtopNW2XTPFUOlqotBpGjdmfuwcubbcfNUo46BOQhMb9BESnT6CC+wBz4xi7AxFKKcN/wg+OcxxjglUNyuRp6F+T3tXQXeZyAoLnAq8CKF08xCwWIWm1cEkdsxICaTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892549; c=relaxed/simple;
	bh=kMYBsJAHQk6CymMifx7o5npo1h0wSNMIRKysCG1abac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+iIUwcLbcNnAVcm+M6ADWcrRK6D8yUcwa7/4chtgf813U8bMiivnvMDgrxdOUEgGTW+uQRcmk5KmGRirNjLbY26XIK++SdncDysXVtPdY53yOysVaT28p49YSodDI9VEBlDCZlGCdUXMDPROFzO7sOQch6Gq967zHuNU8bBnt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ5RbrA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ5RbrA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD91F000FF;
	Tue, 13 Oct 2026 11:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892548;
	bh=ZBazoL0FwlJ6vViUPMc/MrJ+FsxQKypF70X2HkNu4UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZ5RbrA+EyTwMypgqq3qYTx0H5MO1JGbiBbBYI//oBQ4K54/jrTTFKj0Lx25czrSM
	 HSqCiGFKSaeSnLj0XN3i7pJOwbL7brv/SlCBeLuDCG+/8U4VQsA1/oIBc7e6sW/z3Y
	 NYgcim5KrRoBicrIs1ndAklRIDfhe9yXBhyI9L3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 173/281] namespace: keep the lock on a mount that a propagated copy is moved beneath
Date: Tue, 13 Oct 2026 13:38:09 +0200
Message-ID: <20261013112859.361893459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit d74d66aa708ccf2bc0b1e265a83fed0f2308d5c4 upstream.

attach_recursive_mnt() transfers MNT_LOCKED from the top mount to the
mount that is moved beneath it with MOVE_MOUNT_BENEATH. This allows the
owner of a user namespace to replace its locked /proc or its root. The
mount beneath takes on the job of covering the underlying mountpoint
allowing the top mount to be unmounted.

Consider two mount namespaces:

(H) The host H has a shared mount P with a secret in P/d
(Z) Z is a user namespace made from M. Its copy of P receives
    propagation from the host's P and its copy of M's cover on P/d is
    locked Z's owner must not get to see P/d.

Now (H) mounts X on P/d. This propagates into (Z). The copy of X lands
beneath (Z)'s locked cover. The locked property is transfered from (Z)'s
cover to the copy of X propagated beneath it. The cover is now unlocked.

Now (H) unmounts X again. The copy of X in (Z) gets unmounted and the
covering mount is left unlocked on top of P/d. (Z) can now unmount it:

    Z: umount2(P/d)             = EINVAL            /* the cover is locked */
    H: mount X on P/d, umount X                     /* both propagate into Z /*
    Z: umount2(P/d)             = 0                 /* the cover is now unlocked */
    Z: read P/d/secret          = "covered-by-root" /* secret revealed */

So only transfer the locked property to the mount beneath for mounts the
caller has placed. A propagated copy that lands beneath a locked mount
is locked as well so that the mount at the bottom of the stack carries a
lock the way every check expects. The mount on top of it remains locked
to ensure that it keeps covering even if the propagated mount is
unmounted again.

Fixes: c62a4766937e ("move_mount: transfer MNT_LOCKED")
Cc: stable@vger.kernel.org # v7.1+
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-9-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2697,15 +2697,17 @@ static int attach_recursive_mnt(struct m
 			/*
 			 * If @q was locked it was meant to hide
 			 * whatever was under it. Let @child take over
-			 * that job and lock it, then we can unlock @q.
-			 * That'll allow another namespace to shed @q
-			 * and reveal @child. Clearly, that mounter
-			 * consented to this by not severing the mount
-			 * relationship. Otherwise, what's the point.
+			 * that job and lock it. If @child is the mount
+			 * the caller placed we can then unlock @q:
+			 * nothing another namespace does removes it
+			 * again. A propagated copy goes away when the
+			 * mounter of the original unmounts it, so @q
+			 * keeps its lock.
 			 */
 			if (IS_MNT_LOCKED(q)) {
 				child->mnt.mnt_flags |= MNT_LOCKED;
-				q->mnt.mnt_flags &= ~MNT_LOCKED;
+				if (child == source_mnt)
+					q->mnt.mnt_flags &= ~MNT_LOCKED;
 			}
 			mnt_change_mountpoint(r, mp, q);
 		}


