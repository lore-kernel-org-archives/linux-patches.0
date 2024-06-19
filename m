Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4890182495;
	Wed, 19 Jun 2024 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803202; cv=none; b=S6V/WkRh0AuvdrTUXw6DppDPbGE049BQVON3fyLdlWYAOjKV5nJgEbRLsziiePbKe8dJtdGmApLjjeU4076n+rwMbeIUTUYmjsCA/eJQaaM2YQCcF2mx5Y6GGKGk65HNG9MX1oTWzKv8i7bJxOtAkA42WzKaofDHONDgFwXO59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803202; c=relaxed/simple;
	bh=nBpC3t/X2oKLTANyju7Ix3mCrGVwpf5a5t5LMJaCnCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5OIsHQmU+J4+QjIf1MFdaPvC39DSlyxUTdl60CXH2xMlf47r2htAR5urY36gK2oVvB0w3KpoJKdP6LGc7bWp3RDfl0CLkRsw7jf45guJM/9o+sYoxHrOGNMnyRt3zrxHeOjOYyIqyRvAES4Nx//ZIrSRR85PPSxyox2aT1bbHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzgpHKWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzgpHKWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7884C2BBFC;
	Wed, 19 Jun 2024 13:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803202;
	bh=nBpC3t/X2oKLTANyju7Ix3mCrGVwpf5a5t5LMJaCnCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzgpHKWiqeMnxMYSjWOHXNAKhUtoiS8e/FH+8bVk2OyY53VwVAvmGcCuYToigiFnw
	 W8R+A1f9UaQksF2WnMTsO0JgIjzHuUaPbg5pLsM0z3d7476EAe0YbqR9gEixSlPvb3
	 0aZgCwvVls79SHhPSI5Red4KRSOYSmkoUTTMRmOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.9 188/281] ksmbd: move leading slash check to smb2_get_name()
Date: Wed, 19 Jun 2024 14:55:47 +0200
Message-ID: <20240619125617.182043524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


