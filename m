Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C862253F8;
	Thu, 12 Dec 2024 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020452; cv=none; b=TCRcUJO+SqJyd9A0eS3Swkra6pyXWlgCxzkrWJxl8DVuoR8zoHs2AKlV30hyIJ5zZljgCBEuXRuKoNxIg/rR/oZBJgVqg9xfKcLIA4Cxcbo0AwnsZW8JCd9sznPXWBlHgFV2bSmCLtWWWOD8FZ9dPlDWINXnp0BRk/+Gd0Snhmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020452; c=relaxed/simple;
	bh=/IfA3IhbYBLjrDRxQzJExwo3Ack1TqGd2yPsJd5Dw4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYYoi8WbgxUxqK7US+7IkvsOXLme9N40VP1G7O5/P81R9fJ4t0K/npyH6xeFSDv0h3pXAunnYSKcai9Q1thmEgw6Z9zdzyHKEbSeqo0fYJQ6PkN98KpuM9ntfO7j5c4O5PsGqx+rtEPV8IWskfzCK/iype273O5Qws43oAKV7u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2HAyt2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2HAyt2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124A8C4CED0;
	Thu, 12 Dec 2024 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020452;
	bh=/IfA3IhbYBLjrDRxQzJExwo3Ack1TqGd2yPsJd5Dw4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2HAyt2Fh27fhgZvcWazn00lVddlyN0BGhxtDNlGLqX7heqXvK/xMHxahLbvvhYQS
	 0gYUJaFFl/HAsRU2a+JY9KURUDYpNQ75fZovgc3YHwyDHfGPz+gjjR7kQQvubhq5vH
	 d7Fqk5gQEpt0ChZAPyxn/tv6h9J3gfAgdNUm5+kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 471/772] ovl: Filter invalid inodes with missing lookup function
Date: Thu, 12 Dec 2024 15:56:56 +0100
Message-ID: <20241212144409.395970824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit c8b359dddb418c60df1a69beea01d1b3322bfe83 upstream.

Add a check to the ovl_dentry_weird() function to prevent the
processing of directory inodes that lack the lookup function.
This is important because such inodes can cause errors in overlayfs
when passed to the lowerstack.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-unionfs/CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com/
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -135,6 +135,9 @@ void ovl_dentry_init_flags(struct dentry
 
 bool ovl_dentry_weird(struct dentry *dentry)
 {
+	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
+		return true;
+
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
 				  DCACHE_MANAGE_TRANSIT |
 				  DCACHE_OP_HASH |


