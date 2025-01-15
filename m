Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FB5248BA6;
	Wed, 15 Jan 2025 10:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937866; cv=none; b=DJyLYGPLgZOee3Rt1dVMISm07sRipWaUI410cvMSySZ6hK4mZZAaRQ5IGkbg1/aj/FEIg1Yfc1vipXQ6VI8CMam/eXAz7ei0fJrIe2SR+YGkxwbLyYeMBErb1svrqzrO/8mGESBUmYlrKMwBOJ7UQnFagG2In0ytZmuBtwjlg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937866; c=relaxed/simple;
	bh=OASlGgaqBc+zRbzD+08800yxL1Hm+xSL5IFYTFuXTGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlSZskfJ1KzMIs0248jJUGezr8UCGQVfT89hz0j2a/ycYCiJRK2cpFnHmzAaz9gKZPxLDtrkaa6PVr50I3ufmYjJrL9aooQDMrpGDCgI1SB47gynaO/MFTYicS8WnM6V02NdeZglLzMCVdhkpiYQ+WNMpXdKoN37lJVz0PTp9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ra1H42a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ra1H42a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7F5C4CEDF;
	Wed, 15 Jan 2025 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937866;
	bh=OASlGgaqBc+zRbzD+08800yxL1Hm+xSL5IFYTFuXTGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ra1H42a/lKtlZCM65E4Zgnuy9QLCnhk60SVLs7xpLV6c/xCfnGk4H7Gu6h+nDgT9U
	 6YJHNufVy5sALOroxfkC42+hxVfHWIaxq2H4oEYG/pUfYWiWxIFm/o9zviPZL63Yhp
	 wDNRG+e/I1fsXqP0Bwx7lj+EN+S6A6FlX8MLGaD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/189] exfat: fix the infinite loop in exfat_readdir()
Date: Wed, 15 Jan 2025 11:35:11 +0100
Message-ID: <20250115103606.968523120@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit fee873761bd978d077d8c55334b4966ac4cb7b59 ]

If the file system is corrupted so that a cluster is linked to
itself in the cluster chain, and there is an unused directory
entry in the cluster, 'dentry' will not be incremented, causing
condition 'dentry < max_dentries' unable to prevent an infinite
loop.

This infinite loop causes s_lock not to be released, and other
tasks will hang, such as exfat_sync_fs().

This commit stops traversing the cluster chain when there is unused
directory entry in the cluster to avoid this infinite loop.

Reported-by: syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=205c2644abdff9d3f9fc
Tested-by: syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com
Fixes: ca06197382bd ("exfat: add directory operations")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 7446bf09a04a..9d8848872fe8 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -125,7 +125,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 			type = exfat_get_entry_type(ep);
 			if (type == TYPE_UNUSED) {
 				brelse(bh);
-				break;
+				goto out;
 			}
 
 			if (type != TYPE_FILE && type != TYPE_DIR) {
@@ -189,6 +189,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 		}
 	}
 
+out:
 	dir_entry->namebuf.lfn[0] = '\0';
 	*cpos = EXFAT_DEN_TO_B(dentry);
 	return 0;
-- 
2.39.5



