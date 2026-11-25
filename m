Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625943;
	b=AbwEQUy9XtfYDBPclyoqX8OmNLxEw+dHRYQy4rUPLniMUt00o6RgMNmPpddP7C53A8RR
	 lKvwYDFhwSGeumqJqJPOTCc0NEzd+oKJ5CNulgdfHQkXsSrIaYWumK+hE0Qh9oiOk0T4a
	 lKVGgHjLgui8p1lQlAChkjGTM33d3AwURVGZOL0X+hc1fU4538FuaCqdkV0Bvme56Lh4p
	 usS4on9r0niJUIvZOkiOENxbeo05Z3KBAveQGGr9A65/r6vSP+U9m8LjB8qGgLIb5wPd5
	 /2MpX3m9rbglC/uOcSSxnFfQaUAqCD25ueCXdEw7HAGmGs3igVyIXXNMMrGq5yp0vUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yfZPfVqgCp7AVFkYpHa4+YPtGX3+y57cw0kLEnFlZrc=;
	b=YY4akgglRMlS9E3/ex2BW00aWMwchI0nzeie+so7dFIYrupjzGEWuivjkEDbPE0iBTaB
	 N662OKkQdHxSEffoggYer/FTc9yYLClyCGAYr6aR8tZaLUaf2XXvS+t7YNqhTzL+IpWF0
	 wjgcTw9xnDL0fRy8sNjHBilurWM0ftCBp98GVnqft4O91F6Hu4SDh/hiOqVMxi4dVOD2Z
	 I3tX6bjW77k8UXpwJspQ3+UYN1STaK0dKnYcw/0zbFqWKOJG9WOeMcwlr0jPz6rSY7Jqe
	 3KIG/ldex/aLwR4SAeqLxeCMWNMXJiwr+mz2BJo+WA4CGoGApDvRkprkPlORuUsT+4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iweIg9Kt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53612606A33E;
	Wed, 25 Nov 2026 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iweIg9Kt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564BA1F000C6;
	Wed, 25 Nov 2026 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625942;
	bh=yfZPfVqgCp7AVFkYpHa4+YPtGX3+y57cw0kLEnFlZrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iweIg9KtnZHOhL4kf5K3la+8/QiN1wW0p+AKBEHT837wV7+sHPyfprpJlo7iMpO0K
	 fPrAz5RsKHinDj/4M3Sl5PuF8FZkJR518pJrgxmn2oRWUe2ZNR++hyU4FGE/9nKU+b
	 ZwVNMzaneuIu86mEBP6aXcm5S8Rzqi59LZOiGvxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 680/816] ovl: return EIO if the lowerdata is missing
Date: Wed, 25 Nov 2026 15:37:08 +0100
Message-ID: <20261125143904.921556119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Scrivano <giuseppe@scrivano.org>

commit 0d5e729c515f4ae4eacc179dbcf350d9b499a161 upstream.

The data of a metacopy file that redirects to a data-only layer is
looked up when the file is opened, and the error of the lookup is
returned as is.  If the data file is missing, open() fails with ENOENT
even though the file is there and stat() works.

This can be an integrity problem when using composefs: a data file that
is changed or has the wrong fs-verity digest is reported with EIO, but
a missing one is not reported, the file just looks like it does not
exist, e.g. a configuration file that overrides the defaults.

Return EIO as it is already done in ovl_lookup() when no lower data is
found for a metacopy file.  ENOMEM is not changed.

Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-only layers")
Cc: stable@vger.kernel.org
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1020,6 +1020,14 @@ out:
 out_err:
 	pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=%i)\n",
 			    dentry, err);
+	/*
+	 * The data of a metacopy file is missing or is not a regular file in
+	 * the data-only layers: the layers are corrupted.  Do not return the
+	 * error of the lookup (e.g. ENOENT) to the caller, it would make the
+	 * file look like it does not exist.
+	 */
+	if (err != -ENOMEM)
+		err = -EIO;
 	goto out;
 }
 


