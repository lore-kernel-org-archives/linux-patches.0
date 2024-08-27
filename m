Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9427B19F485;
	Tue, 27 Aug 2024 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772073; cv=none; b=MqL+zfZ6Bs6RWeZrtXYbCCJ9MKS1CcEA3dqRQyimXBmenzVBYe3B8uoA11HXR0IJjbVFisPMmdHJVxa5Z62faFnLcohOqCBr7GDIdDn4dTqy+kEBe72137UOCkYUG0HZPmwVC7O9b396xDZw+hkVaUKc2kc0u83vKKknPkj3dLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772073; c=relaxed/simple;
	bh=8GSXK5bvTrcI2MRDpUtncSFjzMAYY3mBPLIVQnWDFC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPnHcKX3NOEudobynCfRUhQoyiW0YHeYbLH4005e2aQkc0BwCYpcPZQt+qLdKrbuoGp+IPVBX85k5Wd82qgNiyPwKSHk1+y0Xf3wPq5QskD9gc4J42ZikcO57Hkq2pwiEvCpKY1RsP33yB+J1uSegzUUv5ai6SlfnwT8R5VjHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnrHNC5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnrHNC5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D63C4FE02;
	Tue, 27 Aug 2024 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772073;
	bh=8GSXK5bvTrcI2MRDpUtncSFjzMAYY3mBPLIVQnWDFC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnrHNC5nGLLlVTOCUEiQytBjaF7VcVoLVonCs4w5Zh/zF9Oql2IDbU1E2M5eVM8yP
	 jA3ToX1ZGJoSoiqmhVP39C37RYTSfXLn8t0jVcVQGbGNNNLHMqb+kriLJ+BWpbpCly
	 al+LN0hcTAdfO+AYaxGJwGJOLKwb3eMpRbkLCAP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhong <floridsleeves@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/321] ext4: check the return value of ext4_xattr_inode_dec_ref()
Date: Tue, 27 Aug 2024 16:36:21 +0200
Message-ID: <20240827143841.021226101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <floridsleeves@gmail.com>

[ Upstream commit 56d0d0b9289dae041becc7ee6bd966a00dd610e0 ]

Check the return value of ext4_xattr_inode_dec_ref(), which could
return error code and need to be warned.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
Link: https://lore.kernel.org/r/20220917002816.3804400-1-floridsleeves@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index f0a45d3ec4ebb..0df0a3ecba37a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1550,7 +1550,8 @@ static int ext4_xattr_inode_lookup_create(handle_t *handle, struct inode *inode,
 
 	err = ext4_xattr_inode_write(handle, ea_inode, value, value_len);
 	if (err) {
-		ext4_xattr_inode_dec_ref(handle, ea_inode);
+		if (ext4_xattr_inode_dec_ref(handle, ea_inode))
+			ext4_warning_inode(ea_inode, "cleanup dec ref error %d", err);
 		iput(ea_inode);
 		return err;
 	}
-- 
2.43.0



