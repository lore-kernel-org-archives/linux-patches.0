Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A692F6931;
	Sat, 12 Sep 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232753; cv=none; b=TRGMyHZ3lJ6PNA8njghVIFJpZ2P5xzIPvE13B6OMqAOtUxu4VbLLhnjqQ4rZfWhrMCCV+2tAC4h0vb0eQjIXJxteyxR0zwOXQ+1h2uWESPdakLqJgYcXAWKJTY2NnJnyV+C+cz4sWcxuJSk+oSlZeVJoFrmIHYz09P4/AoI9EYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232753; c=relaxed/simple;
	bh=5oLRR7zIGnT74vc7ssLpU71Ip8etp3YGCsf2YZnRlUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATBWcn/jhzBUbDsZIPfbs65SPsR/CANtFCkVzurSDvQtFHds1UEa8cvKDkWkCMDsiDXRoC7a51bChpd5P0t3YZOIu4EhUyKIOnPtjVIlJyF4X8jIBc1AcAOLQbvXj5mfMnGPqz03Qiers5QN/QC688XAKEWx5wur0xEPsbyIwFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmEg5dvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmEg5dvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439771F000FF;
	Sat, 12 Sep 2026 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232752;
	bh=13dPLy/bndI7yEGfpTRDD3gGW7v+wAyj2Qv2pCGSriw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmEg5dvybHhJXj5JpKvag9H/8W4QfecZUham4ILkRlqj3plAAaxWMh27U14PqflFv
	 qe1JPIiGWmbibeXRHPrNJxSD2HT42D/E9CUerTYkdydhcnlTsd347KzeaiYXclaRBb
	 cEvKRJPVC3dv2G1V8ZKjzLZK4MdfRsXRklTcsDS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 072/935] ecryptfs: release message context on send failure
Date: Sat, 12 Sep 2026 08:51:42 +0200
Message-ID: <20260912065528.487276639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


