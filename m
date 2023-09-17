Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4889253B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0F8C433CA;
	Sun, 17 Sep 2023 19:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979136;
	bh=AUyHjVCGGyvYrmpwiarymqrv5bShwkTp7XeQU7c3Cj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4nK25JYnbIF8eWQQxkt3AhGiAHonf0bk5fOk9b/Le7p6UdekSZABfBpqtb79lVZ+
	 bj7XOaMyiyvy/Nr2HUyvSqf5Xeq0m6ykXp0URJy8G3VQKJ15kiR5KsSJwhTwnsA5rc
	 gZP/wtyezKMc4VRMyFMafBw6HDUQ2xS4IRp8sC9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/406] NFS: Guard against READDIR loop when entry names exceed MAXNAMELEN
Date: Sun, 17 Sep 2023 21:10:53 +0200
Message-ID: <20230917191106.447960929@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit f67b55b6588bcf9316a1e6e8d529100a5aa3ebe6 ]

Commit 64cfca85bacd asserts the only valid return values for
nfs2/3_decode_dirent should not include -ENAMETOOLONG, but for a server
that sends a filename3 which exceeds MAXNAMELEN in a READDIR response the
client's behavior will be to endlessly retry the operation.

We could map -ENAMETOOLONG into -EBADCOOKIE, but that would produce
truncated listings without any error.  The client should return an error
for this case to clearly assert that the server implementation must be
corrected.

Fixes: 64cfca85bacd ("NFS: Return valid errors from nfs2/3_decode_dirent()")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs2xdr.c | 2 +-
 fs/nfs/nfs3xdr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 5e6453e9b3079..b34196da1f945 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -948,7 +948,7 @@ int nfs2_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_filename_inline(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return -EAGAIN;
+		return error == -ENAMETOOLONG ? -ENAMETOOLONG : -EAGAIN;
 
 	/*
 	 * The type (size and byte order) of nfscookie isn't defined in
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index b5a9379b14504..509f32845d7b2 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -1987,7 +1987,7 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_inline_filename3(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return -EAGAIN;
+		return error == -ENAMETOOLONG ? -ENAMETOOLONG : -EAGAIN;
 
 	error = decode_cookie3(xdr, &new_cookie);
 	if (unlikely(error))
-- 
2.40.1



