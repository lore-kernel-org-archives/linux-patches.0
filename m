Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3391D3DD87C;
	Tue, 12 May 2026 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608510; cv=none; b=mNlf1myE0bIMKbvjTuRkmXmvXndfOOxegiTzzdw56PrRGKvrTsJRpSruyAM7JgtIyTLgJewqzgg8VhN6lZjLZFl5AnRUhKjELuGaoE0AQ6sIoYUOWGZ/ZiyZ4Q0IhZ9nQRQsQEivxUinboyL8XEvjT0myxt3f6PRGB5JM6VmkeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608510; c=relaxed/simple;
	bh=icm01Kk5K+RdajgPj3m0DDVCHJwr+ja3p1+JtorTE3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHcG56LFZYSDDqbmSBZMidIHbFbhWjbFExtK0eMiqj9BtoMwIj1ho+S6DvNXbzCd7PXgW0U70Q59Ojco8MzPXVOV4rqCsFoCffjSplpOCM0u0q8hwx8hx5dcFWSMrnr9oh8fzG3fEG2KTVpuATSeeVF2qI7DdjhGZjGHi6KnWjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMVPh/8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMVPh/8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFADBC2BCB0;
	Tue, 12 May 2026 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608510;
	bh=icm01Kk5K+RdajgPj3m0DDVCHJwr+ja3p1+JtorTE3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMVPh/8rco13DlaYLCspTQqkIkX2Lml6ySI5ifBpniP9OZfKvbFWTbKdDnU1fW4Tb
	 K6COWxIWTE9MoccXwSj85h+w9U63OYPp+GabMZr4YHbFmy9PPVzqnl0smezZJfQOFv
	 u0uxdCfZ+GxIhBeH0d9taK7mpVDCY9Oj8II2xjd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 106/270] parisc: Fix IRQ leak in LASI driver
Date: Tue, 12 May 2026 19:38:27 +0200
Message-ID: <20260512173940.689863688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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


