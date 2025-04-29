Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205B01A5BBB;
	Tue, 29 Apr 2025 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949963; cv=none; b=bn92EAa0CmdKHZzKjIkp/nTeJE3nUNyCXlLjSmVMt6s7gY7WUn3+x8qSST+ILUSdTQhHneSfOZUcM+uxy2RcyyQeZvFK+E6r516MFaZ7zoukED7/XsVhU2Xny1rB533LhWzpHBPhOfPV0mgv6XL9sc+/S6FUgmgWHWJSzPYy+TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949963; c=relaxed/simple;
	bh=uDIU7TwmsW3ef5b1wqiLMq/2hoIGI0w9iFX6uuIcqaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utws+nQb1XTjGoFi7q8L8v5skM4vWvleh4ugRWo2bwOp+RoQ+8Lqm0+NR8pIWdn9xC93lWnUoP42nm2Wa0Vmq47OUXDVfU6/w/aFBsDV0ZkY5eWGko15ZTOxVwXcH5HvskATQEJm3PFrJVAvntaYk8betJRmtE3h6ocB22mzUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLc535+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLc535+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4022C4CEE3;
	Tue, 29 Apr 2025 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949963;
	bh=uDIU7TwmsW3ef5b1wqiLMq/2hoIGI0w9iFX6uuIcqaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLc535+unApEH4uusPknk7AzRnYhwK0SUo8Pw747541LQTi1fhZxr/vO0J1HMwF+z
	 CO0ZypPsPXg48Lpqibai5C/3sFOVpUSnRPdlGCm5wPtBEqaG42TXeRC8rYxuUfe0sj
	 PcU6Y32lYmrP5kJKP0G6WbvjkqkgP4I4ti0i0zps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/167] usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()
Date: Tue, 29 Apr 2025 18:43:40 +0200
Message-ID: <20250429161056.272151788@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4f3bc27c1c628..73664a123c7a0 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -549,6 +549,9 @@ int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx)
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



