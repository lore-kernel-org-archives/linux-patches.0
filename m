Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4486051B196;
	Wed, 30 Sep 2026 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784656; cv=none; b=u1iedj9BbjBA7dgfuWwtqobQAF6QKJuAqgW2SpWp6Bc0JMLGKfZ/ddcDgjfp5vkhbTvybARNZhlVyNiQF7MzI7u73OF1OXFvRPum4h2ySDml+2V1S7UqCIhGOGXIgCBCu/gFZ2re92w1+THljU0CjFeO+iRjV/kG2yVavwvjfoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784656; c=relaxed/simple;
	bh=9PFIg+Cq2y9uzHtqezbwoeXrLI5IBUVDgBPKhG7Twck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIUIuv4jDyr19jVoXt/irhFbCUDtwtyHRHJ2EpKHZf6Bmr/AprtGVUeA+7q9mgUd3h4X8CWd9/gazdiXGRbBLHkBRiKyOWzbL/tibxIuKzCV4wBBJ7BR0VlVwEjFTMppRRBbPrhfBFIWw3n/s/KvOYO/B1Na06dk8AXw3mOduHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRmHNC0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRmHNC0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725D21F00893;
	Wed, 30 Sep 2026 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784652;
	bh=OqqrML3E0PjOPEX21bWpPinuem7g8Haf/aCnPzE9KDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRmHNC0bIL8TFYZVX1A1k9i0G5YGZLFWt4sMIH5D6fRHzjtxSpt62KGRxu7Lp+gAd
	 xAfMHHBGwvWC7084wKoIV9FLX647CwSKn5yDjVWdjdYw3gHX7PoLOUOGZlTX31sL1G
	 GwIeB/jXyMypnOOp39yKHbWXBXuoa2AZzBBBTUcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/982] spi: core: Abort active target transfer on controller suspend
Date: Wed, 30 Sep 2026 17:16:07 +0200
Message-ID: <20260930152421.760445887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e1eabb959c515..2dbdf10e9803a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3374,6 +3374,9 @@ int spi_controller_suspend(struct spi_controller *ctlr)
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



