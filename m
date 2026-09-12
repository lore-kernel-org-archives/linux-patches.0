Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBEE4BEE54;
	Sat, 12 Sep 2026 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206095; cv=none; b=GTW/ULc26nOBofjX87exUC6FZ5D6a5KnosIUacSGG5hR2qMy5toGivHEddPrvXC0FuzdGO/avse33iolxU7I+YaLyhW8QSeiuoNX9jBbjSs3EAWY4CuM6GwYfUsTs9igUhC2HOB4NDYhdgD3eBSeAdW7fG0X/Op0D7Fmyevc4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206095; c=relaxed/simple;
	bh=n2UU/kkmypvfrWCO6JT6WUC/6p9QM9Tbszp+nnsUAzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADk6iLaOVTCcqPbhpG1Za/UJNbQWfKiCJrGKvm8CTa9KS0guRX7Lm9O3SGPn4USsk0aX/OAac2ojzDgMXiVL4xpI+Tz63o0eUGt6wAkJ+p6cId6or5pxOBoauTbiL07faPIqwSlKBkXeCTXCwhyeGw+j19guf5m+nGvJVV52ZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAPUQlGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAPUQlGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6871F00893;
	Sat, 12 Sep 2026 09:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206094;
	bh=V6uAd1wA18qhtW9s0k3S2wSDDBsjJEr/mYGwBrqm/oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAPUQlGn8rfdmGtb4sVou/nqganApYLKJ/1eTS700BY0gA8NzS4b+7dDrlUmJ3qm5
	 tKWUVrgVe/AtOvGnyDn4WrfCmEYDh0NUpK9DVcc7KUhEqNjdKCTUhoLdoxi7kJIMbu
	 buKDA6VU0fDAM0exH9O0vdTGfsmNoQz1SCLvcTeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Min zhang <zhangmin2026@yeah.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0134/1518] clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller
Date: Sat, 12 Sep 2026 08:38:23 +0200
Message-ID: <20260912065626.523438450@linuxfoundation.org>
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

From: Min zhang <zhangmin2026@yeah.net>

[ Upstream commit a8036f4591542de4b38ec81d3e2ba47bc0b2652b ]

Using devm_kmalloc() does not zero-initialize the allocated structure.
Uninitialized members in struct hisi_reset_controller may contain garbage
data, which can cause reset_controller_register() to fail unexpectedly.

Replace devm_kmalloc() with devm_kzalloc() to ensure all structure fields
are properly zero-initialized.

Fixes: 97b7129cd2afb ("reset: hisilicon: change the definition of hisi_reset_init")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Min zhang <zhangmin2026@yeah.net>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/reset.c b/drivers/clk/hisilicon/reset.c
index 93cee17db8b16..c3b7daac93132 100644
--- a/drivers/clk/hisilicon/reset.c
+++ b/drivers/clk/hisilicon/reset.c
@@ -91,7 +91,7 @@ struct hisi_reset_controller *hisi_reset_init(struct platform_device *pdev)
 {
 	struct hisi_reset_controller *rstc;
 
-	rstc = devm_kmalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
+	rstc = devm_kzalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
 	if (!rstc)
 		return NULL;
 
-- 
2.53.0



