Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926DA1D0797;
	Wed,  2 Oct 2024 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878791; cv=none; b=VAJaTOvQgo26nr4xsvpy2A5BnR2Kxof40xnXM2Q+jb8N19koQihrPraUAb/LFS0Rbyj22YQblJOhIEojtK3UJQKmCBpjwRefUwtisoAjyAdv54MEx0cFkjoji0SP2XLI1/aSf8vDj/j4RfNjjwafCsvvQYGvv9qK7K2F5602pkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878791; c=relaxed/simple;
	bh=tlI8aBOEYpuAIOWPvnx10rFEriv+LQqKin2CmqygttM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY3Hn1r3MJDmsTY9DtMUW3PvDcnWRuXQUOd7/naaCUDjpT0OtO3Fwb1fkECANtgiKzGkIj2q+nd/NldBtkxS8p8AwqlM1wkFGMKxrcIm2co4Pj6c1G8Vu0mQypzut6m2BDdZAHNvAuytdW+HPjiuk5XkFs8Ovz83LizZPdFN6x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7Iud/lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7Iud/lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C7C4CEC2;
	Wed,  2 Oct 2024 14:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878791;
	bh=tlI8aBOEYpuAIOWPvnx10rFEriv+LQqKin2CmqygttM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7Iud/ljuJ1yB79vkP+iwUFvfg0JbKVv0+M/uoS+j9Uul/Zwk4sR/s/J0WLK4PUip
	 0YIL7TmhBujE0F6y6c2z0m1MoIww/XeQEGDPXoSiQsnX3UgvEB550OhGGCkxjrFH+m
	 mXCtmcTnM6TgUQ9t4eBo3iKyOkEbg9CTTaV6s0Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <zhanglei002@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 506/634] ksmbd: handle caseless file creation
Date: Wed,  2 Oct 2024 15:00:06 +0200
Message-ID: <20241002125831.077170569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1167,7 +1167,7 @@ static bool __caseless_lookup(struct dir
 	if (cmp < 0)
 		cmp = strncasecmp((char *)buf->private, name, namlen);
 	if (!cmp) {
-		memcpy((char *)buf->private, name, namlen);
+		memcpy((char *)buf->private, name, buf->used);
 		buf->dirent_count = 1;
 		return false;
 	}
@@ -1235,10 +1235,7 @@ int ksmbd_vfs_kern_path_locked(struct ks
 		char *filepath;
 		size_t path_len, remain_len;
 
-		filepath = kstrdup(name, GFP_KERNEL);
-		if (!filepath)
-			return -ENOMEM;
-
+		filepath = name;
 		path_len = strlen(filepath);
 		remain_len = path_len;
 
@@ -1281,10 +1278,9 @@ int ksmbd_vfs_kern_path_locked(struct ks
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


