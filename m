Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787B2561DD;
	Mon, 23 Jun 2025 13:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684912; cv=none; b=Yncf59vclumxYpe1CXeuEfHGviU6852FKao+cw4hBzIcUcm4QeTvHuDSSGOGmvQEBYJRuApzZEw9LU6g5u1HbJoLv9n7wFB8lyv16W8yKfmc4os1EMeXqANKxIaPkkMfUnvPwzSUWkOCPuwDNVg3C3QiOd2359jIlbZ8TSkrNqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684912; c=relaxed/simple;
	bh=gdqXpPATbouehiEPz4KirEfpPya2QS3mg1/w0d0dCNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxNn62yiOoq21DbbrdWrHxhLzP3C7GqU4p2gTzcVKG9uXq7U+8iZ/WgI7vqVDv0Lp8o0g0wfr1IeTvaKVNa11ut98O6kS7MzDepYaFls6519RyAslx8Kk0ByTIrQ1DYUvXryalnKXqv/HiJpPYD9BW/ms2wQw1GE9i7E1OvxEvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoGGZ5JC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoGGZ5JC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E28BC4CEEA;
	Mon, 23 Jun 2025 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684911;
	bh=gdqXpPATbouehiEPz4KirEfpPya2QS3mg1/w0d0dCNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoGGZ5JC4BHEag1gr8awuptxZMntNbup8Ik5bB4NEp7eDRTSvBz0LQMR0ccbRl7yJ
	 jy6lpSmXKbDCxu133A4ubfZjN0T55Q3xBgZv1XyjyhxoT6a4ww5gvTd8BmPLDMT6lL
	 Lk+lHHJh8LZYiFW12OJIy3ZH5rUcVlomkm5xaVMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/355] gfs2: gfs2_create_inode error handling fix
Date: Mon, 23 Jun 2025 15:03:31 +0200
Message-ID: <20250623130627.056982575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit af4044fd0b77e915736527dd83011e46e6415f01 ]

When gfs2_create_inode() finds a directory, make sure to return -EISDIR.

Fixes: 571a4b57975a ("GFS2: bugger off early if O_CREAT open finds a directory")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 22905a076a6a2..f266dec205175 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -636,7 +636,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		if (S_ISDIR(inode->i_mode)) {
 			iput(inode);
-			inode = ERR_PTR(-EISDIR);
+			inode = NULL;
+			error = -EISDIR;
 			goto fail_gunlock;
 		}
 		d_instantiate(dentry, inode);
-- 
2.39.5



