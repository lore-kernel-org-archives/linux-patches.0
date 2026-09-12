Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E119C32D7C7;
	Sat, 12 Sep 2026 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241294; cv=none; b=VsW3sk1pcM8YxAVWYx0av8/mlVftFbtpUmVgb5g20wlq0Ty81O/Dly9whmHR9lMWtA5iEoYCSUgOaWhmQYIxypGZPSUHT7vB0qbZsNtfHXROpb5B2PfpodaHPC51qlpbvVVfMnX6GpFp8zesbb1Kk7VFC0SyxIKzW1RDyOV0vQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241294; c=relaxed/simple;
	bh=C0ARq6hCtSo0BF5U/GEM0KtHbxjHxgFgS4Vqg9NTPGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgMZrg4o2Koped0ZtWkPrq/iAprhktcL0DCVIG+Fy3j6o9z8WjfNLtwppKf/R5jOlxjlUfrPw19u9zHXz5anlQKdIrrmTxmfP+Nf4E4ZI8dcYE9Crsko71o1bV1YCEQLnZcGrXVmt18GYAY7GbClv0DbnkhU3Uq9bPv9XcEzLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njpOxxwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njpOxxwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14331F000FF;
	Sat, 12 Sep 2026 19:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241292;
	bh=vTkUAj1dDJNVoevWjN+EE/CgSZzUTuxlyoXensXpuQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njpOxxwZ4rXbd3xC35wJS2jerRkQ7b8kDZnqv6NW/OmVu2bQvogaGJiqRc9uXFU3g
	 Q2cLEGha1U3vAxiRV4rDDETdaysrgb/k/f9e58z7qtO2yN4vnhaGs7slE7/MAZ2ZSn
	 rVsL5OcrhbPm3o36L8flmme9uFaNys7TDWAflkEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.10 063/798] ecryptfs: release message context on send failure
Date: Sat, 12 Sep 2026 08:54:51 +0200
Message-ID: <20260912065518.407771248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -283,9 +283,16 @@ ecryptfs_send_message_locked(char *data,
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


