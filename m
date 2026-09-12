Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39036404D;
	Sat, 12 Sep 2026 08:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203134; cv=none; b=DO8a5/9FJJWytJvRYO/nV8hsr2W39cQpk21g/yMcKsjwjK1FatM/SUOYwNHM8z5c1S2Aq2ZEoi3c189d5kEnGdPqDwwSVyqYovdXyfvq/AS1PXjgJqZeP5qvTmvUn3ICkyWaob03dIP5l6z8KaynhgI50W6860R2dR9jEDJbx+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203134; c=relaxed/simple;
	bh=Y7yq4Z+D4XJ9YmMqVtYLJnrDk+FpUD3xLp68WzGj88E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rolEVLdaNiAkV3F4a/96vK4yrxbF6+UAvuflH+7xDoRFjUBw1HkHD7LKkqVMK4pDbwHqYLhTTypB/0hFMLQf8wqsozh2gWrW7mtIPBCtds5lmomwZ1v1DH3BDKTgGIHMWgX/FCucQpq95JFggrh0fH48jIdn3cMeGHl0QBl/WeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRQ01EU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRQ01EU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55341F000FF;
	Sat, 12 Sep 2026 08:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203132;
	bh=yEi22N5STceQMty0T3GCYJxZ4kgIh3fKSA0WgMMAGOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRQ01EU1deLqtepw/4zVwyJ0fYhciZi56DauuyR92pc/GAM3C/QinTt9gii0XVI3C
	 hNnVMLuq9FrkeZuiuNbO6jM31xmH81ofxxgIKjcurT1NUABMM6rzTdz0tNG/5AynhC
	 /wn/6DKm3WB2YjLX4voylInayhyuLjszcpfarEM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1346/1815] nvme-apple: Require page aligned buffers on the admin queue
Date: Sat, 12 Sep 2026 08:51:36 +0200
Message-ID: <20260912065720.619941796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit ea2160c7b78187ea9ab08c3190eef237c4ee99a7 ]

Now that we have a quick to align buffers on the admin queue to the NVMe
controller page size use it for Apple controllers. This fixes pre-M1
controllers, which always rejected unaligned requests, and also makes
this driver work for M4 SoCs and for M1/M2/M3 SoCs that have been
updated to the firmware shipped with macOS 15.

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 0c3f371c792f2..e67a125e9b87b 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1599,7 +1599,8 @@ static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 	}
 
 	ret = nvme_init_ctrl(&anv->ctrl, anv->dev, &nvme_ctrl_ops,
-			     NVME_QUIRK_SKIP_CID_GEN | NVME_QUIRK_IDENTIFY_CNS);
+			     NVME_QUIRK_SKIP_CID_GEN | NVME_QUIRK_IDENTIFY_CNS |
+			     NVME_QUIRK_ADMIN_PAGE_ALIGN);
 	if (ret) {
 		dev_err_probe(dev, ret, "Failed to initialize nvme_ctrl");
 		goto put_dev;
-- 
2.53.0



