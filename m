Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AAB7E105;
	Mon,  8 Apr 2024 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582845; cv=none; b=UDvTtrwS+1ngZK4G6TUyKBx/WDb24pVr8KVBREbTBxWplWtdw+ezTPtBFMWmI/XKNnw78U/kk+i33eLh3+z58okH8JH1T3GBmiBfrT/Cn3XHN9k+5R/Vgf2Cf5Ok429aa6C6j5v+H9Z+OgK1EJQOq1/VLtNVF61ShNIvkuanQM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582845; c=relaxed/simple;
	bh=zKWW2+vhAHU0tGheOHQGDV6lBehIwwJm12jsw8jcPcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFb6L4SrlkWWuHApi6BXoE8YID5izb5gRAZfqoh+P1p0R/RFUvUXG9vHnTumKSY0AWM4BFNk+rVPpvTDjn4j+cPViHjbJrm3bPP27hzWDaVWyIHo2GdXhZCn4UZin5ahi2qCsk/7eSzWdFzn2Tzfi6/4PJmGoBOIKMrL1/aB8mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxUnElMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxUnElMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313C4C433F1;
	Mon,  8 Apr 2024 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582845;
	bh=zKWW2+vhAHU0tGheOHQGDV6lBehIwwJm12jsw8jcPcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxUnElMYjiG3bMwsAlsK0W+vBbdFrO6PTy4ItGdFFD2BH2+OmjW15iXrd2giIqlV1
	 6/MSLgqpQjCAaQyxbwnEkHmBdR6zLFLCnxSgZgtNmZQDCZ33+YjXma+XMXW+pr6kRd
	 cyOj85X9OQqKYjUMYDNI4IMH46A2AKG/LKvLqIUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 180/690] fanotify: Encode empty file handle when no inode is provided
Date: Mon,  8 Apr 2024 14:50:46 +0200
Message-ID: <20240408125406.081413625@linuxfoundation.org>
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



