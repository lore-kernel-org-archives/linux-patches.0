Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684DC7469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6210C433C7;
	Sun, 17 Sep 2023 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982370;
	bh=h2eLt1D/zzuoFf+J9tdvCnuisT87RWks9kESjzWNxGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylxz+DH9XN/sXJqlyGbRbSn0cN063mk0XEeUDo+BZGBlQmHdQSkDrJINh3jLn0l6a
	 P/pt6h+DKh0VDB4JXRVwZC4hDnFQsCyBAayRSJrEe7vYK77wOx3yFXu7QBf/8ek/VY
	 cbEiO9K8GJdeQaH5GSSyKcKu3WEHaJzvG732PWII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/511] NFS: Guard against READDIR loop when entry names exceed MAXNAMELEN
Date: Sun, 17 Sep 2023 21:10:58 +0200
Message-ID: <20230917191119.387182425@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3d5ba43f44bb6..266a4badf1dfc 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -949,7 +949,7 @@ int nfs2_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_filename_inline(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return -EAGAIN;
+		return error == -ENAMETOOLONG ? -ENAMETOOLONG : -EAGAIN;
 
 	/*
 	 * The type (size and byte order) of nfscookie isn't defined in
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 7ab60ad98776f..d48db2f6f4f02 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -1990,7 +1990,7 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_inline_filename3(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return -EAGAIN;
+		return error == -ENAMETOOLONG ? -ENAMETOOLONG : -EAGAIN;
 
 	error = decode_cookie3(xdr, &new_cookie);
 	if (unlikely(error))
-- 
2.40.1



