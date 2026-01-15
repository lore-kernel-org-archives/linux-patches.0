Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A03BFE5F;
	Thu, 15 Jan 2026 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499164; cv=none; b=TXzsKOE0LjdDu4UZEfT81ZOQf9cPBRQ9OjFWkgShqtBDmwiLKNZPMEpSJ5IpRxyoXzGjahmK58390Mf4oyoPEmXZMECwEPA0bZkR9KV5pKdbzRDg7aopR8ZEcVUvpfeZEX3AaM1fWLDmrGW26Fvfrb8UtDSvxrNqBVI2lxjwA04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499164; c=relaxed/simple;
	bh=Qp7NBGPs6IsJPeEAISnh2LK9QXV2BhX7e+ub5IFyUGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1FBPRXRM5V2mo0lcnH5sMSX//X+vnzK0AoljBq4Es3YJgsUeVziznwFoDHh9nvdieEWYMMI4w6I7mt+vfKVftFUJnh1xRP/R5dNdMagU2GFh2LhyoyOk5VRq0BqaNLVeIbzJh4AoFKbk8+hX9DoA240s6IAnhRX3+FBQFypnV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4mkDEYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4mkDEYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C09C16AAE;
	Thu, 15 Jan 2026 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499163;
	bh=Qp7NBGPs6IsJPeEAISnh2LK9QXV2BhX7e+ub5IFyUGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4mkDEYeOSy8IiKXvZdKjJNd5N8J0ipP8feUVgWV1bj3GTrZOgJ+AOfXlr3ye9bnl
	 QjeWQWvy+6ShlCczoV7MDoE8nByBDK5MlOlwrayEaF94SGSv/RkXY76IgJmKQIZMi+
	 wMj/Ev4u3T71MaFiVoyGHIEXx6qidBRl3Ux2/9BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/451] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Thu, 15 Jan 2026 17:44:48 +0100
Message-ID: <20260115164234.064237062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 384bd58bf7095e4c4c8fcdbcede316ef342c630c ]

If devm_request_threaded_irq() fails after irq_domain_add_linear()
succeeds in mt6358_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_add_linear() to properly release the IRQ domain.

Fixes: 2b91c28f2abd ("mfd: Add support for the MediaTek MT6358 PMIC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121427.583-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6358-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6358-irq.c b/drivers/mfd/mt6358-irq.c
index db734f2831ff0..db89da7b98f1d 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -227,6 +227,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



