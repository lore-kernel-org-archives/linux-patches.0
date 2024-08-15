Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19271AC8AE;
	Thu, 15 Aug 2024 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729664; cv=none; b=U82NDYdxdsKY+bH5O+fb6kBTmwn2jKSqTdMm1oQ5XR/dMz1cOhXQPucWcc7vOByWW6WXSETBDZW/4RXGd66OwH2Oq6SP5Cv5Te9YR4TbvFXD0XRfTzgkqnt/Z+WqxkFTIHMhz8dX0iM5jCzHKbnAp068I+1/SeMS733catqCItg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729664; c=relaxed/simple;
	bh=Lme6ybrAiaAkGM/bMVlub1EMAQB0oJTq90C40Cm/+8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8O3eMi9xzAge0Qlolk/Pas4y4whj2/c/+5wa2jtcmhjbN90Rgye0AU/e2Srr4z/0vcV6tYDhZgYySfBloDtf5jFaisD4cPzhMacC63an4K9VbsASQxXgoqA9fcX00IMIAMK3thxD68zANE41a5vC0B7s4xUVVdRpVrC2xXKpck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHMOX7Hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHMOX7Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A5CC32786;
	Thu, 15 Aug 2024 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729664;
	bh=Lme6ybrAiaAkGM/bMVlub1EMAQB0oJTq90C40Cm/+8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHMOX7HiZM/ufXk8oLHPnORrml4TxajJRZnhKfHYNf9AdSEbhagtKo327j+JYLuGp
	 wJzyiA45jFeh6vheLLiLiHfEhCwz+VV0knCdUKWaq4T+ItYeseYmdLJLn5cL3KTBur
	 KpyUqSXshSCdoUIQ2vjgdV1y1LWXnH9ngBfqW6LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/484] RDMA/mlx4: Fix truncated output warning in alias_GUID.c
Date: Thu, 15 Aug 2024 15:19:46 +0200
Message-ID: <20240815131946.242607779@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 5953e0647cec703ef436ead37fed48943507b433 ]

drivers/infiniband/hw/mlx4/alias_GUID.c: In function ‘mlx4_ib_init_alias_guid_service’:
drivers/infiniband/hw/mlx4/alias_GUID.c:878:74: error: ‘%d’ directive
output may be truncated writing between 1 and 11 bytes into a region of
size 5 [-Werror=format-truncation=]
  878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
      |                                                                          ^~
drivers/infiniband/hw/mlx4/alias_GUID.c:878:63: note: directive argument in the range [-2147483641, 2147483646]
  878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
      |                                                               ^~~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/alias_GUID.c:878:17: note: ‘snprintf’ output
between 12 and 22 bytes into a destination of size 15
  878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Fixes: a0c64a17aba8 ("mlx4: Add alias_guid mechanism")
Link: https://lore.kernel.org/r/1951c9500109ca7e36dcd523f8a5f2d0d2a608d1.1718554641.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 571d9c542024c..6b8ad58590145 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -832,7 +832,7 @@ void mlx4_ib_destroy_alias_guid_service(struct mlx4_ib_dev *dev)
 
 int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 {
-	char alias_wq_name[15];
+	char alias_wq_name[22];
 	int ret = 0;
 	int i, j;
 	union ib_gid gid;
-- 
2.43.0



