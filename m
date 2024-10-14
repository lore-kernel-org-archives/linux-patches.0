Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FDA3A1B6;
	Mon, 14 Oct 2024 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918360; cv=none; b=Lv/5xpowbwE5DTC1YNwB37WwKRnwZAKDyT4P7Bw1jGobV1sWMRxkUDi3aZScsWcYtsInw+sy8henVkIVBeXG7vdBdG6ocIXeFxGgbaxEX6Y0FvdrIgBebvJrUzamNYifqobNbvW0UHysg2KkdlCVrbg3K2pDPmBI2hBmHFrimak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918360; c=relaxed/simple;
	bh=DRHz2yyCOGoQnBZpW6jIbkDyPz3lz5axjAV5o2WmqiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvGmrdGHJpgiozxLeVfjWFYkBiApRJZqZqw2/7DWQOE8aotALmFkf2OvvLqFg087ygEfImy5EU+oV5/wUdPu+5QmMWjvJHXJ+vC/95f0o8AQXIHIS9aSSHCZc5WmP2K4W87gMmPFgmNaasw0uYziIRgS+3RuwPH1vxxywBx9KRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1j4rIb5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1j4rIb5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D49C4CEC3;
	Mon, 14 Oct 2024 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918360;
	bh=DRHz2yyCOGoQnBZpW6jIbkDyPz3lz5axjAV5o2WmqiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1j4rIb5xtdzWCXbsC3ENztTp9Pc8CRtv3LrR6bAn+NK5gvedLQsC84HPx+97tNOYH
	 6cmchHil1PIvEPd/T3w7xdbJIbVPPN050Du4sVo+0WVPOBXz162HDEkgAhecMv4lxc
	 rODocZtIv7SVR+DcQObUfLxbs4lkTBsvxWNSqaWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <zhanglei002@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 300/798] ksmbd: handle caseless file creation
Date: Mon, 14 Oct 2024 16:14:14 +0200
Message-ID: <20241014141229.731049032@linuxfoundation.org>
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

commit c5a709f08d40b1a082e44ffcde1aea4d2822ddd5 upstream.

Ray Zhang reported ksmbd can not create file if parent filename is
caseless.

Y:\>mkdir A
Y:\>echo 123 >a\b.txt
The system cannot find the path specified.
Y:\>echo 123 >A\b.txt

This patch convert name obtained by caseless lookup to parent name.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Ray Zhang <zhanglei002@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1154,7 +1154,7 @@ static bool __caseless_lookup(struct dir
 	if (cmp < 0)
 		cmp = strncasecmp((char *)buf->private, name, namlen);
 	if (!cmp) {
-		memcpy((char *)buf->private, name, namlen);
+		memcpy((char *)buf->private, name, buf->used);
 		buf->dirent_count = 1;
 		return false;
 	}
@@ -1220,10 +1220,7 @@ int ksmbd_vfs_kern_path_locked(struct ks
 		char *filepath;
 		size_t path_len, remain_len;
 
-		filepath = kstrdup(name, GFP_KERNEL);
-		if (!filepath)
-			return -ENOMEM;
-
+		filepath = name;
 		path_len = strlen(filepath);
 		remain_len = path_len;
 
@@ -1266,10 +1263,9 @@ int ksmbd_vfs_kern_path_locked(struct ks
 		err = -EINVAL;
 out2:
 		path_put(parent_path);
-out1:
-		kfree(filepath);
 	}
 
+out1:
 	if (!err) {
 		err = mnt_want_write(parent_path->mnt);
 		if (err) {


