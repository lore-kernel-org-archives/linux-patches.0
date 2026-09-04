Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B831417BF8;
	Fri,  4 Sep 2026 06:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502369; cv=none; b=c/vLqWUfdZAYZ6azBYiyO0xQVI6C2sPtrgmlBM2z7eo1paNGxRTIORnPnIffP284wu6WOPkChgVWCwefGafj6a1J9//DUzB9u2H75WETZgGSlt5riwkumrYcHQYQyUYwfG7E5xBk5W3ZzX/6bAHmL+FBfdHsYzc2HTJuVusaj3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502369; c=relaxed/simple;
	bh=8M4joXW6RTX8s6FhCPuOVcIxCbNe/aFhmGng1+0bc6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krYaw5mDmkwciZNaphJ+l8awOM1+CsvC5hGN6BtgxIF8wVurormRlKaUcDkW8knn/FvTGRum4gioDDmHghhgkWxXKiuu2S89rfe7T/u0AjsqJOEpS9oB4oHvhSvHuA/4lSZ2+FZLupValE+W9u1HYkziumiC7vEv560h6NHiz1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li84tNIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li84tNIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006661F00A3D;
	Fri,  4 Sep 2026 06:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502368;
	bh=o+4WCEKDVeuASpzd2xoiHhYTjrsD9Xw/Q1Bx817Mqpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li84tNIo2bL5tewUVTjDbzKavZ5/j1A3LVysDr4h+rg55FQIFh94sXu9OFir2+1GG
	 mI62iOHglM0QVqHU5c7SCvcrrX69b98wKsLkRI8j1rv/7abnKVUswy+TpNt+8MLPF2
	 SXV7JzNBUrZIWb8poKJAbIYYIPBvX2JVaNyDtBJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.12 140/403] ecryptfs: release message context on send failure
Date: Fri,  4 Sep 2026 06:59:03 +0200
Message-ID: <20260904045738.025794438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


