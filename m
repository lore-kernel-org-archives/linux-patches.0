Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DB53FE348;
	Sat, 12 Sep 2026 09:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206595; cv=none; b=BQ1Aec2gwAygRkXWDW5XHY574WUfUKdEE99zcdb4E16KhSUfLKqZJAE8K0Kw42kd8Iof051KbJmtj3C+6x3WOzmF4HIdxhWPjuclS999l1CuItOZ93M1lzL1nvdB8RwGYdGydN4Be3XC+qezdqM4xb49YR1lkf9ATE8JdLMekCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206595; c=relaxed/simple;
	bh=hN6NWf9cZ2dLgdT4bbVccV+CQyf32FRZI2AOTZCoAeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbqEyrCxBZpb9LJrlkTpzyk3AvjUlBIKhU8VAFzkPJYghu0Pi6Bj87X/9DJf8fXUONOmfQT0B/gnx+7tNaTOAbGqhE497P/mC7L2KtFH9aH0FJqDAhtzsAfOmyNcBcCTZFVyVpH+wUc2oRxPdttjCsSr4THotPUx3/2McI4TSBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IG04SFk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IG04SFk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70A31F000FF;
	Sat, 12 Sep 2026 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206593;
	bh=UXHviGJgMOQh4E0LhyLTNh7KVS1fPgOEAPCgdS3ahgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IG04SFk1SOuqvnQiyWRt07MaHk/f7oGFj+UMKhZOzLAsXuz51qx4NJqjzRkBkfyOw
	 QYqzTIoWiIeL5e35i2oexMG4ZjgUyBfZXY8eNk16ABkH7x3FYhCUk0nQwYdJOEBy6N
	 Z5MVZOXno3oQtK2H1byb60un+FgWXHTGZhSxF0Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0240/1518] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 08:40:09 +0200
Message-ID: <20260912065628.912430660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 1efffab6fe336a5c4fd3c2886f255cd2f998e65f ]

Fix collection leak when its_init_domain() failed in its_probe_one().

Fixes: 4c21f3c26ecc2 ("irqchip: GICv3: ITS: DT probing and initialization")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260702033050.1583-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index a1661657391d6..fb67456e301e4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5322,7 +5322,7 @@ static int __init its_probe_one(struct its_node *its)
 
 	err = its_init_domain(its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5330,6 +5330,8 @@ static int __init its_probe_one(struct its_node *its)
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



