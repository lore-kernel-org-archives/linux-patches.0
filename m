Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AB32FC4E;
	Fri, 24 Nov 2023 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozl4JLaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516C8C433C8;
	Fri, 24 Nov 2023 19:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853122;
	bh=D7TcwqN7qaKmQiVLRSV/crXBDXpxIR0LdJVn+JnUfI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozl4JLaA7llWbcQ03dl+6gF90+utxwW1dG70hQ84jevmTj1QVdz3nVTHKQzIk0hA/
	 uqNDGTelcXY56+mJLcwnz7HJqHdCkIhINSLvZ9uFLrQXjPg9Zu9zj8yO0gax3+fXJ0
	 /xjGJUZgyiIIHkPyxoiS4lvsclw2Elk6da+t/VGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/297] 9p: v9fs_listxattr: fix %s null argument warning
Date: Fri, 24 Nov 2023 17:51:45 +0000
Message-ID: <20231124172002.441724965@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 9b5c6281838fc84683dd99b47302d81fce399918 ]

W=1 warns about null argument to kprintf:
In file included from fs/9p/xattr.c:12:
In function ‘v9fs_xattr_get’,
    inlined from ‘v9fs_listxattr’ at fs/9p/xattr.c:142:9:
include/net/9p/9p.h:55:2: error: ‘%s’ directive argument is null
[-Werror=format-overflow=]
   55 |  _p9_debug(level, __func__, fmt, ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use an empty string instead of :
 - this is ok 9p-wise because p9pdu_vwritef serializes a null string
and an empty string the same way (one '0' word for length)
 - since this degrades the print statements, add new single quotes for
xattr's name delimter (Old: "file = (null)", new: "file = ''")

Link: https://lore.kernel.org/r/20231008060138.517057-1-suhui@nfschina.com
Suggested-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Acked-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20231025103445.1248103-2-asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/xattr.c   | 5 +++--
 net/9p/client.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index ee331845e2c7a..31799ac10e33a 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -73,7 +73,7 @@ ssize_t v9fs_xattr_get(struct dentry *dentry, const char *name,
 	struct p9_fid *fid;
 	int ret;
 
-	p9_debug(P9_DEBUG_VFS, "name = %s value_len = %zu\n",
+	p9_debug(P9_DEBUG_VFS, "name = '%s' value_len = %zu\n",
 		 name, buffer_size);
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
@@ -144,7 +144,8 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
 
 ssize_t v9fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
-	return v9fs_xattr_get(dentry, NULL, buffer, buffer_size);
+	/* Txattrwalk with an empty string lists xattrs instead */
+	return v9fs_xattr_get(dentry, "", buffer, buffer_size);
 }
 
 static int v9fs_xattr_handler_get(const struct xattr_handler *handler,
diff --git a/net/9p/client.c b/net/9p/client.c
index 9fdcaa956c008..ead458486fdcf 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -2020,7 +2020,7 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P,
-		 ">>> TXATTRWALK file_fid %d, attr_fid %d name %s\n",
+		 ">>> TXATTRWALK file_fid %d, attr_fid %d name '%s'\n",
 		 file_fid->fid, attr_fid->fid, attr_name);
 
 	req = p9_client_rpc(clnt, P9_TXATTRWALK, "dds",
-- 
2.42.0



