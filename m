Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190CA657B3;
	Tue, 23 Jan 2024 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971804; cv=none; b=KEpwQOUw83pDY+Aqxjhms5UAtiAauEoLozp09RA6NrUV9NLEOvOwFS5Gzb8ZtDtBAg0eCh2WF93VaJKK/o9OMUQmkW7rXVxV0fe/ORTEFXLq5Iuapsa0KL72vleMdB8O+C8FMWLYQcrUFem2TqTmL2e1rfJnquHVcj7CdmDvdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971804; c=relaxed/simple;
	bh=th+8Mt5GAeUsSH9c2LOA9AT94Jh2Gc/wvIYclWubokY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPdWLvg9y7yZJh0QFraCNcC96rI/70rCk2QcQaN2z/fKavhxaWq6i5XN3elWwJkauIJewyFXbwhL+kdDcUqkBEKSEDz+QKxkLyTejeh3voSVV469V1uF3mNa6M/+4h7u17x0anRybys0jZqPojTkeOJo5F6vVHxuU2uXiiqYUqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/Z64qaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/Z64qaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26B5C433C7;
	Tue, 23 Jan 2024 01:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971803;
	bh=th+8Mt5GAeUsSH9c2LOA9AT94Jh2Gc/wvIYclWubokY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/Z64qaSBJ6Ph7JExWp6aFxUjGKXsq85GWvhoi8U8FTub+t5ec333QlOg+wfQ6DEb
	 Feo0D3j4gDLmgPL5KB0sVGgMya1m44sCZzPa5vW/C1ybnnsZngUxFoJAbSLnTwA1WD
	 t9Rj5Qv7Pmebeq4Jeu3mYcjvWHB7261l6ZckY83Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 324/417] mfd: syscon: Fix null pointer dereference in of_syscon_register()
Date: Mon, 22 Jan 2024 15:58:12 -0800
Message-ID: <20240122235803.024724908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 41673c66b3d0c09915698fec5c13b24336f18dd1 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: e15d7f2b81d2 ("mfd: syscon: Use a unique name with regmap_config")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231204092443.2462115-1-chentao@kylinos.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index bdb2ce7ff03b..6196724ef39b 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -102,6 +102,10 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	}
 
 	syscon_config.name = kasprintf(GFP_KERNEL, "%pOFn@%pa", np, &res.start);
+	if (!syscon_config.name) {
+		ret = -ENOMEM;
+		goto err_regmap;
+	}
 	syscon_config.reg_stride = reg_io_width;
 	syscon_config.val_bits = reg_io_width * 8;
 	syscon_config.max_register = resource_size(&res) - reg_io_width;
-- 
2.43.0



