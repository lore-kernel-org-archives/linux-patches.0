Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2171D346A0D;
	Wed,  3 Dec 2025 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779363; cv=none; b=aBVULsc3Y4DazfrDtCDTcALeRjyOCsK6Z3IBH38v6W0TAOtAMI5IglzxzeHRH0R+5zs5uOzWHeuSWFfy0s1Gqea+1TyVqvM6hF0QpC+2cJmevVjE/IfjoXb78Q5YK03XqUstmAZKOzjgidBPtJY+rqLX2GtQPBPocTMXthagI3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779363; c=relaxed/simple;
	bh=PnvPypbMy8fijhr/3blDO0zLw3BGeoVgs/kZHYaOOMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUA/GimI3L76dCJ1XQ642HO4dmaGo72weBBhq9m6CY/8Xbm44FH5TMomVCwIuqGD8AWnkPIwJaFgHUPE7Sbkv3SEYZVirFO99r6ub/CjXapeq80kdw5jMwuZHhnbAz4jgECAUYkD5OytDuHdOODqxVAHLT1nqwH2YFUMb91/YvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls6lZS3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls6lZS3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBE0C4CEF5;
	Wed,  3 Dec 2025 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779362;
	bh=PnvPypbMy8fijhr/3blDO0zLw3BGeoVgs/kZHYaOOMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls6lZS3TodWXsxbV4Cafss5up2P9vygn00RmyaO+39FDxDdiO6g18iCmOCpszlvxf
	 8YccIMl/tpvcTbo+Bkx2Gsumn2o8ozaoIBBwVgUavX/0ADzzFFGMPCrGP6WR+/wbAJ
	 qT7FiY1rTUrxAradJQ8xswRN2ROQCQ2iPyN7vtvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/568] allow finish_no_open(file, ERR_PTR(-E...))
Date: Wed,  3 Dec 2025 16:23:57 +0100
Message-ID: <20251203152449.329354124@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2f88454887986..85466cd40c407 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -978,18 +978,20 @@ EXPORT_SYMBOL(finish_open);
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



