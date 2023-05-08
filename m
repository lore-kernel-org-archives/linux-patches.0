Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC23A168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F94CC4339B;
	Mon,  8 May 2023 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539687;
	bh=QE8+x8mQqTZy8uzQu4KhN8yuBBPjeBq1MEVLqCcUFkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uqi/IA+qiZOXFljUkgqBn37V0WDZE5FtA9TGjMSMsLGuxNO1xFMaGG6puLlw4tJ5d
	 KnoeAt4oQFJdIGxiJVXvr2c2DQL9O1ax+5WjnT2gXsU7OOSv+4vs0DNTeX0nS0yEdG
	 atNy0+8HQpyLRW8/SecUP4kBQuQCv7FoFtAsDDtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 074/611] reiserfs: Add security prefix to xattr name in reiserfs_security_write()
Date: Mon,  8 May 2023 11:38:36 +0200
Message-Id: <20230508094424.443247134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

commit d82dcd9e21b77d338dc4875f3d4111f0db314a7c upstream.

Reiserfs sets a security xattr at inode creation time in two stages: first,
it calls reiserfs_security_init() to obtain the xattr from active LSMs;
then, it calls reiserfs_security_write() to actually write that xattr.

Unfortunately, it seems there is a wrong expectation that LSMs provide the
full xattr name in the form 'security.<suffix>'. However, LSMs always
provided just the suffix, causing reiserfs to not write the xattr at all
(if the suffix is shorter than the prefix), or to write an xattr with the
wrong name.

Add a temporary buffer in reiserfs_security_write(), and write to it the
full xattr name, before passing it to reiserfs_xattr_set_handle().

Also replace the name length check with a check that the full xattr name is
not larger than XATTR_NAME_MAX.

Cc: stable@vger.kernel.org # v2.6.x
Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/reiserfs/xattr_security.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -82,11 +82,15 @@ int reiserfs_security_write(struct reise
 			    struct inode *inode,
 			    struct reiserfs_security_handle *sec)
 {
+	char xattr_name[XATTR_NAME_MAX + 1] = XATTR_SECURITY_PREFIX;
 	int error;
-	if (strlen(sec->name) < sizeof(XATTR_SECURITY_PREFIX))
+
+	if (XATTR_SECURITY_PREFIX_LEN + strlen(sec->name) > XATTR_NAME_MAX)
 		return -EINVAL;
 
-	error = reiserfs_xattr_set_handle(th, inode, sec->name, sec->value,
+	strlcat(xattr_name, sec->name, sizeof(xattr_name));
+
+	error = reiserfs_xattr_set_handle(th, inode, xattr_name, sec->value,
 					  sec->length, XATTR_CREATE);
 	if (error == -ENODATA || error == -EOPNOTSUPP)
 		error = 0;


