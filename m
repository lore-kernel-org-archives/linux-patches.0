Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C34C0414;
	Fri, 15 May 2026 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861167; cv=none; b=YdcU6SCBarrplMO0ereDiHVisr/e4fake6+pPa8JnY0SSijZRXIZJjU2IPGuRkEBRwnIZnfaGdDUieSa4TtF2KdXeA8hqPEfMaBxLTbBl+dPPKo1l4XAvUfxX/P7InTXgaLYog4R0jXuVeMta02d4E6miLhyZv/aHaPMtxkOj9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861167; c=relaxed/simple;
	bh=S6VxBVCVrBSLBTevUWxz/FYV4nhg8Jvl9X31vAEbm0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZQc/vNHOWly98w1ohJS3xSguj43ZTKRc6Dz4RXQznZ3tJXbzBEoqiu9R2tW+/mScRsawIUHBF1XtMgPPgEfT9Hp1b6E3OsFmmnie6Ki6K1LLxyX+AkQz78C19Kz6LDkB0dtayClqk4p5guC32AmNXhXjcKV7yFxbvLPpaw+/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhRdWi+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhRdWi+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02AC2BCB0;
	Fri, 15 May 2026 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861167;
	bh=S6VxBVCVrBSLBTevUWxz/FYV4nhg8Jvl9X31vAEbm0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhRdWi+m2lxAjNkDJ/Sn341cE0H69pElvHTsOKdHbGx026bYrrwEpeaMr58x0yOoY
	 80LDlEvdQf6s5kyTN4eipXNWA5OsUbwv72qSNlFGW9q3dI/Vqgu/pfipUCKd3DV/02
	 Ho6uBt/K0vkxvBWCK7SrcM50kF15fvL5Kr5wCLwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 224/474] parisc: Fix IRQ leak in LASI driver
Date: Fri, 15 May 2026 17:45:33 +0200
Message-ID: <20260515154719.854634663@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 37b0dc5e279f35036fb638d1e187197b6c05a76d upstream.

When request_irq() succeeds but gsc_common_setup() fails later,
the IRQ is never released. Fix this by adding proper error handling
with goto labels to ensure resources are released in LIFO order.

Detected by Smatch:
  drivers/parisc/lasi.c:216 lasi_init_chip() warn: 'lasi->gsc_irq.irq'
from request_irq() not released on lines: 207.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202604180957.4QdAIxP6-lkp@intel.com/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/lasi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -193,8 +193,7 @@ static int __init lasi_init_chip(struct
 
 	ret = request_irq(lasi->gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
 	if (ret < 0) {
-		kfree(lasi);
-		return ret;
+		goto err_free;
 	}
 
 	/* enable IRQ's for devices below LASI */
@@ -203,8 +202,7 @@ static int __init lasi_init_chip(struct
 	/* Done init'ing, register this driver */
 	ret = gsc_common_setup(dev, lasi);
 	if (ret) {
-		kfree(lasi);
-		return ret;
+		goto err_irq;
 	}    
 
 	gsc_fixup_irqs(dev, lasi, lasi_choose_irq);
@@ -214,6 +212,12 @@ static int __init lasi_init_chip(struct
 		SYS_OFF_PRIO_DEFAULT, lasi_power_off, lasi);
 
 	return ret;
+
+err_irq:
+	free_irq(lasi->gsc_irq.irq, lasi);
+err_free:
+	kfree(lasi);
+	return ret;
 }
 
 static struct parisc_device_id lasi_tbl[] __initdata = {


