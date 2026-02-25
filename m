Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EB94369A;
	Wed, 25 Feb 2026 01:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982881; cv=none; b=QLNTIkIHW2mVzh9r9TXHI4DJpliH9KqiBpfc1D1fLfYOD997GtSKWpxTwC+c/5tu/d83A7T4tYsL0+UVS6mgfoxkYTJ3Tet/dpagWLauYVR7Mqk1E6A3ed2eLqT2f+i+WYIGVUN0eU8S39T6/fKE9s2FMHMGrtuOZejmMhIe+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982881; c=relaxed/simple;
	bh=tJrV0byCyfJS/m6rJXv0xQhBbR/hXOIRG9rqD8sHlIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdvfC6yleHC+P5+tc6j7KTOf3mm5x8VJ/G2gjM9vo164PLDZn6XVPi7vkX+iHSBLItWB8likD4QXesZ87ut7m9VeqQ6Greqv8eNqgl3WFbL83JQf4xDUozmWO6GTuFbXqLUy5uMkvo4u7hHMjVPl/Qq7LdkU3NN3/QWkLZbPCT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDuriNN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDuriNN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0A9C116D0;
	Wed, 25 Feb 2026 01:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982880;
	bh=tJrV0byCyfJS/m6rJXv0xQhBbR/hXOIRG9rqD8sHlIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDuriNN1PkQQ7ina4hmQZWwGRnaUGYDhbCe1i2JoavrXrxYdDBPM3LlQD2AtbMVqa
	 P+/6tBhvUe+FLOk5rC+OTjsXOLZTr95pldY6IUwrZAqdJpGwVFHIx8YDzcayNTF95e
	 PE3Uylchy0CmdASKjWzgyL2dnMnYbAkBi840Oapw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nurminen <jani.nurminen@windriver.com>,
	Fredrik Markstrom <fredrik.markstrom@est.tech>,
	Ivar Holmqvist <ivar.holmqvist@est.tech>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 022/781] i3c: dw: Initialize spinlock to avoid upsetting lockdep
Date: Tue, 24 Feb 2026 17:12:11 -0800
Message-ID: <20260225012400.246272729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredrik Markstrom <fredrik.markstrom@est.tech>

[ Upstream commit b58eaa4761ab02fc38c39d674a6bcdd55e00f388 ]

The devs_lock spinlock introduced when adding support for ibi:s was
never initialized.

Fixes: e389b1d72a624 ("i3c: dw: Add support for in-band interrupts")
Suggested-by: Jani Nurminen <jani.nurminen@windriver.com>
Signed-off-by: Fredrik Markstrom <fredrik.markstrom@est.tech>
Reviewed-by: Ivar Holmqvist <ivar.holmqvist@est.tech>
Link: https://patch.msgid.link/20260116-i3c_dw_initialize_spinlock-v3-1-cf707b6ed75f@est.tech
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 889e2ed5bc830..d5b0704040562 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1570,6 +1570,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	spin_lock_init(&master->xferqueue.lock);
 	INIT_LIST_HEAD(&master->xferqueue.list);
 
+	spin_lock_init(&master->devs_lock);
+
 	writel(INTR_ALL, master->regs + INTR_STATUS);
 	irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, irq,
-- 
2.51.0



