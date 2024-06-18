Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A81188CBE;
	Tue, 18 Jun 2024 13:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715638; cv=none; b=GrvkmEKoJtu6JvzioKqbn4n8TTGjjE/UXWQ+t1EjYP0kzfGGk2JMSg7XRd2O45KVfESREdGSmIsWuF158Y5qL13kGSKq2WBRBXR6h6sKwQD+WVcB6a8koZO7GlomAYSv4SSROjpy+ORV0Z2aQWNNd1ZEMrBt+pocrFCPBqaL7vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715638; c=relaxed/simple;
	bh=baJy0tiposHfDK0FmN2jEQ6yd0si21saTfZI6qzsv8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrymmuAS6y4iDpaWxN3m7jSAHAWuM4ermjQebjDXyfhcCXSjXGaXvJrTyMGm9hVXidB21XE185AIhv5B8ooQriTRpbbOyXmYTKXDjJKbSJBUwPgsMKymeSaPVF/xxvtwYPsyGjB5YPr1+zBj+B+xg7T8yMX5r/Tm7esE9wCiSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt2uA4kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt2uA4kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2864AC3277B;
	Tue, 18 Jun 2024 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715638;
	bh=baJy0tiposHfDK0FmN2jEQ6yd0si21saTfZI6qzsv8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt2uA4kgbTp57XFJtWPjlxbKTejjVzIZr7Y70sS2yuAf9IvOioy4iaJkAteXh9asJ
	 VDha9uL+eZlmygP+75ysfZPrjKNfa/SkT8BrbnAI3rkgW2dz5bvQ3dvD6r8ElYH3JU
	 TW34sS0ca/2GtRDf9PH1VEyFvuVnZTXkkvd/SNm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/770] fanotify: Encode empty file handle when no inode is provided
Date: Tue, 18 Jun 2024 14:33:48 +0200
Message-ID: <20240618123421.743830546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 272531ac619b374ab474e989eb387162fded553f ]

Instead of failing, encode an invalid file handle in fanotify_encode_fh
if no inode is provided.  This bogus file handle will be reported by
FAN_FS_ERROR for non-inode errors.

Link: https://lore.kernel.org/r/20211025192746.66445-16-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index ec84fee7ad01c..c64d61b673caf 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -370,8 +370,14 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	fh->type = FILEID_ROOT;
 	fh->len = 0;
 	fh->flags = 0;
+
+	/*
+	 * Invalid FHs are used by FAN_FS_ERROR for errors not
+	 * linked to any inode. The f_handle won't be reported
+	 * back to userspace.
+	 */
 	if (!inode)
-		return 0;
+		goto out;
 
 	/*
 	 * !gpf means preallocated variable size fh, but fh_len could
@@ -403,6 +409,7 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	fh->type = type;
 	fh->len = fh_len;
 
+out:
 	/*
 	 * Mix fh into event merge key.  Hash might be NULL in case of
 	 * unhashed FID events (i.e. FAN_FS_ERROR).
-- 
2.43.0



