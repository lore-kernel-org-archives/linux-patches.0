Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0C18A93F;
	Sat, 12 Sep 2026 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223258; cv=none; b=NzPBy3QEqk0yJ8Eqf1v0Dmfs2hNcwuwMLts5g61+wIm385pjyCvSRZZXp7i5SVFUc42A9Kks1VLMq/vVMg4eRv6knG9cvx8WZ5NBHjtpvhBaE0mCtNe2OEFNHbeJTLC3Youw+Ktqu1WJGGt2k+CJi4n8t01JI74ERCSaXIBbcqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223258; c=relaxed/simple;
	bh=38PrVh9vR1WljWF5FAQqo392FgA0x5Uqinjs3sb2RcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2OozXvbWHduo28Hbm9v45Ozv2fmIz/ypVZqtXaKl6KPnFg90/xenojNiF2jHy2F3TUrvpC8US0ICuXrNFDFBnAC/geOq78D89e4lMZuFEfdfkgdv+7qYWEOKDwnVdW4V5VaOLZ+cHA7kMVE3La3cUlBVAWHjkICf1L2fzAk43I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aosZijQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aosZijQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFF61F00893;
	Sat, 12 Sep 2026 14:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223257;
	bh=IDa70AmdU1kMcUwTf7OMPco58AlpaMeKGCK7wKxCXHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aosZijQDQV9HWBhAC2sgrE3V7V9+crqNN8ALiYRqiaqXUUpO6aCdPcdGP7+bFHcJO
	 MJ+/fLy7REEVPUJn46wVCRYf8ejAg6yGEegpQBWoTK958zD6ng7ok09N4JL1ss1Ev/
	 jya/k1ppxP3+XFeTRJYGwKC63Yz5iJ/3apY1GIsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0752/1424] firmware: arm_scmi: Reject out of range DT protocol IDs
Date: Sat, 12 Sep 2026 08:53:04 +0200
Message-ID: <20260912065624.136871809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

[ Upstream commit 59407ccb52130f2c81f4b3cbe4f14114afceb54f ]

SCMI protocol IDs carried in message headers are limited by
MSG_PROTOCOL_ID_MASK. The DT parsing paths noticed protocol IDs
outside that range, but only logged an error and then kept processing
the invalid value.

That lets a malformed 32-bit DT reg value reach helpers which take a u8
protocol ID, where it can be truncated and/or treated as a different
protocol.

For channel setup, two different out-of-range values can also be used as
distinct IDR keys while aliasing the generated SCMI protocol identity.

Skip DT protocol nodes whose reg value does not fit the SCMI protocol ID
field before setting up channels or creating protocol devices.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-7-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 640d873979088..a1cf60c938526 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2525,9 +2525,11 @@ static int scmi_channels_setup(struct scmi_info *info)
 		if (of_property_read_u32(child, "reg", &prot_id))
 			continue;
 
-		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id))
+		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id)) {
 			dev_err(info->dev,
 				"Out of range protocol %d\n", prot_id);
+			continue;
+		}
 
 		ret = scmi_txrx_setup(info, child, prot_id);
 		if (ret) {
@@ -2876,8 +2878,10 @@ static int scmi_probe(struct platform_device *pdev)
 		if (of_property_read_u32(child, "reg", &prot_id))
 			continue;
 
-		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id))
+		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id)) {
 			dev_err(dev, "Out of range protocol %d\n", prot_id);
+			continue;
+		}
 
 		if (!scmi_is_protocol_implemented(handle, prot_id)) {
 			dev_err(dev, "SCMI protocol %d not implemented\n",
-- 
2.53.0



