Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13BC1F63EF;
	Tue, 21 Jan 2025 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483136; cv=none; b=g3YnYcllL21EybWgdFRiSzJJoeuSnbIeoY7haYxUddOpC2w9vIJ87pFyspV5UfEGbrLT4XkgZqs6iafLeBr43Q31cUkbyC4Jy45M6zmL2K3GlkUTss5rBDEtkjW80Ky/675xuKA9+fwi+cDritJEUrIFKG1HitQ0VMiV+rKLkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483136; c=relaxed/simple;
	bh=400yZGuiW6bZXFNcy0Pperb59RzFjuJZg2ts+pM3bz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6Bjj7dbVk07XPLyPqIELbpXYQZiNWRU/k2/u5pJvYoKccdS5LwxNf9tSHsP1grE+RD3vMT0WWZUN16Xfa7SOY8iQDW4eqp/UTO9ZykQciYvn1b8G5brcaZ2fzkFQIzLFQPMgc8U5ruelnKJcwqxyfEhxMLBNpOqjULxmmrDAOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylb+cUuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylb+cUuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A7EC4CEDF;
	Tue, 21 Jan 2025 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483136;
	bh=400yZGuiW6bZXFNcy0Pperb59RzFjuJZg2ts+pM3bz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylb+cUuAERcyrk8YV//ZO7IKs8MqRTDGJCKhP4ChoZEesmBy2Thy201rf2cHtWe9V
	 xPI9dAg7qDhjjN35rDglRUAyShcrRm/U82n85vPSmOKpMimMqommAoKwV5ilPgkd7u
	 ygWrEN/54soQPHCf6uQZfNNzuWjs/uWXkCbGV2xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/127] zram: fix potential UAF of zram table
Date: Tue, 21 Jan 2025 18:52:55 +0100
Message-ID: <20250121174533.625164090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kairui Song <kasong@tencent.com>

[ Upstream commit 212fe1c0df4a150fb6298db2cfff267ceaba5402 ]

If zram_meta_alloc failed early, it frees allocated zram->table without
setting it NULL.  Which will potentially cause zram_meta_free to access
the table if user reset an failed and uninitialized device.

Link: https://lkml.kernel.org/r/20250107065446.86928-1-ryncsn@gmail.com
Fixes: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by:  Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4e008cd0ef655..6da0c98a1016f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1174,6 +1174,7 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
+		zram->table = NULL;
 		return false;
 	}
 
-- 
2.39.5



