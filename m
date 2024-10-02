Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478D1D0DFE;
	Wed,  2 Oct 2024 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880334; cv=none; b=CSNblPUfv6QRusMKHbdyQ9oayRZmTTjJ5eXjga7roOSV/PlXHn6oFKxMG7R32Mngf4bEYHJTO0LUN3zjkhItmmw6b3tkLvhavQDMbsWd6GjKYZGR76c0lna2cx3v6Qc2/sn9DJOk+/k/ikafTToUbx1HljU3qi8n6p/sWIt5yQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880334; c=relaxed/simple;
	bh=BjoVYjr3c/V2EYoSRb6fi/TOHnEkn+WHFA7s3Iw2In0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdV6ztziWVkcdncnXi6oVc71NJu8DAZuS1llcJpuuO8YylYZEhB0VEuOAYZaByahTZ16IymU3y2suWzrKfzw2G70nz+xFbyk57hVHAi3sZS7LJeWwXLWbMpA4lI7wnDYB1tC/2KhFCYe4fzTEh/TxLob/b50if0oIdpNggmQzFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOjphti0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOjphti0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C3C4CEC2;
	Wed,  2 Oct 2024 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880334;
	bh=BjoVYjr3c/V2EYoSRb6fi/TOHnEkn+WHFA7s3Iw2In0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOjphti0oohyF06neOFYtlX11t2a1j5p+M+9Kgf91L5Je/dvanoDU47dKItoy4dt2
	 5feALut/cg2uMnZXt9oyM1GPJylpCyfGWgc2TkmSbrCNQnqm9Zkuj95leEuAj/+TBN
	 1SRZudwDrpvZ8iXPMS/E878y25zWy8mkPM9Jw6Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <zhanglei002@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 423/538] ksmbd: handle caseless file creation
Date: Wed,  2 Oct 2024 15:01:02 +0200
Message-ID: <20241002125809.132176859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1162,7 +1162,7 @@ static bool __caseless_lookup(struct dir
 	if (cmp < 0)
 		cmp = strncasecmp((char *)buf->private, name, namlen);
 	if (!cmp) {
-		memcpy((char *)buf->private, name, namlen);
+		memcpy((char *)buf->private, name, buf->used);
 		buf->dirent_count = 1;
 		return false;
 	}
@@ -1230,10 +1230,7 @@ int ksmbd_vfs_kern_path_locked(struct ks
 		char *filepath;
 		size_t path_len, remain_len;
 
-		filepath = kstrdup(name, GFP_KERNEL);
-		if (!filepath)
-			return -ENOMEM;
-
+		filepath = name;
 		path_len = strlen(filepath);
 		remain_len = path_len;
 
@@ -1276,10 +1273,9 @@ int ksmbd_vfs_kern_path_locked(struct ks
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


