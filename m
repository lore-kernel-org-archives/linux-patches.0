Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B2521E098;
	Sat, 30 May 2026 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163893; cv=none; b=uj+BB38CKbERNgF6OK8k0O5OdQVKpMsbVd+L9ENvXPBq7ytBeUhVl+CTJj8pzJ08z4Acryi5V/PNSkmQm/dbuWPD8W7jdMWjG0xdAKnrJYvWd4jhfQM7/RRt9FOKy53Arzk4nhwItpqkrJcZYA5X4qJpwjE8Ky7OqvfQz278R7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163893; c=relaxed/simple;
	bh=z52UjLNRVw/BsM+L3pCd5HNEu4jKVk6fuup0GDXfkX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1AeQlhi/Nzy00sak282jltrgzi9hAdyO7bqcqnAreR2XUOUyo2BThMa9ZKlwQH6YDr7HTrWDYs/cRa2Ep+Vw/UA0aaOazlMBrdU9/i8TPmphUYuTth3EVpuVh2P/DBYOcUV0jvMs0qPA64lSu6orJ3bNhF9YQ7ZHaenQLG6b9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXwobqlp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXwobqlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6572C1F00893;
	Sat, 30 May 2026 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163892;
	bh=XrLC/EgkLJ9YFeTfnRHeyWrfTdLtex1iHlf7nGNhs5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXwobqlpiNzcI0A8Deg3uVc2ljJqfk3TsMcQkQpBM4HcHjP7TEpjPfLdsu5/fL6kE
	 pGNXYlBHP+AqDPWVNs9aHv8CPGtd6N224ayIYurCDxXQKUbRiJ5jnE3hLMVTEnxGMj
	 UV/FwG+vg814K+gFz2IkxVrLH8S0EnYsWAgUoQNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 364/776] spi: mpc52xx: fix use-after-free on unbind
Date: Sat, 30 May 2026 18:01:18 +0200
Message-ID: <20260530160249.970881253@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 706b3dc2ac7a998c55e14b3fd2e8f934c367e6e0 upstream.

The state machine work is scheduled by the interrupt handler and
therefore needs to be cancelled after disabling interrupts to avoid a
potential use-after-free.

Fixes: 984836621aad ("spi: mpc52xx: Add cancel_work_sync before module remove")
Cc: stable@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mpc52xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -521,10 +521,11 @@ static int mpc52xx_spi_remove(struct pla
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
-	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	cancel_work_sync(&ms->work);
+
 	for (i = 0; i < ms->gpio_cs_count; i++)
 		gpio_free(ms->gpio_cs[i]);
 


