Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1625E7EF00;
	Mon,  8 Apr 2024 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583098; cv=none; b=fBDYg2wVVDH+dAwxyNK8b+oMx194cDcoE/6XIHIlOshv4Opga6P+eDwvwwWli3djfFbR7ws+Tsc5WJqC/RI2tuGW2rhoPrs1qSwtoOjWeAozOJ9T51ht27RxImKdZHNUklY9TMdlfIXLWTbIPZWudtB4l2mmLiy5ccqImeHky5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583098; c=relaxed/simple;
	bh=BuYjPBP+zJIOluXfo0g0qx+iUqkEQjbsTJ6Gaf4H46U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKiG3xr/JX3NynlZeNHRp/UFF1Wye8Rex/EcfIrLN6G9rHr64Z2WMyNj7Sylt0D/kKA53PVNnwtq50Xg/HyqcJQy+NxYK5I6QW1SF/Asqc88u+r+8CNd9xWkd0S8gnZxxRC6Jt9MUUVdaS+WE0ouDsqXsttLGGpuOXHRXrRMnHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVFZD0pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVFZD0pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F8DC433F1;
	Mon,  8 Apr 2024 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583098;
	bh=BuYjPBP+zJIOluXfo0g0qx+iUqkEQjbsTJ6Gaf4H46U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVFZD0pifyma/XlFGT06BHW2518nm0oom5sLowIxNo1YUrzZCv5EbXnUU4R18tw02
	 5Kezi98h85tJPzFNwSN2cBXaqvdW1gspUqVi7RsPxLa/+tl7m6eH83Ne8kbviPahSg
	 fHTGs/079UG4ACbjpVSricyWWIm+zDVkOWPyBj4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 189/690] fanotify: WARN_ON against too large file handles
Date: Mon,  8 Apr 2024 14:50:55 +0200
Message-ID: <20240408125406.411679099@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 572c28f27a269f88e2d8d7b6b1507f114d637337 ]

struct fanotify_error_event, at least, is preallocated and isn't able to
to handle arbitrarily large file handles.  Future-proof the code by
complaining loudly if a handle larger than MAX_HANDLE_SZ is ever found.

Link: https://lore.kernel.org/r/20211025192746.66445-26-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index cedcb15468043..45df610debbe4 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -360,13 +360,23 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 static int fanotify_encode_fh_len(struct inode *inode)
 {
 	int dwords = 0;
+	int fh_len;
 
 	if (!inode)
 		return 0;
 
 	exportfs_encode_inode_fh(inode, NULL, &dwords, NULL);
+	fh_len = dwords << 2;
 
-	return dwords << 2;
+	/*
+	 * struct fanotify_error_event might be preallocated and is
+	 * limited to MAX_HANDLE_SZ.  This should never happen, but
+	 * safeguard by forcing an invalid file handle.
+	 */
+	if (WARN_ON_ONCE(fh_len > MAX_HANDLE_SZ))
+		return 0;
+
+	return fh_len;
 }
 
 /*
-- 
2.43.0



