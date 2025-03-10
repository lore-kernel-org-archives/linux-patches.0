Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55722253FE;
	Mon, 10 Mar 2025 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627940; cv=none; b=tJ1oZL8sQguD5BV+wfH4SSpDULQUx8O8PqxiuEXm65qoJXkHjoiLHh8WLPbpdk/9Dw4Wm1nGbR8C58WJQcs/Jf/nZ+4Hglg6uxOGNDmBkP0FVYfP5XFso4I+eOJmmmFJvzjfpkvsrNq/AXgMLPxQNClzvSrkYLYVZ/XRwSxjHik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627940; c=relaxed/simple;
	bh=s4Lln56EgzLsOJIu/W6FLD7L7mQp7xNQHoEn3pYh+eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFm2lyqY41c7jMedrc08iMQ2KAwpBtA6YSmpIFRECNkey8Bdq8U3OOPOZ3WjcdaQCaI7gGwvTQviYfF3iMY83kW3t0g05taBTBW1CN6MO0BR0cIljKf8u85bg0VbDLV5kD95kbN2D+W/KocyuHbvnrqPc2pGWu9mbiv8JJwXSXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7Q/9W/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7Q/9W/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D549C4CEE5;
	Mon, 10 Mar 2025 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627939;
	bh=s4Lln56EgzLsOJIu/W6FLD7L7mQp7xNQHoEn3pYh+eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7Q/9W/Zq/TcP+NEvqMAf3ODP40tZGGb3BcQoxx/EZcM78A11JYLsMh0kSjvCYVW0
	 WCe4+cnbCT5X2IiX0xFfX9wbpiIPtquo7Bgg6+GiYhnD6raYtJ6iFRXl4KkoXkX8/8
	 UStxmeDyMxZy4IxiTE1NvkqIg0WC4yl/yFEZph/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horst Reiterer <horst.reiterer@fabasoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/145] smb: client: fix chmod(2) regression with ATTR_READONLY
Date: Mon, 10 Mar 2025 18:05:00 +0100
Message-ID: <20250310170434.997615091@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 654292a0b264e9b8c51b98394146218a21612aa1 ]

When the user sets a file or directory as read-only (e.g. ~S_IWUGO),
the client will set the ATTR_READONLY attribute by sending an
SMB2_SET_INFO request to the server in cifs_setattr_{,nounix}(), but
cifsInodeInfo::cifsAttrs will be left unchanged as the client will
only update the new file attributes in the next call to
{smb311_posix,cifs}_get_inode_info() with the new metadata filled in
@data parameter.

Commit a18280e7fdea ("smb: cilent: set reparse mount points as
automounts") mistakenly removed the @data NULL check when calling
is_inode_cache_good(), which broke the above case as the new
ATTR_READONLY attribute would end up not being updated on files with a
read lease.

Fix this by updating the inode whenever we have cached metadata in
@data parameter.

Reported-by: Horst Reiterer <horst.reiterer@fabasoft.com>
Closes: https://lore.kernel.org/r/85a16504e09147a195ac0aac1c801280@fabasoft.com
Fixes: a18280e7fdea ("smb: cilent: set reparse mount points as automounts")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b3e59a7c71205..dbb407d5e6dab 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1320,7 +1320,7 @@ int cifs_get_inode_info(struct inode **inode,
 	struct cifs_fattr fattr = {};
 	int rc;
 
-	if (is_inode_cache_good(*inode)) {
+	if (!data && is_inode_cache_good(*inode)) {
 		cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 		return 0;
 	}
@@ -1419,7 +1419,7 @@ int smb311_posix_get_inode_info(struct inode **inode,
 	struct cifs_fattr fattr = {};
 	int rc;
 
-	if (is_inode_cache_good(*inode)) {
+	if (!data && is_inode_cache_good(*inode)) {
 		cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 		return 0;
 	}
-- 
2.39.5



