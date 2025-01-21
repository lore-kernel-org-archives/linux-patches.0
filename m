Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A251F55E3;
	Tue, 21 Jan 2025 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482869; cv=none; b=rAhV/9/8ocflZ9orjCe4cAra1GjIQSRMFvxoJU3StsA0suny3DN+xIymMXIAhrztMedvPj2aeS3UedOP46hxXSU166o0LKvxAs5hdqvhvC+ZJHN512z//DsAIitiUiTCnjmeg1cky4iOQeB22oud03vVIcSgRrymPTx0Wl10SxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482869; c=relaxed/simple;
	bh=hsYYrNCceu0D5WdIM+j5sCVDHL4t1SbquTBzL352WDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7OYihgrq1NYu4Ui+oBzkj+Cgzs/zNUX/EukXDvwGNlGzPPGa5RzpJM0oYZJO4iCcA6/ujuNZr8WlrAX8uhmaACt+FGryJX3WRHrpcvJA5Ru2ffTYiCisXEJ1x8t9Dx+iuH9pjkcWcnAbFOI2P8Qgpw7T1cPwP2RxByLqGHdrVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mui/f7xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mui/f7xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EC3C4CEDF;
	Tue, 21 Jan 2025 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482869;
	bh=hsYYrNCceu0D5WdIM+j5sCVDHL4t1SbquTBzL352WDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mui/f7xuy3vHneVVhL3q9O4nMLN77gXwLPYr06yg8Wg5VXKwNGs6dD4WbbdHN5eMw
	 Ig4bsJr85oDGYNlIYOQwNdhorMl0YYSMY9d+32qS9nBG+L5/fITMdz9c7SNb19x4ta
	 4nI1kbCkg+GKmUYY7QjCpSERswQ+6ltQdawXXMAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/127] exfat: fix the infinite loop in exfat_readdir()
Date: Tue, 21 Jan 2025 18:51:18 +0100
Message-ID: <20250121174529.920282352@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a1b1de032ef..70d0849826f2 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -126,7 +126,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 			type = exfat_get_entry_type(ep);
 			if (type == TYPE_UNUSED) {
 				brelse(bh);
-				break;
+				goto out;
 			}
 
 			if (type != TYPE_FILE && type != TYPE_DIR) {
@@ -186,6 +186,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 		}
 	}
 
+out:
 	dir_entry->namebuf.lfn[0] = '\0';
 	*cpos = EXFAT_DEN_TO_B(dentry);
 	return 0;
-- 
2.39.5



