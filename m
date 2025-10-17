Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27067330B0D;
	Fri, 17 Oct 2025 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715945; cv=none; b=L/Xf0GO6FRsS+bpvfh9as31PEVa2TGkcWEspDF/TFDHMoSokhxGG0NZ6FhhIX/fhNEufstDBB5a6HL2zP0rrFsw0GiFMk3LmH8o4mmeE+GeGmc7KkUJ2Ee78VwbBoaJC/4ndJ4qis5EZZEUdKhcwDras1Q+VkX0fhz7ECItK3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715945; c=relaxed/simple;
	bh=xu9e8hvJyJhj44FEhZKAfkLln261VGTWny8cXndnCII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+akpdw+3O2YGRpN/xn7upUMIC+eNpRmd5QyMNmen8Kip5AvjLKjuf4SQjPp/IoJRzExav9Yefrd7F2nxyq/7UXKdY+9fM7dRPdTN0wWGg/h7jFS7+YP4jsypZRDA5GR/FKu9Dv3zVKwPo6AecGcbxAEggIt+tSNhF/k/tLJxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GR6716nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GR6716nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0529C4CEE7;
	Fri, 17 Oct 2025 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715945;
	bh=xu9e8hvJyJhj44FEhZKAfkLln261VGTWny8cXndnCII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GR6716njfBnPF0ok2hXIp2Wr4qmpRqQ03JSF3hE+8XgxZVq6GJk6hL0Z/LyVXAeGQ
	 clVhTIgbnGNZ4WxilTBSfgUamC/XTvWTTxC3AZoNLj2rrQvDpCOYl0Ke9T8NEbqSve
	 idCxfMkWt+8GpfZrqnrFoVBTc+B6isJz3mt6VZFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	ziiiro <yuanmingbuaa@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 002/276] scsi: target: target_core_configfs: Add length check to avoid buffer overflow
Date: Fri, 17 Oct 2025 16:51:35 +0200
Message-ID: <20251017145142.477812533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
@@ -2679,7 +2679,7 @@ static ssize_t target_lu_gp_members_show
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


