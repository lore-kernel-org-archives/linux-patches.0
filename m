Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6E01D041D;
	Wed,  2 Oct 2024 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876805; cv=none; b=m1Za+qyZ9jWjs8R4rRFoL9B8ZMehtPMfJGlh4CIOGDCnSDlfJrygViCeX+EYygeb74aW6rAy75RAgviGwrJQp5icvjcZ+NkTs6TXXIX6iqhctycGMVR5fpZl1wYZDAqTAPoym094BOgZLvdS3mg929KJl9iFlJ9eir5IjDuv4U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876805; c=relaxed/simple;
	bh=ut43l1CmkYj9ZUpG5WzOfYgsRd2vt5sLNkgo6X0sEWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffT+4KjlVvWV01P5yJKGGtMvd7cIcQ6Q8kNvg48CUnD/Z7ggVd8ypmoUC1HFrR9XhAcqwmNi/l9gyjAW1e6vDrnm4eCbEIcmc2ivZ54UOPfVK4otkB66EVGlxN5SXQl3dXIuT+Hg2yYtzCeXetNWzttfhCcalKEpOoJwaENhYAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lomjZbiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lomjZbiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A07C4CECD;
	Wed,  2 Oct 2024 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876805;
	bh=ut43l1CmkYj9ZUpG5WzOfYgsRd2vt5sLNkgo6X0sEWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lomjZbiYoG80K0e+09RF1iI8Ke7pU4ZgryHwFJh65UU9hbe1FVQ5OWUgg/n7MbwQo
	 gNAIPhHOMyYHJqdcQQAYLM/jDnfva+1bFwWcNky3FVjks42e0VGaMPCjB5GJDLPqKs
	 BYIEgHqF4+jPgFM+w5zUwI/Sq+TjT5zhezc2fkOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <zhanglei002@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 568/695] ksmbd: handle caseless file creation
Date: Wed,  2 Oct 2024 14:59:26 +0200
Message-ID: <20241002125845.180254489@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


