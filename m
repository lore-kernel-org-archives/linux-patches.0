Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577C2D23A6;
	Sat, 12 Sep 2026 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220060; cv=none; b=M3W/Ae9zj8QOJNMFgihdaR6u/nEQKrcDrKPyKRrnF1z8RPO36wXsHp/RhaBfW56UkW2/EKfxy4NKvoNGkj2ws2EFySPA6SZe5ZecsSELxC5u2mHisfkbsayJfQiIPC9caJvWCtBkW0mW5RuJsU9EqjUkD8W8EBkscmke/5+C9PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220060; c=relaxed/simple;
	bh=kmhw4BgdQqMuDRNSUqxIytUUUQSKr4WzuvsK0kmSx+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+SOjlYrprL+5L5bgJYagnReiNzFlG147wzxb2LrNNodRRvvfMnkID6wf5YmN0Sgu7PqZRQur9Cq4DBwnbb8Odbdf/M3mrlwQEyqeVsV4aDDrFLpDfJlTfk/rAvaYFxMPHG3EmzKot+wsXO6PdQLNr8qB5VDGRJx2z8ojMtVXYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WELyhEyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WELyhEyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91BD1F000FF;
	Sat, 12 Sep 2026 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220059;
	bh=ePMD5r299fLqAPDPYZj1+smmhOFLRLJPHDfxvLuhaUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WELyhEyjCF0fh2OmaD/J0ABeqhXb6ZoHod4BnDbtOIAtlW9+v60mBEvIj2P31i2fQ
	 v5ywCrW9t8ffM4JSG36d6p9aQF4rA44PR1fyo4prhrKsPTAQ/YigENaL7pJ2fGq6nG
	 DMGiwdUjSZGw+pwsAvncU+kLDGIbocaaQKkUn81s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.6 0099/1424] ecryptfs: release message context on send failure
Date: Sat, 12 Sep 2026 08:42:11 +0200
Message-ID: <20260912065609.521716001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yichong Chen <chenyichong@uniontech.com>

commit 219644a3ad5518217b2d62cad6d2c36a2308c949 upstream.

ecryptfs_send_message_locked() moves a message context from the free
list to the allocated list before sending the request to the userspace
daemon.

If ecryptfs_send_miscdev() fails, the context is left on the
allocated list and cannot be reused. Move it back to the free list on
failure and clear the caller's pointer.

Fixes: f66e883eb618 ("eCryptfs: integrate eCryptfs device handle into the module.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/messaging.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -285,9 +285,16 @@ ecryptfs_send_message_locked(char *data,
 	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	rc = ecryptfs_send_miscdev(data, data_len, *msg_ctx, msg_type, 0,
 				   daemon);
-	if (rc)
+	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to send message to "
 		       "userspace daemon; rc = [%d]\n", __func__, rc);
+		mutex_lock(&ecryptfs_msg_ctx_lists_mux);
+		mutex_lock(&(*msg_ctx)->mux);
+		ecryptfs_msg_ctx_alloc_to_free(*msg_ctx);
+		mutex_unlock(&(*msg_ctx)->mux);
+		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+		*msg_ctx = NULL;
+	}
 out:
 	return rc;
 }


