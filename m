Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DC429BDB5;
	Fri,  3 Oct 2025 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507736; cv=none; b=eXYaloB970TVdhsBsYC+b1BhsZPPtClZigx2tneRHPfW3TnwwDdwOfTtzYOtzZadRcirfF9+geS7YoQOswy3zloPzNJ3VO68eOYYt7nU2PnGbCFfJSQPHoyjxhcbVlTpIVIEowbcbtqs38TQ8LRmu6dXQ5S+uIjovvFE63MI5nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507736; c=relaxed/simple;
	bh=6MbAjqQ27Rp6wNCWnUU5gYwqCcIHThgV4aD8+QXPl7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CC/Z8nMmHpVw6sP5a9tUKLxOYlgNVxaaarCEdfwDEjIsh8s67gDEFMdMxB2ygLOoS2PSIYvJA07yA6iUUBCCjAqOI82s3+18yxZjRkSCgEU+WUThUJrjfxHg4XEBrvZt3+E/nkadHjzpemK1tWFMlooB5tPl0l++z01GOdJ63fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg6Lq8m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg6Lq8m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA26C4CEF5;
	Fri,  3 Oct 2025 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507735;
	bh=6MbAjqQ27Rp6wNCWnUU5gYwqCcIHThgV4aD8+QXPl7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg6Lq8m8+/sKoqWPRqiqSLgl59IManc/yBANI/LejFZ01yvIVttQd4AtMkWkcSh2p
	 3MG4vtUiUr/su8gvkBM21lfCzS7b+8a9NlFc7pUT6ZQIoKph5bCuJVdyTHIj6bnshJ
	 uqGZ2D8bMOtThXUJwui3fkXiV5MyJyQ/NaCA9pIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	ziiiro <yuanmingbuaa@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 3/7] scsi: target: target_core_configfs: Add length check to avoid buffer overflow
Date: Fri,  3 Oct 2025 18:06:11 +0200
Message-ID: <20251003160331.591816746@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
References: <20251003160331.487313415@linuxfoundation.org>
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
@@ -2738,7 +2738,7 @@ static ssize_t target_lu_gp_members_show
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


