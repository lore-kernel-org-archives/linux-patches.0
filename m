Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC139547046;
	Thu, 17 Sep 2026 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668393; cv=none; b=FQGwBmyfmL1+iUJC7bBadV/6bnPR55dlC6eo01jpTnk7JxO4+Xo4f2RJf7Qc1JjBqDIPdmSsLW3yjTShdaGUKfF9Ltr5M8Bt81SUnmxwb6UTCs6AOzEBk9sLPDR1/cjuDv/GpDdzQ5GWtFZmaoNn+3iF81xk5LbKmx9XzDbTrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668393; c=relaxed/simple;
	bh=zcJD/G4EIpOyQ47JWQPjODWWmBy+RUc+Bn8+QWllO7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIAfPCAQnf+37o4GADWTg30vBGDi4C5HZ1b/3L6lP45AOm5nx1IfmlXkf2bG3Hr9i+cHm3r9JCB9V8/jMSAOOCVmhYfHi4td3BRIMF3vIe1pH2jYUYoBTHUA1VlioSgbc8lbpgsXNM0I7PhYK6wfcIXMGMs6VU+0towwgZ7VsPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDHez/Sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDHez/Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD0E1F000FF;
	Thu, 17 Sep 2026 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668392;
	bh=D6QIJwDg8EAwsBR9xIrzI15io3Yan2w2E88i11QAhKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDHez/Snvz4GfXguHaxDnj6AjMjCMAWWPUQz1m+CX6u0kkinLEu3cIsNVh5GMs7Ee
	 h10nk+Qdf6uTLLwbkPBo/ULz/MnZ7nrB5QT4qPNs4a+TmPIkoTGCGIVsZxXK19eDl1
	 5PSr0//SHKoGWUpx2uDxPeGbi6icsYmmrywREZ04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0370/1102] spi: core: Abort active target transfer on controller suspend
Date: Thu, 17 Sep 2026 16:05:13 +0100
Message-ID: <20260917151548.940758536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit c1bab046d4786c5b17aab7c5225bf0d4a2a2d19b ]

When an SPI controller operating in target mode has a transfer in
progress at the time of system suspend, the suspend path proceeds
without aborting the ongoing transfer. This can leave the hardware in
an inconsistent state, potentially causing the system to hang or fail
to resume cleanly.

Fix this by invoking the controller's target_abort callback from
spi_controller_suspend() when the controller is in target mode and the
callback is registered. This ensures any active target transfer is
cleanly terminated before the controller is suspended.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Link: https://patch.msgid.link/20260625-abort_active_transfer_duirng_s2r-v2-1-1d6f724406b6@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9374c057f7ccb..780a8c4bef392 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3527,6 +3527,9 @@ int spi_controller_suspend(struct spi_controller *ctlr)
 {
 	int ret = 0;
 
+	if (ctlr->cur_msg && spi_controller_is_target(ctlr) && ctlr->target_abort)
+		ctlr->target_abort(ctlr);
+
 	/* Basically no-ops for non-queued controllers */
 	if (ctlr->queued) {
 		ret = spi_stop_queue(ctlr);
-- 
2.53.0



