Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9BD3BB12B;
	Fri,  9 Oct 2026 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555869; cv=none; b=pliU/jPdaA7+E/+xUVW3uG56hWWCL4dPdLoiwH5Qf6g7V4AOqewdwZ8LlzsILdju0rv79q142TWScwsYR0YvWmdQo0KX8w2AWYCs5DDDk7JrDOXLQdM31uv+T+ODJrm/47dlqKnhZEAMzv/ZrxRbL7ZqFGLYGLEs+sK6jubb828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555869; c=relaxed/simple;
	bh=NPziwwDSEgNAJP8+hbYpAl/ZxK4gzKbRqmoburY9w1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu+uOlFtS905XbUjCXJBI8k0/aMBg01NdFm9RkTzMTqOFzQqZrioKqo0FkvTaNVGq66L+0YHJkZcIb0e1ductRIQ8ZnzM1YwwRAZKgWF8/1Y9xL+wmSRUysFKuxR4SAA4RWkNoxyFAP09Dk08sZF/jJBwzY5kGNhoGj8KevN6j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSp5XzDR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSp5XzDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED60D1F000FF;
	Fri,  9 Oct 2026 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555868;
	bh=mY4E1Cc5uCp1VpSX+QBQeAlkMRjLoPhLX/IU5ZwfzYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSp5XzDRAW9SO9P+FQWqVooskzTs2Jm/yRnsvlsXSHhfcN1y54243R16JBX4hKMwe
	 q2Z2IF9xJJE1i2og2vTnlJdFKOwVnU/p5GlpwBtTHBR+CCVJqxyPH8Vhru8EN125Ah
	 u542d8t8JJlQpmOTCtekZRyqItCAQkBJqoDx1EJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/403] i2c: at91: release DMA channels when probe defers
Date: Fri,  9 Oct 2026 16:08:12 +0200
Message-ID: <20261009140955.139628479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit c98bf3b86609a18ab16d067280257326e557c636 ]

at91_twi_probe_master() can return -EPROBE_DEFER from
at91_init_twi_recovery_info() after at91_twi_configure_dma() has already
claimed the tx/rx DMA channels. at91_twi_probe() then returns without
releasing them, and since dma_request_chan() is not devres-managed the
channels leak on every deferred probe attempt.

Release the channels before deferring the probe.

Fixes: f7eeb1af8537 ("i2c: at91: release DMA channels on remove and probe error")
Assisted-by: LLM
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/7D85C6CB6BF0A82E+20260929164340.41628-1-daihongjian@kylinsec.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91-master.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91-master.c b/drivers/i2c/busses/i2c-at91-master.c
index 68238cc8aee0d..e0c3de5e82033 100644
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -921,8 +921,14 @@ int at91_twi_probe_master(struct platform_device *pdev,
 	at91_calc_twi_clock(dev);
 
 	rc = at91_init_twi_recovery_info(pdev, dev);
-	if (rc == -EPROBE_DEFER)
+	if (rc == -EPROBE_DEFER) {
+		/*
+		 * The DMA channels were already set up above, release them
+		 * before deferring the probe so they are not leaked.
+		 */
+		at91_twi_dma_release(dev);
 		return rc;
+	}
 
 	dev->adapter.algo = &at91_twi_algorithm;
 	dev->adapter.quirks = &at91_twi_quirks;
-- 
2.53.0



