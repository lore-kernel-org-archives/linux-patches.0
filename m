Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A84431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBB7C433D2;
	Wed, 15 Mar 2023 12:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883366;
	bh=sOMoDg7RuL5ytTgjGyotfu2FHUmBygWzqcL6SmOR8dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evAWD9ugAOe/hcZSOqSEM20rpgM3qUOJsL+gfAtyrcaY4bleSJr+O6ByOaMVj5tUy
	 HtR4vwsXd4isHnPr/rOUV3oB5/XuO0tlxyStRM47zQZBl3i5pa0tN2joTv6qI4Xbb9
	 NHbjPF+KQ8YlV57ZZwExsv1YDDPS6FoP/zM78KNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 117/145] filelocks: use mount idmapping for setlease permission check
Date: Wed, 15 Mar 2023 13:13:03 +0100
Message-Id: <20230315115742.815173127@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seth Forshee <sforshee@kernel.org>

commit 42d0c4bdf753063b6eec55415003184d3ca24f6e upstream.

A user should be allowed to take out a lease via an idmapped mount if
the fsuid matches the mapped uid of the inode. generic_setlease() is
checking the unmapped inode uid, causing these operations to be denied.

Fix this by comparing against the mapped inode uid instead of the
unmapped uid.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1901,9 +1901,10 @@ int generic_setlease(struct file *filp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	kuid_t uid = i_uid_into_mnt(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!uid_eq(current_fsuid(), uid)) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;


