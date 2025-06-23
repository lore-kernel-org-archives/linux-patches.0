Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51D51FC0E3;
	Mon, 23 Jun 2025 22:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716551; cv=none; b=OrN98djjFC/qJ7Q3KWoQkSvfB5vvIXXfaUJ1EiGp6obfSlpcZyjwGPN2oS0Fmu73v7B4FDt986jZmVU6dFMzqhhtkmulBqtCeW3MegVD0Wx95WDngD83EASaQ0BoBgwtSEPju3dc6vzIp/gYDGIZuzrPbtMbeBLqwKzAfTFJKCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716551; c=relaxed/simple;
	bh=+yiwIwLNiwMyoBtuCXiNP/Ugwsj1U4lGl6yitWrGjw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMzOhnO9o1VcaJqWxoqOmRcX3ieoOHvpmDxpRqL17Au7RFVdqrfwDJ9tnBKqBC3ZaCOX0l9ONAYE+z4wu95mJ5ddkjBl+nKiMD8Tct9RdhcIZGYK3UTi1gmlsXkS2jPQhqxvfEDejvuSXvIG51jbErLl/mjvs6tCcUfdjvfj4ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUEvTj+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUEvTj+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C949C4CEEA;
	Mon, 23 Jun 2025 22:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716551;
	bh=+yiwIwLNiwMyoBtuCXiNP/Ugwsj1U4lGl6yitWrGjw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUEvTj+C4dDFAkRUaXxAN803XIVH+Mak0mO6klAzXAgk5ScmZ8Zg39S/pQkjqazx+
	 IKe2baK3Vhe32umzCmAlnc08gsX+P4npDGBlcsrCQ0xkuwb81D1jqAl90jvBcaeg1f
	 M2whFgUJx5Y35hE8oIIuzJhkzxng/2HT1Pm6/tXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Collin Funk <collin.funk1@gmail.com>,
	Paul Eggert <eggert@cs.ucla.edu>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/414] fs/xattr.c: fix simple_xattr_list()
Date: Mon, 23 Jun 2025 15:07:05 +0200
Message-ID: <20250623130649.216347688@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index 4f5a45338a83a..0191ac2590e09 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1341,6 +1341,7 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 		buffer += err;
 	}
 	remaining_size -= err;
+	err = 0;
 
 	read_lock(&xattrs->lock);
 	for (rbp = rb_first(&xattrs->rb_root); rbp; rbp = rb_next(rbp)) {
-- 
2.39.5



