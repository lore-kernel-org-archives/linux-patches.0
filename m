Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E8C352003;
	Sat, 12 Sep 2026 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207318; cv=none; b=jenIwcf6YHsRWSNoOWUKZgdIgSC3HgvAmLnxlf9Uoxnl7SWDvxDFnGL7eib2NSLo3fMV9wR9Dz9V7yOXCEt4DfIl8jlBiR/Kx0WF+FkqbMCfrCglm7knoVvm6qrIGA41WCx0KyDYTUgC2og1i5B9Gx7vLZIURkURsxZsu39S0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207318; c=relaxed/simple;
	bh=sUi//gS43bgXplsAPhEBmERumB6Evddd/hWetl+Vlx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmptDso9BP9jDbX7v9LuIr5DnaKHzsYRczH5/g3F9BuIxmh1qulUMUXRNj7TNVveCzU8FbbiXS3YwZnrkRTDfDp/DssSsNpJCJbvDN2ixP33hghjF/umttX5TEBjhbRqb4aU/h12H6JQm6ooCbyj+ujgCNp24JFiGi0HMFXR0Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgUYcR/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgUYcR/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66931F000FF;
	Sat, 12 Sep 2026 10:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207317;
	bh=E7kGAkksYvIfIN0TAF6hBr/o6iu+Lofg537K4E+0WgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgUYcR/xEeA3fwAwtMIxu04zqVA38kZS9e9KAx/o0+965S4Rm+6OmHjZ5dEQtdaTD
	 l8ae3yeIUkqTGC9d/oI6iBhkXXqCfSeFdgTWAU4xLYd5PPIW7RYseH9yXb4wI4e24I
	 xvfaL51ZX5iTbNr2YUnalbj18T4iUa86jNrKRDxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0388/1518] firmware: arm_scmi: Unwind P2A receiver mailbox setup failure
Date: Sat, 12 Sep 2026 08:42:37 +0200
Message-ID: <20260912065632.237516631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit f3e3773c4e5e96549d7540d8ddeb4fcd534f6f1d ]

mailbox_chan_setup() can request an additional P2A receiver channel after
successfully acquiring the primary P2A channel. If that later request
fails, the function returns immediately and leaves the primary channel
allocated.

Unwind the primary mailbox channel before returning the error so probe
deferral or other setup failures do not leave the channel busy for later
probe attempts.

Fixes: fa8b28ba22d9 ("firmware: arm_scmi: Add support for platform to agent channel completion")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-14-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/transports/mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/transports/mailbox.c b/drivers/firmware/arm_scmi/transports/mailbox.c
index 37e3eab529eaf..308736c3ead9c 100644
--- a/drivers/firmware/arm_scmi/transports/mailbox.c
+++ b/drivers/firmware/arm_scmi/transports/mailbox.c
@@ -241,9 +241,10 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		smbox->chan_platform_receiver = mbox_request_channel(cl, p2a_rx_chan);
 		if (IS_ERR(smbox->chan_platform_receiver)) {
 			ret = PTR_ERR(smbox->chan_platform_receiver);
+			smbox->chan_platform_receiver = NULL;
 			if (ret != -EPROBE_DEFER)
 				dev_err(cdev, "failed to request SCMI P2A Receiver mailbox\n");
-			return ret;
+			goto err_free_chan;
 		}
 	}
 
-- 
2.53.0



