Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736A43F8DE;
	Tue, 21 Jul 2026 22:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673067; cv=none; b=VngwVpcKTcArcBInK9hrAjwylMkYD7p/VCuh9VO3ArHf1t7EQT3aP3NUrq0NJNtkSsKnqXuT7z/NL7YMO5hujevIQVeNYKUj1yuJde9d7Rx05/ySYk+vgO6K2IsRKzMBkLAqWhn/tCqQ/By8JuvIyHNZ9ZIG7S1bJph0WDgR7e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673067; c=relaxed/simple;
	bh=AzPqEXhivifodqAaF7UfLc9e3Utj4jFUD//gzQTTf40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r31iee8cBcQrtQG1/BSOCtZpG4EjWwu4i8JN5tO3PLsegvB/8qnnCG8ZVSWNZW7xyuGN+aB2E0K9GSSqoe6GgybAzybuznWizTtpu/fdHMp49tE95Wi6JVxtueDH+IpB3wSz2W+imV1s1sA3PeF4Hpe4uecip+U0rOU5qihOyBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDRZQA0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDRZQA0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1E81F000E9;
	Tue, 21 Jul 2026 22:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673066;
	bh=Ka9sTJAqWeNmqB3MydWCke8ORTTOciJngsW/oaBd1Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDRZQA0/Zq8YAvBmln8c7BJkqynnZqHK8lsGU+rI/X60AypOCajC7Dflbr6/7eH+4
	 eTKkILbt7p3QT1vaifeFkdoY0XvVzbo4x+uITg35z71UU4sKXwg+8GnOUssoa5uV39
	 xgKZVa9LICWMbNqTETOrLI/zLbJwg6zEAijOXaPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/699] f2fs: fix listxattr handling of corrupted xattr entries
Date: Tue, 21 Jul 2026 17:16:22 +0200
Message-ID: <20260721152356.218650493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keshav Verma <iganschel@gmail.com>

[ Upstream commit 5ef5bc304f23c3fe255d4936472378dcb74d0e94 ]

Validate the xattr entry before reading its fields in f2fs_listxattr().
Return -EFSCORRUPTED when the entry is outside the valid xattr storage
area instead of returning a successful partial result.

Fixes: 688078e7f36c ("f2fs: fix to avoid memory leakage in f2fs_listxattr")
Cc: stable@kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -575,8 +575,7 @@ ssize_t f2fs_listxattr(struct dentry *de
 	last_base_addr = (void *)base_addr + XATTR_SIZE(inode);
 
 	list_for_each_xattr(entry, base_addr) {
-		const struct xattr_handler *handler =
-			f2fs_xattr_handler(entry->e_name_index);
+		const struct xattr_handler *handler;
 		const char *prefix;
 		size_t prefix_len;
 		size_t size;
@@ -590,6 +589,7 @@ ssize_t f2fs_listxattr(struct dentry *de
 			goto cleanup;
 		}
 
+		handler = f2fs_xattr_handler(entry->e_name_index);
 		if (!handler || (handler->list && !handler->list(dentry)))
 			continue;
 


