Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06DB1BDC3;
	Mon, 14 Oct 2024 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918462; cv=none; b=jTroo2RrvCox6yniWxBLfkhOD9sJQlAKXFBEq/hTufuekUjz18D+iYxunY4u+vAaePCrvjSJky2Xje1EFBZ/EUZlQXot8BBBJi8fmwB52QYyWEjtSZO5psQGfRYIaLSjjkg85t1dxWq/Tt++6AplIrgu3VeB3Ew2t/gi3RkOnA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918462; c=relaxed/simple;
	bh=UdZ7i8Ko8ecw6x/B8XQ255sc2kZBkKRp5Z0D/A1iGDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE+LSoQMmfKW55Wshx6iR1gK1ebaA7CctPMqA2ANsdbFvol/GEGoypNYslHazmRhVqJzVgNqwbKXSLgJ/YyTqUCUERiV6eo4jtpPJBce8/P9JZfjbAViN3bwy3Ocn+8LtrWx6DpJ7QBedS2VUKQTaLMTjOUYnU1ZWjJRSWGjeu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdStreEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdStreEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5609BC4CEC3;
	Mon, 14 Oct 2024 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918461;
	bh=UdZ7i8Ko8ecw6x/B8XQ255sc2kZBkKRp5Z0D/A1iGDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdStreEBB6F+vE7x9rvJFiNdOF/PUrbGruF5B4nrh7Yw1Vy+oGnhzVKotFMx88837
	 lIqJlcL9UKQBjkRNMa/h+3W91eT53qpLsWR3leUe9IFSxN7i1XdeYCuMaB7QKkr7CK
	 PeJxq9pPcIitBooe0CZcIN9rpTLUtnE2lll4JaSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 299/798] ksmbd: allow write with FILE_APPEND_DATA
Date: Mon, 14 Oct 2024 16:14:13 +0200
Message-ID: <20241014141229.691335785@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 2fb9b5dc80cabcee636a6ccd020740dd925b4580 upstream.

Windows client write with FILE_APPEND_DATA when using git.
ksmbd should allow write it with this flags.

Z:\test>git commit -m "test"
fatal: cannot update the ref 'HEAD': unable to append to
 '.git/logs/HEAD': Bad file descriptor

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -493,7 +493,7 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;


