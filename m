Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B68530E823;
	Fri, 21 Nov 2025 13:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731772; cv=none; b=ZmpzWWWLmoVX6VrxbODPy4ouNulomx7jPLLRD/23jPcpRVt0T2I6DcPnWlqF2Styg19mK5scfGIRbHFieF7LgURILYn5eMSrLpMEPBP/wmT6l05t8Ed5V03L41Vz1rrVlJViVWOpeZmqsaJoqtchGwnvugSNASIAvhsW3sX5aiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731772; c=relaxed/simple;
	bh=6cdX7MvT5shOQz9aJocBvZ7su3dmIzy/o4N9Mfpw02A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psMgv5tnmO9JJp+RnGtayRLvCpwZJqcDkDSUUEasdjPX+Cod8YlN96ZdA+U/xq07bi56xRhErKlxEF2F6JNIG7Ogpn3B7Hla0NX1n2YFlaH4FNvLH5BTp0jQvFNB2pth/EuF8rQXuvjFC4lRmpgNU47L1Z1Ywkqf9CHSV/pKR7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEozNRCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEozNRCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA700C4CEF1;
	Fri, 21 Nov 2025 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731772;
	bh=6cdX7MvT5shOQz9aJocBvZ7su3dmIzy/o4N9Mfpw02A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEozNRCkraMwrk16nUKJsS6cAEaI9aaUUH32z9NMSCxaowtWKvYAz2mLlcYKL837t
	 M1QFXpze7/7pxXQjYe+E02+z9GzE264qSYOnXQaNMtzUi87LLDCcRxFRk1YS8WbnQP
	 BW5XPp4CH4kPO2aeg+JCDhxAywaWzs63Xb1loy6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/185] simplify nfs_atomic_open_v23()
Date: Fri, 21 Nov 2025 14:11:42 +0100
Message-ID: <20251121130146.579366493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit aae9db5739164353fa1894db000fabad940a835b ]

1) finish_no_open() takes ERR_PTR() as dentry now.
2) caller of ->atomic_open() will call d_lookup_done() itself, no
need to do it here.

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 85d2c2392ac6 ("NFSv2/v3: Fix error handling in nfs_atomic_open_v23()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index bbc625e742aa3..c05c737ac5282 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2270,7 +2270,7 @@ int nfs_atomic_open_v23(struct inode *dir, struct dentry *dentry,
 			struct file *file, unsigned int open_flags,
 			umode_t mode)
 {
-
+	struct dentry *res = NULL;
 	/* Same as look+open from lookup_open(), but with different O_TRUNC
 	 * handling.
 	 */
@@ -2285,21 +2285,15 @@ int nfs_atomic_open_v23(struct inode *dir, struct dentry *dentry,
 		if (error)
 			return error;
 		return finish_open(file, dentry, NULL);
-	} else if (d_in_lookup(dentry)) {
+	}
+	if (d_in_lookup(dentry)) {
 		/* The only flags nfs_lookup considers are
 		 * LOOKUP_EXCL and LOOKUP_RENAME_TARGET, and
 		 * we want those to be zero so the lookup isn't skipped.
 		 */
-		struct dentry *res = nfs_lookup(dir, dentry, 0);
-
-		d_lookup_done(dentry);
-		if (unlikely(res)) {
-			if (IS_ERR(res))
-				return PTR_ERR(res);
-			return finish_no_open(file, res);
-		}
+		res = nfs_lookup(dir, dentry, 0);
 	}
-	return finish_no_open(file, NULL);
+	return finish_no_open(file, res);
 
 }
 EXPORT_SYMBOL_GPL(nfs_atomic_open_v23);
-- 
2.51.0



