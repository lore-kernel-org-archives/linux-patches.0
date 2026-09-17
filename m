Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ED94ED195;
	Thu, 17 Sep 2026 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660568; cv=none; b=TK2N+9trbZLTUCdxWvSJDm371G0KmxDmq5KokrdpbO6zK2uWS5NgwiXDwbmZD3C72Ez9O029i0ymJpYBmITCr0KFxGz+Onlsa2xo1/CXHYXxhPxTGqLjhSlkJ+pW1hT54eOCEkRA7ndhXsFJTd8wcih5HQPnf59yDymJKDVg19A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660568; c=relaxed/simple;
	bh=BKMIeqQPj3aeHz3qUr2eZkusFPB6QrTqg/Lkz3ko0bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXetiU8UDLizfWWEIHrAzPlx5unAqON+GJ5Afs07HrRIi9Xyg1+UMW37D/ZtQADRxDIVAqjAIsInJCH41BhPXVAy2dVue+/lZ21us/wfGeTiFuxbYWcJXb6KDaG7IrRRT1pwoSDzTC1DHPIUkYzNLLdcyzIRhPkQfVScwQa44RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygOEoA3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygOEoA3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33061F000FF;
	Thu, 17 Sep 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660567;
	bh=eU9t9mfoKzPUoxVDVtcJg/y1eyTczwM5p/8ZRRfQf6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygOEoA3n2vqhnoueozPaZJmiFTa1cY8myEuMu4OX9laEWhuDkIK2ZC/oBj9uFv6o/
	 b+rP0BYFvMDIYKGz8Zh5FzetKmdyo+s8w2eqmVqzBpas2K8yiC8+zq2To6h1zN8fCP
	 rLYfBFKfFevxqDvidhPFa0IZByIUxGDvfzIxUc9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 636/733] smb: client: fix file type corruption in wsl_to_fattr()
Date: Thu, 17 Sep 2026 16:15:44 +0100
Message-ID: <20260917151408.430024996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit fa7a2cfcf1e6117fc478cae6809c66c518740969 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Clear S_IFMT before the switch statement.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1146,6 +1146,7 @@ static bool wsl_to_fattr(struct cifs_ope
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;


