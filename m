Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2B58F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412C7C433C7;
	Sun, 16 Jul 2023 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539257;
	bh=saUuJtmgNOcRzC2+LuidwK54LuvYfbb+AABWeOWjxZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlpNxuqEz6LtkPve6M1sLJfEVLUXw0cCsOn7hD9UY2ept9CS4BC+gAreu6yIk+kwd
	 DKv0PFLfqAWGYvoIUOGXISN23y+TOxmNIJxq3KcvRUna7+g/FlEdGJ610JmC7VKUxi
	 UVvvNWREp/k3BG2gwNxpeeIz1XEgILDxAb+b7bDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.4 743/800] nfsd: use vfs setgid helper
Date: Sun, 16 Jul 2023 21:49:56 +0200
Message-ID: <20230716195006.378923738@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

commit 2d8ae8c417db284f598dffb178cc01e7db0f1821 upstream.

We've aligned setgid behavior over multiple kernel releases. The details
can be found in commit cf619f891971 ("Merge tag 'fs.ovl.setgid.v6.2' of
git://git.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping") and
commit 426b4ca2d6a5 ("Merge tag 'fs.setgid.v6.0' of
git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux").
Consistent setgid stripping behavior is now encapsulated in the
setattr_should_drop_sgid() helper which is used by all filesystems that
strip setgid bits outside of vfs proper. Usually ATTR_KILL_SGID is
raised in e.g., chown_common() and is subject to the
setattr_should_drop_sgid() check to determine whether the setgid bit can
be retained. Since nfsd is raising ATTR_KILL_SGID unconditionally it
will cause notify_change() to strip it even if the caller had the
necessary privileges to retain it. Ensure that nfsd only raises
ATR_KILL_SGID if the caller lacks the necessary privileges to retain the
setgid bit.

Without this patch the setgid stripping tests in LTP will fail:

> As you can see, the problem is S_ISGID (0002000) was dropped on a
> non-group-executable file while chown was invoked by super-user, while

[...]

> fchown02.c:66: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700

[...]

> chown02.c:57: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700

With this patch all tests pass.

Reported-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -388,7 +388,9 @@ nfsd_sanitize_attrs(struct inode *inode,
 				iap->ia_mode &= ~S_ISGID;
 		} else {
 			/* set ATTR_KILL_* bits and let VFS handle it */
-			iap->ia_valid |= (ATTR_KILL_SUID | ATTR_KILL_SGID);
+			iap->ia_valid |= ATTR_KILL_SUID;
+			iap->ia_valid |=
+				setattr_should_drop_sgid(&nop_mnt_idmap, inode);
 		}
 	}
 }


