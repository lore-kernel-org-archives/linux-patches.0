Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5A4315A;
	Mon, 23 Jun 2025 21:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714948; cv=none; b=SaE0Jv4cAB6xCIwc2Nn15/Ex01Qp9V5eg1fqzs7npegye7ADqd8dD2x/9jcaDZtZ2ylXtbGZIcMkf06LX3mbx6OHeXlnurHPfJ21Zi5bl8WWs02nC8Xs873P7zWQKfa4veX9VBsvaUVDRDLjxFZmCGV5XkFc6fXB82f4Bjik5+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714948; c=relaxed/simple;
	bh=sML0BeunbdRebnl/6289ymJwidDXJQcxr2wQcN5OvL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq01Mqh1feXDkTpRzpINazZai4Bz6HyyAnWwGcBkSA3ut/DF15my68zsVQ0TA+cY45VdjAZht4wCnS/UF3FXsafV2uM5PsS24RtAMRYvsrT95NKtjpkHs6WsLAH+COPfCnmKSql/gRXBFlFrudB+Lkoye/ikJ3h/jI/R0jkfSz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmm+9K0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmm+9K0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3371EC4CEEA;
	Mon, 23 Jun 2025 21:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714948;
	bh=sML0BeunbdRebnl/6289ymJwidDXJQcxr2wQcN5OvL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmm+9K0L1cubaKMYnF3AhqwnjjdXej7lX+9W2iLK7n2h2FkEq84TGzm0W0UhRSizO
	 4XUI3piKTC3TDwkYuGWWRfVvnQnoXIZF9Ey7enjQB49EVawKMu2DqieeCgNTZO/qY6
	 bttUrqqswugsvgoXQ/r40trV/xjBqhjmDoLVN4Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruben Devos <devosruben6@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 146/414] smb: client: add NULL check in automount_fullpath
Date: Mon, 23 Jun 2025 15:04:43 +0200
Message-ID: <20250623130645.702208127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruben Devos <devosruben6@gmail.com>

commit f1e7a277a1736e12cc4bd6d93b8a5c439b8ca20c upstream.

page is checked for null in __build_path_from_dentry_optional_prefix
when tcon->origin_fullpath is not set. However, the check is missing when
it is set.
Add a check to prevent a potential NULL pointer dereference.

Signed-off-by: Ruben Devos <devosruben6@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -146,6 +146,9 @@ static char *automount_fullpath(struct d
 	}
 	spin_unlock(&tcon->tc_lock);
 
+	if (unlikely(!page))
+		return ERR_PTR(-ENOMEM);
+
 	s = dentry_path_raw(dentry, page, PATH_MAX);
 	if (IS_ERR(s))
 		return s;


