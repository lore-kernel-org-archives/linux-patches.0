Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1251D33F59A;
	Sat, 12 Sep 2026 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214964; cv=none; b=iyx9/fMiQzONRnQc6fThKLPS4a/XKcssc4Y19ihjGb3SJoLQDkSNLV2dzuDtA+RqbNpBOx2edW9NN15rcIiYHfnhKZ8qUWXr0GmMnd9A+JchpAfUUPZZZAJUNUbFCPScQzFnawJfKaZTkGiF+JNduXRWZ7YDvUxLk48/KGZlPBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214964; c=relaxed/simple;
	bh=EmUI0TJLWt9+QYzg0opx417+opGNn0N1p7VshEgNV3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP0jI08e3WVeYZyh71bKJJqAwCntLF/gJJnY9TUXTLxsIvdBrspbg7NKJNyTK0iHO71hRrOiAVF6NK6Sfr19TlBVEmgIQUfyaEMbn4BrLz9eMbTP4OtKEnbeAiBN4wtbf29FFy0DOPVerYKTQBHJhHHkT+RC7qMbSbqeEzJDOGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uomxNZlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uomxNZlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8169F1F000FF;
	Sat, 12 Sep 2026 12:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214962;
	bh=vySQV7mcsTyIV2Ha6HeZI5r8J6+dRCUYPXQThD+3uGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uomxNZltyjsJlca5hx/DXQVFPsvmhDADwnMvtfG3me6r8Gr8BJ8191FiOGFfHUgs1
	 uSOmGE2Q1tnQSD0VnDT8WbJeh9PpOjy+H27MmiOC7BkgJPBKwlwApR3Kv6vg5Xky5Q
	 DQbe+RlLhqoKUib0B3yIlXD+9TJeEngF/TIIXTQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0435/1376] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 08:47:41 +0200
Message-ID: <20260912065617.229604294@linuxfoundation.org>
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
index 95d337978c75f..da9490dc14b92 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5216,7 +5216,7 @@ static int __init its_probe_one(struct its_node *its)
 
 	err = its_init_domain(its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5224,6 +5224,8 @@ static int __init its_probe_one(struct its_node *its)
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



