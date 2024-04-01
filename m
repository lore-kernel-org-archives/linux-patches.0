Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D8343AD6;
	Mon,  1 Apr 2024 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987990; cv=none; b=fMUCNOZmMZagu0j7cispST/wkJKPdSPrgyRMNALcrgp71yBUq+adA5HutZiH7lLfn51nYAiRAEfOhT9E9V2dga41JLIqFpROS8IeCqc/XykqG/AgPvfumoSLm6Y8KW4wbjF2aRz3z7LnFleKrsK+eJ9AofnZAYgoIi0J222NE0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987990; c=relaxed/simple;
	bh=AN3LzELXKC78DZnftTgrqr2C9LmFigbs9vD+UcGqhww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgSmzV8pon9bm0BZ8ihC8TL/HA58K+pMujZJJhkt1igpJmwgBu9ruR0xwK6qdsBhI92YYFiHPbsItADLVx2+Mv2LMa7dX5YQxolxN1a42VYdLHL3k1p6kPmYrUUQoLkkqpPL5Vn/NkZh7KvejdS/9CNnC/OlQgv3dm9sprXwob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ9T+lsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ9T+lsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C3C433C7;
	Mon,  1 Apr 2024 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987989;
	bh=AN3LzELXKC78DZnftTgrqr2C9LmFigbs9vD+UcGqhww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZ9T+lsqiBL0NTllvs5Jq3qB6tA7Kn4KVzGJIBRfMIEDUfhrpXQ5hMkh8YfjoH0P4
	 C2GjNnWZTbVZzWzVJejrd7eGkpSCBj3SS7ITfDxlPLX0nZpiR6drbENqkOogSc7j+m
	 L/KcTpZK6r745QFIKtWBt3Yzu/5YoI5Ef4kKOePI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 052/432] ubi: correct the calculation of fastmap size
Date: Mon,  1 Apr 2024 17:40:39 +0200
Message-ID: <20240401152554.679128421@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 7f174ae4f39e8475adcc09d26c5a43394689ad6c ]

Now that the calculation of fastmap size in ubi_calc_fm_size() is
incorrect since it miss each user volume's ubi_fm_eba structure and the
Internal UBI volume info. Let's correct the calculation.

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 2a728c31e6b85..9a4940874be5b 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -85,9 +85,10 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
 		sizeof(struct ubi_fm_scan_pool) +
 		sizeof(struct ubi_fm_scan_pool) +
 		(ubi->peb_count * sizeof(struct ubi_fm_ec)) +
-		(sizeof(struct ubi_fm_eba) +
-		(ubi->peb_count * sizeof(__be32))) +
-		sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
+		((sizeof(struct ubi_fm_eba) +
+		  sizeof(struct ubi_fm_volhdr)) *
+		 (UBI_MAX_VOLUMES + UBI_INT_VOL_COUNT)) +
+		(ubi->peb_count * sizeof(__be32));
 	return roundup(size, ubi->leb_size);
 }
 
-- 
2.43.0



