Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A142248BD4;
	Wed, 15 Jan 2025 10:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938649; cv=none; b=awhKOo4VeUYc0xncBMqVQwUug915tgP37v4ax7TW1woVQAty98KBWERqRQvSu9UEE9rxbiW9adGg5gSGsBxuuGetHKpbQGY66bwPk+op8gEXr89BC5LHxzk7nSmNtW4egkmvqT+uswuf/71pBoaQLjwCC2TJ1RLvBvozavhnIx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938649; c=relaxed/simple;
	bh=bV0pBLt33rDG74QHg/Fs1vSGiHp0BA0VL27DHO61Q6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPbkOB0ZR209ie3pXgOM4SRTQOXMaXo5LN+E/nydu0gZbp3NBdq6IA5aMm73qgieJDMo+1eQkxZ045aBn6fJV7lJ97PaNJycPs/gzXefkMSKW2nEz8MUb13I/iJV4SntoIE7VGulG2e7/sVZhIcGclysOg92L0bFtB837vnGUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlSrMuqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlSrMuqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7D3C4CEDF;
	Wed, 15 Jan 2025 10:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938649;
	bh=bV0pBLt33rDG74QHg/Fs1vSGiHp0BA0VL27DHO61Q6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlSrMuqMUT3tDU1WT8hIrCpYc4J9dfE4mO5oiF9tGpcG6DHQeea/F4ogZiHOmrtDe
	 Oyaz8FG8AddoF/6rvFcutmOjxr6h+3u1E6shsFNO3urY9p+hk8ykO9bvDKr4SS91Pk
	 YKmmlsis1fBD2Uhgmwj7Ix21QLKQcBXhbxoePEgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Wang <xw897002528@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/129] ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked
Date: Wed, 15 Jan 2025 11:37:10 +0100
Message-ID: <20250115103556.562294648@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: He Wang <xw897002528@gmail.com>

[ Upstream commit 2ac538e40278a2c0c051cca81bcaafc547d61372 ]

When `ksmbd_vfs_kern_path_locked` met an error and it is not the last
entry, it will exit without restoring changed path buffer. But later this
buffer may be used as the filename for creation.

Fixes: c5a709f08d40 ("ksmbd: handle caseless file creation")
Signed-off-by: He Wang <xw897002528@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 2c548e8efef0..d0c19ad9d014 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1259,6 +1259,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 					      filepath,
 					      flags,
 					      path);
+			if (!is_last)
+				next[0] = '/';
 			if (err)
 				goto out2;
 			else if (is_last)
@@ -1266,7 +1268,6 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			path_put(parent_path);
 			*parent_path = *path;
 
-			next[0] = '/';
 			remain_len -= filename_len + 1;
 		}
 
-- 
2.39.5



