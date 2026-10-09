Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF764E1C9B;
	Fri,  9 Oct 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556322; cv=none; b=DUHvimI/z8De+q+nAt58dixegI0DVu6kobjNUlcJDec4I8fC1+EXZ5fSb0I5uCZA+7OV9u9W33w03cJQl+8Wvzo8/oPkqVe8kUwgZtX9TgposP0Rb7IKzS3GaRiZxnD7fIHbmnUePix4QudyxsR7J1ZFYCX2nV3b4ukBRpBiLwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556322; c=relaxed/simple;
	bh=tk7f8ql2zIm31hW+nIkC4fWdm2omppDr56otsgAUld8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+hXIFbCZ7EOKCd3+m4EW/9hOezjmL0p1aZSutt/L5ehJomi5Z2XcsJtz8kin2qrIVJyO6PPKWRVe6Cq9xkp30+0Iu32D97oq8eXZvpsjqz+muGJk+q+rGkpU9ysCcZ8noXG65FaEyWmEEg7CES52a06UyE9fYCJIZwzdvhCTFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQCkYeFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQCkYeFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729E01F00898;
	Fri,  9 Oct 2026 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556317;
	bh=+moEEeMis+6HVnZlOPRgLT8fYW+s8E3xrT2h7j5C6xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQCkYeFpJ8R45eAzSIJlgPBMwijH72EuZ2IkGu5t7l5PkQV7X/pvpfItdPJXXcv0e
	 viI1ZmjydPNOIAxIhTJfsvUJWRMw4cbDiSUhDhqVj0SyI9g1pRiDVEBn41wFYdc/gg
	 xHtQXKCgNiSYOUqlui8nkHefP9JeXitOAVhpozng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 157/428] i2c: at91: release DMA channels when probe defers
Date: Fri,  9 Oct 2026 16:08:14 +0200
Message-ID: <20261009140949.613698920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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



