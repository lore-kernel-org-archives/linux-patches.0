Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E3D7E110;
	Mon,  8 Apr 2024 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582834; cv=none; b=iRrHf+nEUPUy0IsZqAjke97igYZBAUolLijvvdhjgZGCI5Vj4wIcw2zNlrjVXQHLisEfMnEV4QTBn5qZPsvczZpDpqG+s3saIoUM31MqBJgPDAYE4B2sBPeo+hJ9xawbh8f2YHJdcwsZVnGYzdEwYYy4nA5UA1Wn8ry/ayGcEW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582834; c=relaxed/simple;
	bh=iSQ7hOWbxt5AfpWrNC3D56u5STPjv2juOm9tLasZCMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl8yIfm6ZNVc37aEFRCP+a33nrTtALtkVUe6DPyIN1c3MIcJ5gZQ/1UqG+ph022pXfzDfnXUxNsMWMkofh00RSDwjrN49rSHbxa0dqxX3KzStNbPdHmuOHEgmZal30Lq4PP4CL2LSxaDRuO96z8aL69D05DutydDfR0Y0wVT7sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZppYmU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZppYmU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8429AC433F1;
	Mon,  8 Apr 2024 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582833;
	bh=iSQ7hOWbxt5AfpWrNC3D56u5STPjv2juOm9tLasZCMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZppYmU8VcUMvfkFUokFWPLzaNrJSfvGEEqO67Inb7tf883ywHLjdA0BCRGUiB1Rr
	 08KKrKXI5Q5uT9hMKFRkIlJ2yk1iTe1v3ycOfLYZRmKRX8dUkDzP03UnFCeJ3oQF2I
	 4jXHQ16TXwpn6wdwdHYBY+vNcmM0qCrJf25YYZ6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 179/690] fanotify: Allow file handle encoding for unhashed events
Date: Mon,  8 Apr 2024 14:50:45 +0200
Message-ID: <20240408125406.048869760@linuxfoundation.org>
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

[ Upstream commit 74fe4734897a2da2ae2a665a5e622cd490d36eaf ]

Allow passing a NULL hash to fanotify_encode_fh and avoid calculating
the hash if not needed.

Link: https://lore.kernel.org/r/20211025192746.66445-15-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 397ee623ff1e8..ec84fee7ad01c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -403,8 +403,12 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	fh->type = type;
 	fh->len = fh_len;
 
-	/* Mix fh into event merge key */
-	*hash ^= fanotify_hash_fh(fh);
+	/*
+	 * Mix fh into event merge key.  Hash might be NULL in case of
+	 * unhashed FID events (i.e. FAN_FS_ERROR).
+	 */
+	if (hash)
+		*hash ^= fanotify_hash_fh(fh);
 
 	return FANOTIFY_FH_HDR_LEN + fh_len;
 
-- 
2.43.0



