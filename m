Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C63415F14;
	Tue, 21 Jul 2026 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661700; cv=none; b=V4plE+wiOQbtgKTFpgy4Gmt1C7YFJeDHB7YUd7dx6l498uXI2zsIQPxM4KLGHoiXWUsWxr+okwuq2nkgv4ULYpnjzCBi1ztNFuvHs9hAObo7gWgv3VIk/HcGRnOMD5bBpjDniPMP44312XGg3dnonPKR6s/OcylkH2zKCNlLDNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661700; c=relaxed/simple;
	bh=c5JePxi6pSJKsKpHk5pchxq8RWf0pBBv0docO19IiQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtcN1c+fftdOezxQDHv09v6UcIEYIxLS+o1ucKM7daNNXnoBGuKhKOJzPulEDytvv7mwLClje/Xl8AH4LAIy57PDXmWZ5MFC1tSPutQl0Oup3DtKTC+VgAd8QYg4kWJ0tWIF1Sg17MEteqAWWxBzvoU6LTFaQnHzlJA+qnWipFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uov8Y00K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uov8Y00K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4911F000E9;
	Tue, 21 Jul 2026 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661699;
	bh=DbVS65pOq+Tr3fpNskqT4eg42LVxqxZPf8ftUMKgqkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uov8Y00KNDPI7cvoxJZ2ECt8KNIjigyhihifstHSant9T9HgA35y6MBuqYyRlx1Jn
	 I/rniw8+avNWpF+siJmc20vkyPLtBTBXQZII5lUa5gUiOpcVwJwZjd9gjtPbtQX5Bc
	 32Sh9tqT8kdFUDFhqNTQU591TDj9mNqN3UM9bKFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0138/1276] firmware: arm_scmi: Fix OOB in scmi_power_name_get()
Date: Tue, 21 Jul 2026 17:09:41 +0200
Message-ID: <20260721152449.190255969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f9ef3f66f4b18078e464b7606f9497e4dbeb9905 ]

scmi_power_name_get() does not validate the domain number passed by the
external caller, which may lead to an out-of-bounds access.

Fix this by returning "unknown" for invalid domains, like
scmi_reset_name_get() does.

Fixes: 76a6550990e296a7 ("firmware: arm_scmi: add initial support for power protocol")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://patch.msgid.link/75caae28bdffb55199a0bc6cac5df112a966c608.1778838987.git.geert+renesas@glider.be
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/power.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/power.c b/drivers/firmware/arm_scmi/power.c
index 59aa16444c6432..7d3e5f3fc379b2 100644
--- a/drivers/firmware/arm_scmi/power.c
+++ b/drivers/firmware/arm_scmi/power.c
@@ -205,8 +205,12 @@ scmi_power_name_get(const struct scmi_protocol_handle *ph,
 		    u32 domain)
 {
 	struct scmi_power_info *pi = ph->get_priv(ph);
-	struct power_dom_info *dom = pi->dom_info + domain;
+	struct power_dom_info *dom;
+
+	if (domain >= pi->num_domains)
+		return "unknown";
 
+	dom = pi->dom_info + domain;
 	return dom->name;
 }
 
-- 
2.53.0



