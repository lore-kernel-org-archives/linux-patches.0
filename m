Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E2D569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED76C433D2;
	Sun, 28 May 2023 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302141;
	bh=ulAiqf3Wh/sKNdNcNnHeYS83HpokaczVlx0v7YCWL7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuyLMveunCksn2mgYkquhyOwR8Db1kMu5WSIf7Ru8Nm2hSNVfdY8N5zCjpiTapzs/
	 YWd5KeAWc2LUBog1oVecu3tET3+99e9g7ue14DnaFMhx0eHYqZha/CoWEL2DqvMbrr
	 2kRh6GFCJd3029qaFIBXZB0ujxUDIi6UaHILZS3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>,
	Woody Suwalski <terraluna977@gmail.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 016/127] cifs: fix smb1 mount regression
Date: Sun, 28 May 2023 20:09:52 +0100
Message-Id: <20230528190836.750455510@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

commit 72a7804a667eeac98888610521179f0418883158 upstream.

cifs.ko maps NT_STATUS_NOT_FOUND to -EIO when SMB1 servers couldn't
resolve referral paths.  Proceed to tree connect when we get -EIO from
dfs_get_referral() as well.

Reported-by: Kris Karas (Bug Reporting) <bugs-a21@moonlit-rail.com>
Tested-by: Woody Suwalski <terraluna977@gmail.com>
Fixes: 8e3554150d6c ("cifs: fix sharing of DFS connections")
Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index a93dbca1411b..2f93bf8c3325 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -303,7 +303,7 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	if (!nodfs) {
 		rc = dfs_get_referral(mnt_ctx, ctx->UNC + 1, NULL, NULL);
 		if (rc) {
-			if (rc != -ENOENT && rc != -EOPNOTSUPP)
+			if (rc != -ENOENT && rc != -EOPNOTSUPP && rc != -EIO)
 				goto out;
 			nodfs = true;
 		}
-- 
2.40.1



