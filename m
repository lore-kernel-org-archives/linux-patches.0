Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD513B38A4;
	Sat, 12 Sep 2026 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239248; cv=none; b=HLSwQffXqml1FSgqaesIOwF5baBazBvYNRHpG6FaLJWkNxTZPZcAXT9WbyQx+NRdDNMuWTM+ArK2ekZCCUmJib0uQzCM8NYeUDtszbsXCT21dvcV+rAQQMk25Pu0KKF2JVA7EoWEeblnphCMskOQ6ExdqO//3/XGgu0iogHkyOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239248; c=relaxed/simple;
	bh=L2LJu00u4SWu7KxngysqmMo5R9HWyYfjosaST+fIhNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJyanlJqUKQNjK9dUTp/XUycOx1fwWezrZcFZmenutP2SG0oSQJf7GZA0+bxasLqmXvlhR5vZiv2+8rXG1oW2GgsVRDdy+Advd2lN4+TIsNyuI4XTEJCwNY1Is8PXbcGro1zAeq8H0CaqToPjWxPGsMsCOJzc2dVPufh1Fjh200=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWdRkaG1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWdRkaG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C984D1F000FF;
	Sat, 12 Sep 2026 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239246;
	bh=XaShxEH10S1cJcGoa3Ku5NgI9nmS+UvgpmoNy290KCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWdRkaG1zrPiEx79n1ye+XMjI9unjWgsA5dC986T8sVRXx/BCxHBaPwvAwGwSSfzy
	 15w4DoqTtwYMJp6XlgV8CXYJwbUwvZNpFd4U+iva8ELSWPmAS/2ogeFD6TuxW2Uuh0
	 Op5CXxWgLqPHsxpMdVqzc0HzvTg/YX3hfwp5RLMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 624/935] RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
Date: Sat, 12 Sep 2026 09:00:54 +0200
Message-ID: <20260912065541.149693695@linuxfoundation.org>
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
index 0b61df52332aa..80dac4496e1d2 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -377,15 +377,13 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
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



