Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE421B4C48;
	Thu,  6 Jun 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683449; cv=none; b=KM8kpR4elV1zi/QRZ7pSWwsS2QhawEvBm/4VOQ8gx4ScbccOfMTytUGiNPUYGPG1hv0xaTMusS8U1EOw6ux+ByRTESVSggdBC/Zby+Z30AeMe5/W3JF8inwD5GQZO12/VJIjjq+BB2ab6OBDzJjpAFJk6Py6OmfYhKKaGoSpyOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683449; c=relaxed/simple;
	bh=T3rNCRRL1kohM4+BXx1KCIxwpEZELSxuzzzlplkOhZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B99npdxHZ8/i8uqzxUqQZncGzlaFN8wVCZyRUEGMMOcrjZmoeow1MZAU6AMMHYlKXDxMvSTKdPPqGxI5CaZHT6+73X0hke74G1PbXEm8mECXoeuP6+wxqjxT3BSqQQCMRFZwkA1RyxzjXMOJPSTG7qZYmY/lXCsp+8G1FXM5Zxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8LbSzj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8LbSzj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE034C32781;
	Thu,  6 Jun 2024 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683448;
	bh=T3rNCRRL1kohM4+BXx1KCIxwpEZELSxuzzzlplkOhZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8LbSzj4XVUf9eQVWA/OdNpO91cROMK6Y8gsLEthOytLoe+m7rL2NOHroSK6poI7Z
	 FX2PX0WBFzhU77c/tbbBqy3qHjyQ1aLhS7R4HEN36rXGnqoX1z8kJ1xYNcx+xDn0Ly
	 KgGJUjL8pQ8zIgzVWmE5pVPmjzNI4VGN1DlmFVRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 333/473] ppdev: Add an error check in register_device
Date: Thu,  6 Jun 2024 16:04:22 +0200
Message-ID: <20240606131710.932925947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit fbf740aeb86a4fe82ad158d26d711f2f3be79b3e ]

In register_device, the return value of ida_simple_get is unchecked,
in witch ida_simple_get will use an invalid index value.

To address this issue, index should be checked after ida_simple_get. When
the index value is abnormal, a warning message should be printed, the port
should be dropped, and the value should be recorded.

Fixes: 9a69645dde11 ("ppdev: fix registering same device name")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Link: https://lore.kernel.org/r/20240412083840.234085-1-qq810974084@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ppdev.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index f6024d97fe70b..a97edbf7455a6 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -296,28 +296,35 @@ static int register_device(int minor, struct pp_struct *pp)
 	if (!port) {
 		pr_warn("%s: no associated port!\n", name);
 		rc = -ENXIO;
-		goto err;
+		goto err_free_name;
 	}
 
 	index = ida_alloc(&ida_index, GFP_KERNEL);
+	if (index < 0) {
+		pr_warn("%s: failed to get index!\n", name);
+		rc = index;
+		goto err_put_port;
+	}
+
 	memset(&ppdev_cb, 0, sizeof(ppdev_cb));
 	ppdev_cb.irq_func = pp_irq;
 	ppdev_cb.flags = (pp->flags & PP_EXCL) ? PARPORT_FLAG_EXCL : 0;
 	ppdev_cb.private = pp;
 	pdev = parport_register_dev_model(port, name, &ppdev_cb, index);
-	parport_put_port(port);
 
 	if (!pdev) {
 		pr_warn("%s: failed to register device!\n", name);
 		rc = -ENXIO;
 		ida_free(&ida_index, index);
-		goto err;
+		goto err_put_port;
 	}
 
 	pp->pdev = pdev;
 	pp->index = index;
 	dev_dbg(&pdev->dev, "registered pardevice\n");
-err:
+err_put_port:
+	parport_put_port(port);
+err_free_name:
 	kfree(name);
 	return rc;
 }
-- 
2.43.0



