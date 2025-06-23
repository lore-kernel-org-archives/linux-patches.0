Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD322AEE4;
	Mon, 23 Jun 2025 21:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715053; cv=none; b=LBRS+GUcT9lZ1BokByX8B//tDBQVFYOCRixBOfPgNqZGDUDHc5ZAw5Rl3FLYBp0ANMbc3oRL1LsFA3YqmjW8kSzJLIsNZiqVn1U2c0kpP8T1JxOjB5q5md0o2fxR6Eic2aGZ4wPQG3GRPjHwbROpEsXJ1qOcbaxD3/XW0LBf8/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715053; c=relaxed/simple;
	bh=khPw7qlwfoC0lZSp8m+MGaMEiEvNSqll0TPuivmuu04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPYp2zO7ffEfkOPhhbra0oGNAO1FanpE2u9t5v27wrdR3DVq2TSPSm2Xwu5/d1oHZPQYRt1cZLMlaMvK5Uowy7tavUOZbXOJmytfl7BivqUk9BdiM81f9RV1KpPnBPx3nN6ZJbZv8gxTqkqnrBvMha/ExtGciGMD72QkO/2u6s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0gUKg/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0gUKg/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A2C4CEEA;
	Mon, 23 Jun 2025 21:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715053;
	bh=khPw7qlwfoC0lZSp8m+MGaMEiEvNSqll0TPuivmuu04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0gUKg/rd87re0IDtp3yPl9Sdqvuha2bYt0TOXdAbFD3s40P6+qCC/GJMFVEG2tW7
	 GCS2TKKbY7q4dbKGKexwJgHodLr6c1ah0viDF5X3ZdXTju73M17Lnaoh1nJIGpGIju
	 wL2Mh4ovFvXF2nQz5c5x2fAqW0Ionabh4gFnJ9hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Collin Funk <collin.funk1@gmail.com>,
	Paul Eggert <eggert@cs.ucla.edu>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 434/592] fs/xattr.c: fix simple_xattr_list()
Date: Mon, 23 Jun 2025 15:06:32 +0200
Message-ID: <20250623130710.759939744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit 800d0b9b6a8b1b354637b4194cc167ad1ce2bdd3 ]

commit 8b0ba61df5a1 ("fs/xattr.c: fix simple_xattr_list to always
include security.* xattrs") failed to reset err after the call to
security_inode_listsecurity(), which returns the length of the
returned xattr name. This results in simple_xattr_list() incorrectly
returning this length even if a POSIX acl is also set on the inode.

Reported-by: Collin Funk <collin.funk1@gmail.com>
Closes: https://lore.kernel.org/selinux/8734ceal7q.fsf@gmail.com/
Reported-by: Paul Eggert <eggert@cs.ucla.edu>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2369561
Fixes: 8b0ba61df5a1 ("fs/xattr.c: fix simple_xattr_list to always include security.* xattrs")

Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Link: https://lore.kernel.org/20250605165116.2063-1-stephen.smalley.work@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index 8ec5b0204bfdc..600ae97969cf2 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1479,6 +1479,7 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 		buffer += err;
 	}
 	remaining_size -= err;
+	err = 0;
 
 	read_lock(&xattrs->lock);
 	for (rbp = rb_first(&xattrs->rb_root); rbp; rbp = rb_next(rbp)) {
-- 
2.39.5



