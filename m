Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C54258EF0;
	Mon,  1 Dec 2025 11:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588650; cv=none; b=TFucTupeYseifAiA5zxY58O7SQbXjEk08D1uvfgb84wm/2YDbB+4u70b/42TFbaQo7bDn2hvNfdkfOGi2asC6WFQhUZPKFLiIxPhCuidOdvt232l/0V//SFupZTJJ+IeP9byLX9NOini6kFd7gQdm228I4I0UE4pPwecGO529Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588650; c=relaxed/simple;
	bh=O7rnBXFfBVm0q7QzIPLUZKdL83/gDrtxCPtxwWPhTPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVG6sz97b/DpX2OUVnblUTDOabZZGgM7qV3AQFl8Z3a4+lZOi5W9Cu+v6WgY9MrOKPk8QTaF5kmlZyv0zYHWP6RdlmwV+CNwkxj2l67YZ4H2gILd4mrltA00oeCl5Pv5QSEQ0KAYpEGpX52FdMislgJs7ItoLtmX/cvzkChd8i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfkwYC4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfkwYC4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B456C4CEF1;
	Mon,  1 Dec 2025 11:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588650;
	bh=O7rnBXFfBVm0q7QzIPLUZKdL83/gDrtxCPtxwWPhTPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfkwYC4vWPJlRwLlspEu5I6aZUOqKtTImOPp6nrKUe++hN8uiUlYI/7sraPk2BFRo
	 GTYGV0TZU+NMkulZDRmzNZo2ZFsrYC8AOJzELpP9tENtSn9pTg3yOYWO5Tmgb+Kk14
	 ZB8e9ibinO4qn3Uv88WIUHdZRoaeY0RGeMmsXY3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/187] allow finish_no_open(file, ERR_PTR(-E...))
Date: Mon,  1 Dec 2025 12:23:17 +0100
Message-ID: <20251201112244.458018097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f1c2ec6790bb3..2da364e942741 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -886,18 +886,20 @@ EXPORT_SYMBOL(finish_open);
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



