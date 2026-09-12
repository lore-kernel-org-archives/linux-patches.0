Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B9947A87A;
	Sat, 12 Sep 2026 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216374; cv=none; b=I0fPoF8W4B90wB89Upa35CkzMVoYtCvS1DCZWpWYilxkmr/NUkRrnExsynpgk42oc0RiAxIp6YSiXEVk7ZhqB6c0ipZmHuRQZfYUQuqBHSd2ssEMI43Nsj7KyKXwTWG5VSlAvzb5c7fD3Cw9uGPQ6pS+f1Z+zEJBSSXxkYqXFFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216374; c=relaxed/simple;
	bh=KYcV1moxWqm/UxJy9BK9YZPgkNHYa6oU3imYZYxVA2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfKtGWOHDBsr+ZAIdpDYKqCZ+cQlUA9pYiI0i8fuVA53BCs8AH0zqwdZgk3CESFnMs7zw5ITpdbEgebAczF9sifmNke6YH6shcb/hXWZZ3wcAJ2amgy2iOKbXlzsKR0tEFsdh0GAzvEjKxf52fnITErHYSh43Ic2CxThkDi2NcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZbroQGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZbroQGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451401F000FF;
	Sat, 12 Sep 2026 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216372;
	bh=Sh53rNPZ8uVFNOThMMoTP5PQfihu0T/RB+LB6eVSmqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZbroQGAwHGPblqA/dRkRY1RMTczr1TeWp1IwAUOc2nIO+q/iE6d2OKa9dCSrTIYu
	 gagRxVBfhy68PefgfKqL+rlEr059u60NMtlozaDPx7+vDCh6Vzr4DzZ3zAAbjWDNWX
	 S+BXi7zEYjsV088Ocz7mimubIvzLUi6NMjw+E9Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0723/1376] RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
Date: Sat, 12 Sep 2026 08:52:29 +0200
Message-ID: <20260912065623.654295171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 03826bc1fa6c90405bf05831f2b501a8368dcd27 ]

get_param() reads a congestion parameter as a u32 but formats it with the
signed "%d" into an 11-byte stack buffer. A value with bit 31 set, such as
0x80000000, renders as "-2147483648\n" whose full length is 12. snprintf()
stores only 11 bytes yet returns 12, so simple_read_from_buffer() treats 12
bytes as valid and reads one byte past lbuf[].

Size the buffer for the widest unsigned decimal, format with "%u" to match
the u32, and use scnprintf() so the length passed to
simple_read_from_buffer() reflects the bytes actually stored.

Fixes: 4a2da0b8c0782 ("IB/mlx5: Add debug control parameters for congestion control")
Link: https://patch.msgid.link/20260726-get-param-leaks-kernel-stack-memory-v1-1-d61a4d39662d@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index a78a067e3ce7f..88ac5fd1038ed 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -399,15 +399,13 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
 	int offset = param->offset;
 	u32 var = 0;
 	int ret;
-	char lbuf[11];
+	char lbuf[12];
 
 	ret = mlx5_ib_get_cc_params(param->dev, param->port_num, offset, &var);
 	if (ret)
 		return ret;
 
-	ret = snprintf(lbuf, sizeof(lbuf), "%d\n", var);
-	if (ret < 0)
-		return ret;
+	ret = scnprintf(lbuf, sizeof(lbuf), "%u\n", var);
 
 	return simple_read_from_buffer(buf, count, pos, lbuf, ret);
 }
-- 
2.53.0



