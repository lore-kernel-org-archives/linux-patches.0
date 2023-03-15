Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B584431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A92AC433EF;
	Wed, 15 Mar 2023 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883313;
	bh=amlhXbZ46SzZLbjCWOOP1mGroEXnotOQHb+K+XnBvzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZRUfVAjDOcvRRjPyWQAhzFca0ZwyPiXPx54f8liSpdow1B4nC01+J3IqxxAFmXwX
	 eFV7BJa+K53925jzctRRDeNa0gXP2jCHW4uWgSherQ4uZDjtOyyJMYloFVTh2jaRgz
	 0C+pM/uW48YZlHINtd9CZ6+M3vCdePy1TdBNUh+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/145] xfs: fallocate() should call file_modified()
Date: Wed, 15 Mar 2023 13:12:42 +0100
Message-Id: <20230315115742.146293471@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

commit fbe7e520036583a783b13ff9744e35c2a329d9a4 upsream.

In XFS, we always update the inode change and modification time when
any fallocate() operation succeeds.  Furthermore, as various
fallocate modes can change the file contents (extending EOF,
punching holes, zeroing things, shifting extents), we should drop
file privileges like suid just like we do for a regular write().
There's already a VFS helper that figures all this out for us, so
use that.

The net effect of this is that we no longer drop suid/sgid if the
caller is root, but we also now drop file capabilities.

We also move the xfs_update_prealloc_flags() function so that it now
is only called by the scope that needs to set the the prealloc flag.

Based on a patch from Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 752b676c92e3f..020e0a412287a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -954,6 +954,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -1055,11 +1059,12 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-	}
 
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (error)
+			goto out_unlock;
+
+	}
 
 	/* Change file size if needed */
 	if (new_size) {
-- 
2.39.2



