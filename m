Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7734B247280;
	Tue, 29 Apr 2025 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949491; cv=none; b=dwAIk3VvZoSLZBIEamxzFZQrLpAMzHNE1V9bWX8Qegky5dmSLlxMaiSZTMrAsAA0Vhi3fr/yr+/UvnhGEz4aKberxcd8WNljeJVvtRhpHzLGcekBTRExx4hxG5dqA8iOnFfhJd9fPGDQwc93c07GGXGcgHvbBJVxbwFaa5USKec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949491; c=relaxed/simple;
	bh=fpitSxlpB179KoL84r8NAxOkmLTko1yx8IjMsA/FlM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFyc73mAOdrN+MQWOpWKvRqp9SN6S5GSJ331I6d1S8ua5PBtFoCMPCwEw2OZIKFUlWn3q3kyJSmkF9U0Lr6cpZbZ5X5iYxSrjP9VdT3FFtZHz2/qvbIytXSQEBncFAkAFSIl7LN8Vow7PEUSmqjO0HlP6y1gCzpTB/psX+p3Ix4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbFoTBzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbFoTBzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CBBC4CEE3;
	Tue, 29 Apr 2025 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949491;
	bh=fpitSxlpB179KoL84r8NAxOkmLTko1yx8IjMsA/FlM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbFoTBzCbyufadQIVpjLOUb2xVBeHcTeUQiWTo/13m7JHcEwPh84u2666F7DOHSsV
	 vbJOnBxvk967oiSp93j9MUzA2Ncla5UESwbCP1LrweUmx2E846AHW4sDOTNcJU+qo0
	 4HVn3I9FLqYKfSVdO/3Uizx7EjF6vD5Dynh4IXnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/373] usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()
Date: Tue, 29 Apr 2025 18:43:32 +0200
Message-ID: <20250429161136.909173171@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 8c75f3e6a433d92084ad4e78b029ae680865420f ]

The variable d->name, returned by devm_kasprintf(), could be NULL.
A pointer check is added to prevent potential NULL pointer dereference.
This is similar to the fix in commit 3027e7b15b02
("ice: Fix some null pointer dereference issues in ice_ptp.c").

This issue is found by our static analysis tool

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250311012705.1233829-1-chenyuan0y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/dev.c b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
index d918e8b2af3c2..c5f7123837751 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -538,6 +538,9 @@ int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx)
 	d->vhub = vhub;
 	d->index = idx;
 	d->name = devm_kasprintf(parent, GFP_KERNEL, "port%d", idx+1);
+	if (!d->name)
+		return -ENOMEM;
+
 	d->regs = vhub->regs + 0x100 + 0x10 * idx;
 
 	ast_vhub_init_ep0(vhub, &d->ep0, d);
-- 
2.39.5



