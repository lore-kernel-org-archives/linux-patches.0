Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A581E0DC4;
	Wed,  6 Nov 2024 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897435; cv=none; b=agBOn+hJIej6qWTUMNEFacSK07NEOWSi6izhg+Mv0dRbc3seoSjOFGsd8Eloy4AFpplt/cqdfmcjYawvO27ebMPi5t9qt6yLlcdkRwasQSffkbknzjhFWlP9DeCPlXbT7+Y12H7UxUlMMK5iH3QA5uaefxqJiZSb8zS8J4GNhlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897435; c=relaxed/simple;
	bh=oUFaWAdE2K9E/A9LX3vVDJihZnAIYxi2HD7BF3fDK0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf3MKMs1GqJyzcjVSBNm4ylBDAOt6EAz+qNgNelkm8O8od+YxOLLvT8j2EXcV0TmUDx1hAuc2gMcXFXlzt39e16yTRmSpHOuHEVKE3MqNQkj/gIZSzNhxnQFuUlQkiHBHkt48bkDcSwBBV0ognLZUr+tM13caCuuxnn/htgdcjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/S8asJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/S8asJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E888CC4CECD;
	Wed,  6 Nov 2024 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897435;
	bh=oUFaWAdE2K9E/A9LX3vVDJihZnAIYxi2HD7BF3fDK0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/S8asJN//mPBSR1EBNo0J/mbCjwEFNJZ5D+Tr8wFpytBloMATL08iUavUs6B3n5r
	 yXYKx+XGgbB1qhcvbdqveGxAvhbTChmrhkxDmFWACNSpZ2WS/Hp1X50v4ytZ5Wyt2M
	 jHPfksAoFnvnvGX5X5Oc0f8mcx77/N6x+Hqw5D+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/151] smb: client: fix parsing of device numbers
Date: Wed,  6 Nov 2024 13:04:00 +0100
Message-ID: <20241106120310.267620896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 663f295e35594f4c2584fc68c28546b747b637cd ]

Report correct major and minor numbers from special files created with
NFS reparse points.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 6 +++---
 fs/smb/client/reparse.h | 9 +--------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 7429b96a6ae5e..a4e25b99411ec 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -497,7 +497,7 @@ static void wsl_to_fattr(struct cifs_open_info_data *data,
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen))
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen))
-			fattr->cf_rdev = wsl_mkdev(v);
+			fattr->cf_rdev = reparse_mkdev(v);
 	} while (next);
 out:
 	fattr->cf_dtype = S_DT(fattr->cf_mode);
@@ -518,13 +518,13 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
 				return false;
 			fattr->cf_mode |= S_IFCHR;
-			fattr->cf_rdev = reparse_nfs_mkdev(buf);
+			fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 			break;
 		case NFS_SPECFILE_BLK:
 			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
 				return false;
 			fattr->cf_mode |= S_IFBLK;
-			fattr->cf_rdev = reparse_nfs_mkdev(buf);
+			fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 			break;
 		case NFS_SPECFILE_FIFO:
 			fattr->cf_mode |= S_IFIFO;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 2c0644bc4e65a..158e7b7aae646 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -18,14 +18,7 @@
  */
 #define IO_REPARSE_TAG_INTERNAL ((__u32)~0U)
 
-static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
-{
-	u64 v = le64_to_cpu(*(__le64 *)buf->DataBuffer);
-
-	return MKDEV(v >> 32, v & 0xffffffff);
-}
-
-static inline dev_t wsl_mkdev(void *ptr)
+static inline dev_t reparse_mkdev(void *ptr)
 {
 	u64 v = le64_to_cpu(*(__le64 *)ptr);
 
-- 
2.43.0



