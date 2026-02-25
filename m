Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BC62D7393;
	Wed, 25 Feb 2026 06:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002649; cv=none; b=TMpmMzBKwcXav0NQiSjLoBlrBEbfCFj2Dhq6K/Bvxrc/uJD8m/vgP7CQIvgHF7e0iNtijGlieBeMUg9ySwjY/v9Z7mBUdqZXSFry5H9r56i+gfKOjGgxnDJTYi7NqZE/Zq/c2oK4aS8ueabmmJsca4bFAlxIXH0E0s08C4JjJYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002649; c=relaxed/simple;
	bh=Ud/WvECC/8ass2bk3d9LVvh9dJNDzK2N35x3OGwmreI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEJ34lXfgUI6zYW/NoDVoZXa6U3hJH90oXx/9qgJFEYd131C+S8nvAuZTs/UaA1kIAfX2KkeIdpMyHsH7SVkzE8xEhVeW0eLE6hqMachzWsTAyZUkIrNDf5uRtL27wlY9TZPtprtnZwc/KoP7HHkoJEeH7wuTLCMMOwo9pBcdkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4pIqmJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4pIqmJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267F4C116D0;
	Wed, 25 Feb 2026 06:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002649;
	bh=Ud/WvECC/8ass2bk3d9LVvh9dJNDzK2N35x3OGwmreI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4pIqmJzGeeWvAO38ZPeazEXjkIuOgIDbTcLmH6nT8ZcnmLFP19vp2MdejmxuL8q7
	 pl67YOLjQy84i0YlI0538PAmYhq7hzaY8MtOsaZ9SaDOmnGjwpk59MfZT8lcx2uvpW
	 iAI/NP1EAE+M+J5DxE2FAMBDdvXI9t3ifj9+IQYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/641] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Tue, 24 Feb 2026 17:21:45 -0800
Message-ID: <20260225012357.778251705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <liuy22@mails.tsinghua.edu.cn>

[ Upstream commit 1956f0a74ccf5dc9c3ef717f2985c3ed3400aab0 ]

ib_uverbs_post_send() uses cmd.wqe_size from userspace without any
validation before passing it to kmalloc() and using the allocated
buffer as struct ib_uverbs_send_wr.

If a user provides a small wqe_size value (e.g., 1), kmalloc() will
succeed, but subsequent accesses to user_wr->opcode, user_wr->num_sge,
and other fields will read beyond the allocated buffer, resulting in
an out-of-bounds read from kernel heap memory. This could potentially
leak sensitive kernel information to userspace.

Additionally, providing an excessively large wqe_size can trigger a
WARNING in the memory allocation path, as reported by syzkaller.

This is inconsistent with ib_uverbs_unmarshall_recv() which properly
validates that wqe_size >= sizeof(struct ib_uverbs_recv_wr) before
proceeding.

Add the same validation for ib_uverbs_post_send() to ensure wqe_size
is at least sizeof(struct ib_uverbs_send_wr).

Fixes: c3bea3d2dc53 ("RDMA/uverbs: Use the iterator for ib_uverbs_unmarshall_recv()")
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
Link: https://patch.msgid.link/20260122142900.2356276-2-liuy22@mails.tsinghua.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ce16404cdfb8c..3259e9848cc79 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2049,7 +2049,10 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;
 
-	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
+	if (cmd.wqe_size < sizeof(struct ib_uverbs_send_wr))
+		return -EINVAL;
+
+	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return -ENOMEM;
 
-- 
2.51.0



