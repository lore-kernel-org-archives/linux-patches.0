Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E390A21E085;
	Thu, 12 Dec 2024 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021602; cv=none; b=LAe1U8Qd5S8pgCdujUSSqREP4HgNMhZc6qQ+yaPMbctFWJP49cIayfaxj1/W0G1GnHiDL6zW/9inkKK3Phz7Fr3hvTZZuXGpSbxdBEiWuBMBakjxtCNvsdsqVGH3iVSIGleTSN2Ale3LVOBfL8HFeNGkJvR0J341O080ZVzdvvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021602; c=relaxed/simple;
	bh=Pt7doevFowC5P5F95xzOJ46GdLaUhFx2vsS+RkGq9PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NACfLlOdgUr9gLeDcgsNJNamkLoVRUB81F6pooaejYZwGW2Ivc/zSsQTaIxS0skUINY8+qXkB0RR2blTTcQWm+zdd04YYfMZlJ1fmxBMODdBPoeMJy8MGBQEuidi0VwtdMmMMRz+5Q8OLKf6oaSOooG90JTvBAqVYcdYPYrPBQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXjAnaLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXjAnaLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B92C4CECE;
	Thu, 12 Dec 2024 16:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021601;
	bh=Pt7doevFowC5P5F95xzOJ46GdLaUhFx2vsS+RkGq9PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXjAnaLIqq6W33FuEjbJrBhUcfWoezooMaeXcjVrYA1Qyv2vonM31O0QughzeGkfT
	 8IfDEInJkQos39HcUggGB032AJpbtPg3bEKiES9rKtHF611qsqcOa7Yl/pZRludXBO
	 sQ3ouVb0R+lOYRWQHLn3977NknVpPSK9wDpnoAYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.15 011/565] ovl: Filter invalid inodes with missing lookup function
Date: Thu, 12 Dec 2024 15:53:26 +0100
Message-ID: <20241212144311.897359277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


