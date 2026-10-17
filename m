Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E5D2D73A6;
	Sat, 17 Oct 2026 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257018; cv=none; b=u3qN1xJB70ktDPKSiq5819KdmIGKtTevh7vmLbA/q/k1DE4X4Xbr1N+B9EyXQTykyqJkiaDcmWmrugaej5GdS2YEurvavLyo3K2wudhMxsPiAc0L4e7W0g4xCVcAdmTS6n4hNH9TuBn3ZqX1BsT2cG/zqtgbfs0S83kCEYOkJQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257018; c=relaxed/simple;
	bh=LvvqIUNPjNcLAnYWFRawSKqAklopDzFRmq+cK1kyiIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYSNqqMkRhUWySp/lWo8LdxLSPcZv9TgoRG/MY0lGqpjZNIt0sakmsq76MS8lLQZmzczGRHIu2XlGeHSYiuZFKbB40MLou7O/lgIYvbBbvDSfazHkwy+PER/Vu+2TvF+8dZ4ibQnr7xQlNoAqgGZFI80TAuW10vJAkGBvhLnF0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIXE7lpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIXE7lpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDA81F000C4;
	Sat, 17 Oct 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257016;
	bh=m/ymPVlF9VeAQxQEE4hiC5NQRBskOe9T1xRiAmlre4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIXE7lpvEkBd95vg3isOWnyabryZ9WzyJr9oeNFf35xdzGYuCj0dpyjQDyv/3PRBl
	 +f0vHWjm0UrJIvAmyIs5uGHyCYsNZD+If8Ik8yss5Tgjrd9zcSS7Vy5ffqhMz+vttM
	 Sa9IhuNS3wgRLTvP2kCHMDiGylJhDGSRy4kbtZZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0424/1674] firmware: arm_scmi: Unwind TX receiver mailbox setup failure
Date: Sat, 17 Oct 2026 17:44:56 +0200
Message-ID: <20261017160442.012794268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 6f7c06744d53dc8e047725d411d7f915d9ec35ae ]

mailbox_chan_setup() can request an additional unidirectional TX
receiver channel after successfully acquiring the primary channel. If
that second request fails, the function returns immediately and leaves
the primary channel allocated.

Unwind the primary mailbox channel before returning the error so probe
deferral or other setup failures do not leave the channel busy for later
probe attempts.

[ Backport to 6.6.y: apply the same failure unwind to the pre-transport-
  split mailbox source. ]

Fixes: 9f68ff79ec2c ("firmware: arm_scmi: Add support for unidirectional mailbox channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-13-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/mailbox.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 80b67f46a4d12..a34a3c693e159 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -230,14 +230,17 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		smbox->chan_receiver = mbox_request_channel(cl, a2p_rx_chan);
 		if (IS_ERR(smbox->chan_receiver)) {
 			ret = PTR_ERR(smbox->chan_receiver);
+			smbox->chan_receiver = NULL;
 			if (ret != -EPROBE_DEFER)
 				dev_err(cdev, "failed to request SCMI Tx Receiver mailbox\n");
-			return ret;
+			goto err_free_chan;
 		}
 	}
 
 	return 0;
 
+err_free_chan:
+	mbox_free_channel(smbox->chan);
 err_clear_cinfo:
 	cinfo->transport_info = NULL;
 	smbox->cinfo = NULL;
-- 
2.53.0



