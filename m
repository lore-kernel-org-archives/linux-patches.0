Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C80C433EF;
	Wed, 28 Dec 2022 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246433;
	bh=7IIzYPatVpJ1/OeMVQGZU8F5NDKYw7ZWcrAoaEZRkWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEhYYqW/N7oBAgIHnTYg/HOI7cSxIMjw+xuGRUxXa384aGqKOdNHEfzN49BMzZoj2
	 /bH1skyqz+umYkA8kNhnmdoodliDBY7KxWpLkbQFq9AChoMTiLNOVKLh9aPUCD/mjo
	 wFwNPb24RbB4LogXTLaLHG6O/WYa/VHRX5HwBd/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 1071/1073] cifs: Fix xid leak in cifs_get_file_info_unix()
Date: Wed, 28 Dec 2022 15:44:19 +0100
Message-Id: <20221228144357.330886620@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 10269f13257d4eb6061d09ccce61666316df9838 upstream.

If stardup the symlink target failed, should free the xid,
otherwise the xid will be leaked.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -368,8 +368,10 @@ cifs_get_file_info_unix(struct file *fil
 
 	if (cfile->symlink_target) {
 		fattr.cf_symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
-		if (!fattr.cf_symlink_target)
-			return -ENOMEM;
+		if (!fattr.cf_symlink_target) {
+			rc = -ENOMEM;
+			goto cifs_gfiunix_out;
+		}
 	}
 
 	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->fid.netfid, &find_data);


