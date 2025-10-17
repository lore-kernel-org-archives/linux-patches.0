Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5732E151;
	Fri, 17 Oct 2025 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714649; cv=none; b=I8LT+D+xHFYMs23AZ6eXB6uhxIK12Bkor+tNJfUJOV1OPn5cVZJW74Mxnya5vBXRKMil0X3+Al3wzNlat9cUko5LCE7nx/asRfbcuqfgCu9ZqcYQ/pqQvD7jkldx/ogUh6I5isdwlVSdqjTWm7EhER/7bZ0F5o/R0a/+yj96VQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714649; c=relaxed/simple;
	bh=so+B3lgiDklxtuEC4TgL96xxlKg3N3L2NRg9FAVf7a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMO7OHxTSbj+POONVe25maMAY0CfNfdp9ilakGdRY59BGzBvu2PQeHWtbl01gXlI0cMK3LYMstxbC5zzRLN9y6RtgAfHOukWlu7jLhzz6mr17P+Y1iTpu0A8n0Hu+BWxUmMbc+8owXDy9lYF8NOx7Lwm20EsGkbWkk8NKsVS5Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZ9MCONP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZ9MCONP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8834C4CEFE;
	Fri, 17 Oct 2025 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714649;
	bh=so+B3lgiDklxtuEC4TgL96xxlKg3N3L2NRg9FAVf7a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ9MCONPXQQ9xH5dC4/2bhamNl1Aefu2QbJioRMf/vj2759GlScMUgZAgovOH1eVB
	 16O0rQgl54S4au7hgQCFQ0TL8QLQ1XA83pVrZWm3X74nXMblMZOa8JBD0IEdoYJ2Gd
	 BAy/SivD/JAZwfE+CaZVU1X8YhNU45NhUq3Oavvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	syzbot+4c9d23743a2409b80293@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>
Subject: [PATCH 6.12 219/277] ext4: validate ea_ino and size in check_xattrs
Date: Fri, 17 Oct 2025 16:53:46 +0200
Message-ID: <20251017145155.124197555@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 44d2a72f4d64655f906ba47a5e108733f59e6f28 upstream.

During xattr block validation, check_xattrs() processes xattr entries
without validating that entries claiming to use EA inodes have non-zero
sizes. Corrupted filesystems may contain xattr entries where e_value_size
is zero but e_value_inum is non-zero, indicating invalid xattr data.

Add validation in check_xattrs() to detect this corruption pattern early
and return -EFSCORRUPTED, preventing invalid xattr entries from causing
issues throughout the ext4 codebase.

Cc: stable@kernel.org
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+4c9d23743a2409b80293@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=4c9d23743a2409b80293
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20250923133245.1091761-1-kartikey406@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -251,6 +251,10 @@ check_xattrs(struct inode *inode, struct
 			err_str = "invalid ea_ino";
 			goto errout;
 		}
+		if (ea_ino && !size) {
+			err_str = "invalid size in ea xattr";
+			goto errout;
+		}
 		if (size > EXT4_XATTR_SIZE_MAX) {
 			err_str = "e_value size too large";
 			goto errout;


