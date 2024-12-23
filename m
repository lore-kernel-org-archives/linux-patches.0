Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020CC13BC0C;
	Mon, 23 Dec 2024 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970173; cv=none; b=UdoyKVwGCCH7m6f+1xteNpXIcrfD5PjqGuYybBfVJVMrplGQfPGig4MyDv1Z0xORJpzZYuC5LArqAFBi9mok63wmzmaypaD853biK+uLZi16Tz5H6s3KZqJoowa/2kTFy+/pCRbTvoCyidX58/cmKdjNi8V/VWdgnKOIPSqYfy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970173; c=relaxed/simple;
	bh=TREnlopG9E78IQuC1ZDbtk8+7fP1gj6ptCkVXKAq70w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHN1+7b2n+OC1I9AkYvKXJMMIDNK/YKHrQR7MW0s1FMoVVnpz+zE8TZU/4QTAMchctqglNcnlOocgFTeTnavqULgIJ1eFW3azo2cEZ4LXZ4qyPk7zGDGZVpf5kBglsKEKc6zaAhJqRXgrFCqTCS2wrERJb7bBgpjz2E7qGjGD0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9XG7JsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9XG7JsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64242C4CED3;
	Mon, 23 Dec 2024 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970172;
	bh=TREnlopG9E78IQuC1ZDbtk8+7fP1gj6ptCkVXKAq70w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9XG7JsIYb5V/+WSovqdstf2VXGpmkBp4sHMAzZJ4pStPI1TgIPUzq4bujVbhkjWY
	 ZqMmjnuRaKn420L2afhe02fkLPHOudluzOEk4R5AdfmGXb2xYpG7lJH7WD1xMs1mug
	 A5PYslGS6BmvkJXE5fsYw+wt10CzrbFIOFORSsE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.12 152/160] ceph: validate snapdirname option length when mounting
Date: Mon, 23 Dec 2024 16:59:23 +0100
Message-ID: <20241223155414.688078976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 12eb22a5a609421b380c3c6ca887474fb2089b2c upstream.

It becomes a path component, so it shouldn't exceed NAME_MAX
characters.  This was hardened in commit c152737be22b ("ceph: Use
strscpy() instead of strcpy() in __get_snap_name()"), but no actual
check was put in place.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -431,6 +431,8 @@ static int ceph_parse_mount_param(struct
 
 	switch (token) {
 	case Opt_snapdirname:
+		if (strlen(param->string) > NAME_MAX)
+			return invalfc(fc, "snapdirname too long");
 		kfree(fsopt->snapdir_name);
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;


