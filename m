Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036434680
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78074C433C7;
	Wed,  9 Aug 2023 11:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581376;
	bh=I1GJuImQ15PpH6XRavHBpzK0jiCeHbc9K828tS6HhOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+xQ8KWDrH9q2uwItcbnH26E5o8SrY1IRywmMUVRFlvtMGVRAwcKKDuTeqmWR34nb
	 zaSiD3VkFOmIXe5vMytKc/D6oCORpVyR0alvq5430MJaQWM4HM5lpxI2Nd0r7PwPw/
	 p0oChlcECPuyauH5HC2woSp9pHc43ZSK3uheBhw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 181/201] fs: Protect reconfiguration of sb read-write from racing writes
Date: Wed,  9 Aug 2023 12:43:03 +0200
Message-ID: <20230809103649.840448040@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit c541dce86c537714b6761a79a969c1623dfa222b upstream.

The reconfigure / remount code takes a lot of effort to protect
filesystem's reconfiguration code from racing writes on remounting
read-only. However during remounting read-only filesystem to read-write
mode userspace writes can start immediately once we clear SB_RDONLY
flag. This is inconvenient for example for ext4 because we need to do
some writes to the filesystem (such as preparation of quota files)
before we can take userspace writes so we are clearing SB_RDONLY flag
before we are fully ready to accept userpace writes and syzbot has found
a way to exploit this [1]. Also as far as I'm reading the code
the filesystem remount code was protected from racing writes in the
legacy mount path by the mount's MNT_READONLY flag so this is relatively
new problem. It is actually fairly easy to protect remount read-write
from racing writes using sb->s_readonly_remount flag so let's just do
that instead of having to workaround these races in the filesystem code.

[1] https://lore.kernel.org/all/00000000000006a0df05f6667499@google.com/T/

Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230615113848.8439-1-jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -906,6 +906,7 @@ int reconfigure_super(struct fs_context
 	struct super_block *sb = fc->root->d_sb;
 	int retval;
 	bool remount_ro = false;
+	bool remount_rw = false;
 	bool force = fc->sb_flags & SB_FORCE;
 
 	if (fc->sb_flags_mask & ~MS_RMT_MASK)
@@ -922,7 +923,7 @@ int reconfigure_super(struct fs_context
 		if (!(fc->sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
 			return -EACCES;
 #endif
-
+		remount_rw = !(fc->sb_flags & SB_RDONLY) && sb_rdonly(sb);
 		remount_ro = (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
 	}
 
@@ -952,6 +953,14 @@ int reconfigure_super(struct fs_context
 			if (retval)
 				return retval;
 		}
+	} else if (remount_rw) {
+		/*
+		 * We set s_readonly_remount here to protect filesystem's
+		 * reconfigure code from writes from userspace until
+		 * reconfigure finishes.
+		 */
+		sb->s_readonly_remount = 1;
+		smp_wmb();
 	}
 
 	if (fc->ops->reconfigure) {


