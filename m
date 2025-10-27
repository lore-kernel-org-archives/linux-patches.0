Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AA932D45E;
	Mon, 27 Oct 2025 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590947; cv=none; b=rOQzFIe5iByAyLwXtESydoavWL2iqYmZKYLLMgqITZut4ZgIE/sA65GXEg7292otiNo+WxCDGi6waeMqkZYyX7GEdW7bpTw34IAn/HP9AbMOHWTB5CiIhH7DkUuUpeKj6tV3ytYkl+I07JnaufR/uZATU6lxwpuGUNFUeVenkv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590947; c=relaxed/simple;
	bh=RHBAA3Iq2sR8ofHKYJcOVvBOHZUcGcjiaEXviAWvQis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4XtkamuxTtY+LxCS7qeqAG14nhe5I2+6R9zTT4TJjKvjIaEnhDeh7UCWD42Omdy2cNrP5wKOwmFAsS54ZvUmBZLziv1067e/wMQzUMJwu9OwLIJrVKI2sdG8y3vR+6HAGeNiqotnke6suCPOLeWB7lmnB35O/9Ffe+0hdl/ufY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1nCuDks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1nCuDks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DAFC4CEF1;
	Mon, 27 Oct 2025 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590946;
	bh=RHBAA3Iq2sR8ofHKYJcOVvBOHZUcGcjiaEXviAWvQis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1nCuDksUQxnQGSQLSQeCOmPEAbgLA9H1aGl7A37Mq3ZClFmcaO2EbMK/klpdpeU9
	 vIj7rwhafM5WYXB8tCT6gH0LgsqFau3p8ybnDJOcN9HLUH0NCQnw/J6eENd72JXAyB
	 btPxhLI6yXsaKZtgN82F7DuHibVDbwGsaUbdjhvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	ziiiro <yuanmingbuaa@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 001/332] scsi: target: target_core_configfs: Add length check to avoid buffer overflow
Date: Mon, 27 Oct 2025 19:30:54 +0100
Message-ID: <20251027183524.655586514@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Wang Haoran <haoranwangsec@gmail.com>

commit 27e06650a5eafe832a90fd2604f0c5e920857fae upstream.

A buffer overflow arises from the usage of snprintf to write into the
buffer "buf" in target_lu_gp_members_show function located in
/drivers/target/target_core_configfs.c. This buffer is allocated with
size LU_GROUP_NAME_BUF (256 bytes).

snprintf(...) formats multiple strings into buf with the HBA name
(hba->hba_group.cg_item), a slash character, a devicename (dev->
dev_group.cg_item) and a newline character, the total formatted string
length may exceed the buffer size of 256 bytes.

Since snprintf() returns the total number of bytes that would have been
written (the length of %s/%sn ), this value may exceed the buffer length
(256 bytes) passed to memcpy(), this will ultimately cause function
memcpy reporting a buffer overflow error.

An additional check of the return value of snprintf() can avoid this
buffer overflow.

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: ziiiro <yuanmingbuaa@gmail.com>
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2637,7 +2637,7 @@ static ssize_t target_lu_gp_members_show
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


