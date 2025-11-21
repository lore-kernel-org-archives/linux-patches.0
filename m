Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7AD34DB5D;
	Fri, 21 Nov 2025 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732892; cv=none; b=I9dK1sdJxklFTIeatjlG3q2u0khtyLT9wH1rHa6p3p+gR/+y06JEtMBtTRBSEYIB/iRGzmOOWZp6MHVv52nAZgRyZTyNo9Pmb+4yBt4xUYQleWVcsijJRDW8XzyBQkbNNlAncB2jTuSv4re6doDhnsrbI0JrHINngV1GDym75iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732892; c=relaxed/simple;
	bh=/da1giYfOU6iSWhddreiLnMPUcuPDK6NL24qT5lKbyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZY0yfZsMJLD7YDGokLOjl/X8NlZkqGqpRmD8PKkkE2b5JUcSGBv6AplX9kY4tlP5prIydnmDLL6SPuTBp6AIwCiBe5gU5w4zUB4kDBSA2lopJGuvNnR0anvcMU4rYnSt24/eRMWA9Yt8c7TlO63fBeBdEPgU7wpcSHjSGD6jcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkloN7vY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkloN7vY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC3BC4CEFB;
	Fri, 21 Nov 2025 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732892;
	bh=/da1giYfOU6iSWhddreiLnMPUcuPDK6NL24qT5lKbyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkloN7vYPjoeqYdmdTQj54T/hFM6Mqw6He9thxtyn4jUmNjWHoia9lZd6T4NGy0nf
	 qSyJ822vO/jbaDjM7SOL+B44tKlXL5XQ86tO7NYtbJ/F3AUP2oH0D7iqcHg4qXtt9Z
	 ZcaYDkFhRb6mhbP/1He7QwOzl9KvPEdC5wjipUkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/529] allow finish_no_open(file, ERR_PTR(-E...))
Date: Fri, 21 Nov 2025 14:09:05 +0100
Message-ID: <20251121130239.771721794@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fe91e078b60d1beabf5cef4a37c848457a6d2dfb ]

... allowing any ->lookup() return value to be passed to it.

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f9ac703ec1b2d..b5ea1dcbfb224 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1029,18 +1029,20 @@ EXPORT_SYMBOL(finish_open);
  * finish_no_open - finish ->atomic_open() without opening the file
  *
  * @file: file pointer
- * @dentry: dentry or NULL (as returned from ->lookup())
+ * @dentry: dentry, ERR_PTR(-E...) or NULL (as returned from ->lookup())
  *
- * This can be used to set the result of a successful lookup in ->atomic_open().
+ * This can be used to set the result of a lookup in ->atomic_open().
  *
  * NB: unlike finish_open() this function does consume the dentry reference and
  * the caller need not dput() it.
  *
- * Returns "0" which must be the return value of ->atomic_open() after having
- * called this function.
+ * Returns 0 or -E..., which must be the return value of ->atomic_open() after
+ * having called this function.
  */
 int finish_no_open(struct file *file, struct dentry *dentry)
 {
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 	file->f_path.dentry = dentry;
 	return 0;
 }
-- 
2.51.0



