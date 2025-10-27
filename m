Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C8218EB1;
	Mon, 27 Oct 2025 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590340; cv=none; b=ZZnUf0JKf65cmLdIF9e1uuEqO+QxHRGWSUWCmlSldU4sVWxd0qQ69TjlG7rBrww4MF5lxXdCAkKNYSzgumSMy74SfYvzK5C3l0ZRQ02Z2kxClp736cyOZwN3yV/C0G08O8t9sU9h3ch6suF/bxJirL+y2vqK+yb7RMnuYmtSIuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590340; c=relaxed/simple;
	bh=JZptFXgkFSy0eogf8sRMGiyncHACMnZTT6fWfsBnP8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXw/rLTbi/EG2kXjOWCKJxxL+pxr7M9CyFTWn2C5P9jQEc2H4lYLECtagOXk2n7OQiv9b+4whjMrvy3Rot0EXWU+oguUyMBfwtNReElaLrvV0fH9cbD93a3HopGzsIUPp71Co1rblZR81Hv6AOhl3tyzb6rOVMoDS8IYW7hjp38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nS9p96b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nS9p96b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62EAC4CEF1;
	Mon, 27 Oct 2025 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590340;
	bh=JZptFXgkFSy0eogf8sRMGiyncHACMnZTT6fWfsBnP8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nS9p96b7Ers9lSkfFpwx3Rjd199i43KGyVgGop/rgsPh0srdNuQiaZbUN3dvMnjwI
	 NoXei0bMRqnEtWWk6ttmQ/sXVHtlwB0H89BttB0lLJOvb0s8ltkGFSKee4hIgpgzZx
	 Kle3HyIybMoLGI3Jck9F6tsUGLB6B9W+JCPej8ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	ziiiro <yuanmingbuaa@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 001/224] scsi: target: target_core_configfs: Add length check to avoid buffer overflow
Date: Mon, 27 Oct 2025 19:32:27 +0100
Message-ID: <20251027183509.010237829@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2563,7 +2563,7 @@ static ssize_t target_lu_gp_members_show
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


