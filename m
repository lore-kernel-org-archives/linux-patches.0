Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17A2611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFF6C433EF;
	Sun, 28 May 2023 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302645;
	bh=pW5df8G6vXyxyHCsbMscUSE7S/vLQ14G0Co6nZ1UI54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idqQ1pNV9Q5QfI0x+VABH1vjUrejPB5AaluCyz8lhDRI1rzH8erVMgh1VTYYjB4ju
	 ZvzZU9lrSATrWiGhsK52ZO7g3EmNE/O+u4ZNh1uMw40DWN6Io/Ow10Mkc7R1fiaIg5
	 A6oiLZ3RR1PrhIQxkvSbe7kSmw77fg9BwXPlhYs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 088/119] fs: fix undefined behavior in bit shift for SB_NOUSER
Date: Sun, 28 May 2023 20:11:28 +0100
Message-Id: <20230528190838.477018428@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Ge <gehao@kylinos.cn>

commit f15afbd34d8fadbd375f1212e97837e32bc170cc upstream.

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. It was spotted by UBSAN.

So let's just fix this by using the BIT() helper for all SB_* flags.

Fixes: e462ec50cb5f ("VFS: Differentiate mount flags (MS_*) from internal superblock flags")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Message-Id: <20230424051835.374204-1-gehao@kylinos.cn>
[brauner@kernel.org: use BIT() for all SB_* flags]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1380,29 +1380,29 @@ extern int send_sigurg(struct fown_struc
  * sb->s_flags.  Note that these mirror the equivalent MS_* flags where
  * represented in both.
  */
-#define SB_RDONLY	 1	/* Mount read-only */
-#define SB_NOSUID	 2	/* Ignore suid and sgid bits */
-#define SB_NODEV	 4	/* Disallow access to device special files */
-#define SB_NOEXEC	 8	/* Disallow program execution */
-#define SB_SYNCHRONOUS	16	/* Writes are synced at once */
-#define SB_MANDLOCK	64	/* Allow mandatory locks on an FS */
-#define SB_DIRSYNC	128	/* Directory modifications are synchronous */
-#define SB_NOATIME	1024	/* Do not update access times. */
-#define SB_NODIRATIME	2048	/* Do not update directory access times */
-#define SB_SILENT	32768
-#define SB_POSIXACL	(1<<16)	/* VFS does not apply the umask */
-#define SB_INLINECRYPT	(1<<17)	/* Use blk-crypto for encrypted files */
-#define SB_KERNMOUNT	(1<<22) /* this is a kern_mount call */
-#define SB_I_VERSION	(1<<23) /* Update inode I_version field */
-#define SB_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
+#define SB_RDONLY       BIT(0)	/* Mount read-only */
+#define SB_NOSUID       BIT(1)	/* Ignore suid and sgid bits */
+#define SB_NODEV        BIT(2)	/* Disallow access to device special files */
+#define SB_NOEXEC       BIT(3)	/* Disallow program execution */
+#define SB_SYNCHRONOUS  BIT(4)	/* Writes are synced at once */
+#define SB_MANDLOCK     BIT(6)	/* Allow mandatory locks on an FS */
+#define SB_DIRSYNC      BIT(7)	/* Directory modifications are synchronous */
+#define SB_NOATIME      BIT(10)	/* Do not update access times. */
+#define SB_NODIRATIME   BIT(11)	/* Do not update directory access times */
+#define SB_SILENT       BIT(15)
+#define SB_POSIXACL     BIT(16)	/* VFS does not apply the umask */
+#define SB_INLINECRYPT  BIT(17)	/* Use blk-crypto for encrypted files */
+#define SB_KERNMOUNT    BIT(22)	/* this is a kern_mount call */
+#define SB_I_VERSION    BIT(23)	/* Update inode I_version field */
+#define SB_LAZYTIME     BIT(25)	/* Update the on-disk [acm]times lazily */
 
 /* These sb flags are internal to the kernel */
-#define SB_SUBMOUNT     (1<<26)
-#define SB_FORCE    	(1<<27)
-#define SB_NOSEC	(1<<28)
-#define SB_BORN		(1<<29)
-#define SB_ACTIVE	(1<<30)
-#define SB_NOUSER	(1<<31)
+#define SB_SUBMOUNT     BIT(26)
+#define SB_FORCE        BIT(27)
+#define SB_NOSEC        BIT(28)
+#define SB_BORN         BIT(29)
+#define SB_ACTIVE       BIT(30)
+#define SB_NOUSER       BIT(31)
 
 /* These flags relate to encoding and casefolding */
 #define SB_ENC_STRICT_MODE_FL	(1 << 0)


