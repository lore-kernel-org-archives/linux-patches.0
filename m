Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94439309EEB;
	Sat, 12 Sep 2026 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230400; cv=none; b=X6Ij1Zsg5zHj7wvsxlDdSRW6n3uLdoaalqhC7sl4wPvBxmY69XTgXnse0yC8ltmaEQoGNiQZsXWj94/v86uCjScI41sFzumreNRhSV3BXbGKgnaRmcO0Ym6DZNhiw74bvQgWfo9UDIkz+LIkbArVNIdoTtfcx+zdyW+VoWvvX3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230400; c=relaxed/simple;
	bh=ddxOsl/P/9hTQMvYrWx6VxVUB3EjW3Ig9o42Ank0aZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJlqK3M+zGtjYwCVdD/qXxpMBX4dV6IQwevIBVFfpcK3x2KoB7BxCKxuozMgEm6AK/dytGD+8Otfi9mOPZkPoGFjcimc/t2KbGdkVEIjI4WZuy7YlJNSy3AgZ2bVqqKhaEHoMDTYpMerWmN6go3kdNRAd0jUFMULYZ57eJVvMbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJwa2nK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJwa2nK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A241F000FF;
	Sat, 12 Sep 2026 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230399;
	bh=yh10vXB5N9AbRelgoFg8/GHSh4Asg+bXhxHNxhuk8lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJwa2nK6Wn/GzNlN/+qdFnZIBCtPinqNE8MrCkx/50otH7ojanRaIdw3xpGxMwtPt
	 F5EY9OEowezoWldqnp8BcKl5Q1AeMJtww5YFVrUAVVGh/nkuWGEqwTvAC4bxs2rZ/h
	 zCrAiZg5ePTVtGG25J36KZw4eHKapW2TX1hBgcgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0743/1191] RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
Date: Sat, 12 Sep 2026 08:57:51 +0200
Message-ID: <20260912065604.968531443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 290ea8ac3838c..f93ff7afc9cc6 100644
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



