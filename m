Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4FB144D3E;
	Wed, 19 Jun 2024 13:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802371; cv=none; b=NhTHxpPrRKitI1Rcb047+pnm2HZ6ehZYuQSsy24vv1rIa5Sq8IzDCtzRd+BR6he20fbvfqsMJX4b+at0JU+RTyqtJA7Bsg746YzmPtdesWpwlOcoMVqS4idfGZ3Gt++p7LDbcE/0CBcTvJvfuLebOVNQR9rzRP1bRUDs4wmh5H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802371; c=relaxed/simple;
	bh=eEgx1OU6qF3kYyYzMAvUVC7woKHur7dtGllThj/Fchs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ISdDuXvWfT4GbGBL0NAE125siyABEiFKi4KFscs9Ak+Qe+TcCJ4ir+jwupggDUT4BZblfRB+v5pBz1z56LHZrOxGg3GxZomAJKDWPoXChAN/MF2PylN418PTV5RTvVVJp79Aluuf0+nXyrfN1m1KazvbO52wf7958y0U7scZ7rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18+P5kmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18+P5kmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136F4C32786;
	Wed, 19 Jun 2024 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802370;
	bh=eEgx1OU6qF3kYyYzMAvUVC7woKHur7dtGllThj/Fchs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18+P5kmq7zy6QjkbvmHW8yc6TVqPDHezhJEBnelvmGHjoM+A2YKWXHyoFGLtG0dGS
	 1vp3fBJFBWidp+Y2ex4DJwUb0NDNMDs6zLGyvM1JNfsmbAz0BX8rgzbywWrU/Ff144
	 S1BtkgB4mWJ9SX6u9IRQlloWLtIOK6cw0K2XTVsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 173/267] ksmbd: move leading slash check to smb2_get_name()
Date: Wed, 19 Jun 2024 14:55:24 +0200
Message-ID: <20240619125612.982076870@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 1cdeca6a7264021e20157de0baf7880ff0ced822 upstream.

If the directory name in the root of the share starts with
character like 镜(0x955c) or Ṝ(0x1e5c), it (and anything inside)
cannot be accessed. The leading slash check must be checked after
converting unicode to nls string.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -630,6 +630,12 @@ smb2_get_name(const char *src, const int
 		return name;
 	}
 
+	if (*name == '\\') {
+		pr_err("not allow directory name included leading slash\n");
+		kfree(name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	ksmbd_conv_path_to_unix(name);
 	ksmbd_strip_last_slash(name);
 	return name;
@@ -2842,20 +2848,11 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (req->NameLength) {
-		if ((req->CreateOptions & FILE_DIRECTORY_FILE_LE) &&
-		    *(char *)req->Buffer == '\\') {
-			pr_err("not allow directory name included leading slash\n");
-			rc = -EINVAL;
-			goto err_out2;
-		}
-
 		name = smb2_get_name((char *)req + le16_to_cpu(req->NameOffset),
 				     le16_to_cpu(req->NameLength),
 				     work->conn->local_nls);
 		if (IS_ERR(name)) {
 			rc = PTR_ERR(name);
-			if (rc != -ENOMEM)
-				rc = -ENOENT;
 			name = NULL;
 			goto err_out2;
 		}


