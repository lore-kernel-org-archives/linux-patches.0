Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF652517AB;
	Tue, 29 Apr 2025 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947394; cv=none; b=dnUUZ26A5iexe6tu+d6nKf3jrWwX8P+23lowfsdiymk345DKgzhVmgJq3r8vN9Su/RbzJv6x4I4KYm0Xn5txERLIH7YfCPJvNgdI1WecuW5IePVUM8AzVPsBcPZ3z99mVz/VGp0FYuPtOLPf7LpliBpMbLBpWss2D4bMwUaThgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947394; c=relaxed/simple;
	bh=4vmcc47sv9t5ZUDwuX0tBxjqDYkg5t8wtRnCHBJtacY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcKkzH+8VrCkFbb4nJWFx1fl3e57FgQMU9Utg7gjPd2YDCg+uvAecVJvgkysJavZGzqDXZSNw/rUJGnP5X0IkzSL0ItByCRXiIB5y/i1XREmGNJoapmYq0lRFqoV+T8DONHZ+r7Bg+lcx14fiLg2DiFnOn/0otD1b+1PALDDpN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ct8nGRin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ct8nGRin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ACBC4CEE3;
	Tue, 29 Apr 2025 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947393;
	bh=4vmcc47sv9t5ZUDwuX0tBxjqDYkg5t8wtRnCHBJtacY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ct8nGRin7xMVy+mGvQ2nLSSFBegA6y8mOpt4V3OJm0DtCZyd7H3098koz67iMQpZm
	 21Ua2gsXHyuuODTsFtuRUSG6M3T2gIy7k5iWOhkMki8QT/uXv5kMJEE32utw0+4zvi
	 dRUe/UTN/0pU0N60tTIVOQgZpalLy1SzY7/vmP7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/286] usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()
Date: Tue, 29 Apr 2025 18:42:43 +0200
Message-ID: <20250429161118.572954959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d268306a7bfee..92755a2fe4ff7 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -543,6 +543,9 @@ int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx)
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



