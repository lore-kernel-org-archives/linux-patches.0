Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633E67E110;
	Tue, 29 Apr 2025 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948072; cv=none; b=Ux6YNMl99ab0iAIGw6v+OKoOCm8JQLAkqBqL+U8JZJNxRbrGFfFzpBwTyiY/bSuwBcPjjipNs4VAin600MFuX4IY690tvdSno+eWyahGgyCkUP4bR4tHc96530ZSf4xZ5mcx3jFRFW6g2NnRWJk39ze4U1HnOkMSg1+Rg2o1D30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948072; c=relaxed/simple;
	bh=hNpXyFwQ8vSoaq7Pv//9e+zBb7m+AFR5VbLf6gyGSBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnxhNmkj/V+RkGXOVTMj3ogmFUIY3xK/2cLM7sH0cuEB4SsyEjKPLqRCA2qhEXlUEcq7m/eLyKbjXetuwl2qFN0DkVoif49q0dSN7LJBL/+B38qaUsalsl7bMXp15Z9+N2SzawBI1YMyZRKeTCFrH5RYyooGZc4NLGcPMRi4rL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGz5TUNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGz5TUNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E6DC4CEE3;
	Tue, 29 Apr 2025 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948072;
	bh=hNpXyFwQ8vSoaq7Pv//9e+zBb7m+AFR5VbLf6gyGSBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGz5TUNbzB4MGUS6O/wi8+lXp+56/JOFNyx8qDBjnIjBMH6CJu/elIji6EfkwhZ0q
	 8jVMyV6sccfd4wHmONbX3laqLPwPRIO1cnt23Hj7OcQ/Bg5uQgHiKrlZ+3+KgC+ajY
	 1k12pHCcnHfdzEz+MVrigspaz7Eb6IjwRtzyVWdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/280] usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()
Date: Tue, 29 Apr 2025 18:42:04 +0200
Message-ID: <20250429161122.596836515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 573109ca5b799..a09f72772e6e9 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -548,6 +548,9 @@ int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx)
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



