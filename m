Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475B81DD0C7;
	Mon, 23 Jun 2025 21:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715455; cv=none; b=B97WH9ccpBLhhb6sA/vSelReyc3naIZTpQ6TLy+Vt9+ESGqrEJGmwq/mK93ECwip5IxHNc5sOZ9PVxyO9aWnrIy8w7zbWqTj9Se7uuMYoRmPB4SZS+IidgFxmwiucCofub+PaDQH7WvSaRYqu8qCkXCOM2uTdE53hRIOgPJYw00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715455; c=relaxed/simple;
	bh=m5mgpvNGsE6eL1ivqtDsG5u5Kw+0hx81mXE9qC56XBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM/MwX2bYyg9Kk9hCX4bqmVs4yrvjm+JaxXUjxNPEqvlMUOk3fd7Gw2/29EZI1XP+InAN/jbOAsGdesM48bxR8p5NDN46VtKfgde/U/s4JtpqByupaS71VY8cb/ZM9ful+odiNF974G+MVedhRcPhUkPNJd+lCh3DU2xwapCx1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYWZoKdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYWZoKdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3955C4CEEA;
	Mon, 23 Jun 2025 21:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715455;
	bh=m5mgpvNGsE6eL1ivqtDsG5u5Kw+0hx81mXE9qC56XBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYWZoKdwJhwgIcpTrwkGSxO+CrkWUXzHHMH4M/1ZcZcoboEfSGSJ82vYM3jK7DwyZ
	 2rh22NLT2z43efj17K/fAiLSFuGGZ7gggyMNVYesuUbKx846LHHpC0RFqpq2D2IKv6
	 U+LhNg9ouCAhHSmf3L0BKcKg+z/3eh2p/EncIHaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Collin Funk <collin.funk1@gmail.com>,
	Paul Eggert <eggert@cs.ucla.edu>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/290] fs/xattr.c: fix simple_xattr_list()
Date: Mon, 23 Jun 2025 15:07:41 +0200
Message-ID: <20250623130632.953568760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fed22c22a2be..7574d24b982ef 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1342,6 +1342,7 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 		buffer += err;
 	}
 	remaining_size -= err;
+	err = 0;
 
 	read_lock(&xattrs->lock);
 	for (rbp = rb_first(&xattrs->rb_root); rbp; rbp = rb_next(rbp)) {
-- 
2.39.5



