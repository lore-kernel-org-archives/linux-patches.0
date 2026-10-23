Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774223;
	b=bGRkBQpmV1DB3GzRW+qrdMhYbeWCx4U24igs3NLdL2eJZ4CNKRJXDhw2RzOyV6VQ6B+v
	 skUwtOVAAJ3lQjJQjchMVorf157qrAAYtPxJFdk1Ayjw6cx3+Ya00d01pTWer2hgUZIKv
	 cbF92z9lC3GZclptbXQM6NCmz9QcuGVYX/8z6trvRd4jTIzCilfVA+etPTfwPqIxRWyYQ
	 NDmpqZjdApld5IWxeXnyCtlAtKnv0P0P4ljutgQg7OkMmEenzBjmH6JyxJpC3ucAF+4L+
	 27WkuWkRZIWd+qjwpZYavA/Tkt5YfBh+uxbSk+ChGJ9Erluf3AFE3FZ+a4GEB+1FJXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zfZzb8QemYvTK724FdMB9fHlOUnl6Ng7nG5Xa9zQpLI=;
	b=hQkdzw/mVxJHOWAwRwmgLOCQoDDWOq3apecMt5R1Dxc8AJg5ngzk4y11O4leqKYDOFV2
	 5Ac8R/fp5smZhdSlqQM9kBmOodP5Al9URneKmTMyLcx4wv0Se0zxN4m6xbsst+yABd7vA
	 et5HEkJLr6J1WVudE1AjCpxZorQej2vsoJrszyMn1kLbRLDjI1KvciHIo0EzF11oZd//+
	 Vw7LD26YmZvSOWAoXgI87XTCRGqPYw9I5Ui/TjjFSzone5YkH5qYvn7oN6ZsPm8ervCzX
	 gD5fs/kb3vtbIZHGaZeJyuzgrl2F9J/jtBSeOwkkgWybrGHsJJTrS/2jWgj01ig7Dtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwMrjvOT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F82606A31A;
	Fri, 23 Oct 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwMrjvOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7301F01825;
	Fri, 23 Oct 2026 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774223;
	bh=zfZzb8QemYvTK724FdMB9fHlOUnl6Ng7nG5Xa9zQpLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwMrjvOTgFer8ji/RPLJE8CIybYjAShrTegJ7ZgE/CLm+KEHoYfdh9RUu/ss211ki
	 +Ckx/8ZffzSliM5ShAjkXSHwu6oZ8cLxGN0oZc5VV2bHywvrw4puJW9e7sgzdNrsUy
	 wzv6cfNT87R3TK4THkolk1+peOrQoBlg9i+jCbnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc433e4cd6d54736bf80@syzkaller.appspotmail.com,
	YangWen <anmuxixixi@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/193] ntfs3: fix double free of sbi->options->nls and clarify ownership of fc->fs_private
Date: Fri, 23 Oct 2026 18:37:19 +0200
Message-ID: <20261023163718.041447067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YangWen <anmuxixixi@gmail.com>

[ Upstream commit aee4d5a521e94f658e46c904e08a473daa9c8fc0 ]

commit 02f312754c87 ("ntfs3: fix use-after-free of sbi->options in cmp_fnames") introduced a use-after-free bug
due to improper handling of sbi->options in error paths. This resulted in crashes when superblock cleanup
is performed in ntfs_put_super.

This patch ensures that the options structure and its subfields are properly freed, preventing the memory
corruption and use-after-free errors.

Fixes: 02f312754c87 ("ntfs3: fix use-after-free of sbi->options in cmp_fnames")
Reported-by: syzbot+cc433e4cd6d54736bf80@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc433e4cd6d54736bf80
Signed-off-by: YangWen <anmuxixixi@gmail.com>
[almaz.alexandrovich@paragon-software.com: added fixes and closes tags]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: c01b091b0641 ("ntfs3: free the sbi after a grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -706,7 +706,7 @@ static void ntfs_put_super(struct super_
 
 	if (sbi->options) {
 		unload_nls(sbi->options->nls);
-		kfree(sbi->options->nls);
+		kfree(sbi->options->nls_name);
 		kfree(sbi->options);
 		sbi->options = NULL;
 	}
@@ -1264,6 +1264,7 @@ static int ntfs_fill_super(struct super_
 		}
 	}
 	sbi->options = options;
+	fc->fs_private = NULL;
 	sb->s_flags |= SB_NODIRATIME;
 	sb->s_magic = 0x7366746e; // "ntfs"
 	sb->s_op = &ntfs_sops;
@@ -1694,7 +1695,7 @@ put_inode_out:
 out:
 	if (sbi && sbi->options) {
 		unload_nls(sbi->options->nls);
-		kfree(sbi->options->nls);
+		kfree(sbi->options->nls_name);
 		kfree(sbi->options);
 		sbi->options = NULL;
 	}


