Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7A844AB6A;
	Tue, 21 Jul 2026 21:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668822; cv=none; b=P0wwfXkQZgCW0gA8W3eDXtPs7VO3QwkbPLW+iKd/t5P4OVeCc3YR47HOPAjzzFWUiHvIpJkZ5rvipyKXfBrHrBbexI6Vn9MJgQkXfrU+/89iomNx/4cUUyAO17HlUl1MDCVNFao4B96Z1s/POIX2D1S7i2zicZ5ax4uM0WZH5pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668822; c=relaxed/simple;
	bh=4H1L6Ay3FQVpkBEUEr1DteY+YFwTDag9LROa04Wn7Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhqtldArQwVRoFx3IHBqyQPgm/QbykIXSYUI3uzv4OW0Lbzd6Fq7gw06MJY9hylbeio2Kfz07E6QiTWy7GibiedOSLIhuERh6Z5deRJsJUSv87eEt1DXY6mGn532SjMlgABV8GZZXL6xC473AbklCtzfuyWGKFHE8R/acsok37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBHBBTCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBHBBTCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21AF1F000E9;
	Tue, 21 Jul 2026 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668821;
	bh=RoTlmFt4IlEhH+hO4+ex6FaVAvsRu+5nkS/PNZHyRQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBHBBTCMcV7BGtZItZQZNBollKWb1XmuZHx+Q9dioIvSsJR198iDcCHmoL6+RaVfH
	 BbJKuboKEDvGFClAyQ46tF2DBmSrC1j4RkMuT1UGUdj5uQCsFMb9fHtxyIsZ+KcsiQ
	 xTmZoTbYx5DAbGbQyJFk4+1wTtpHWvvCy8Hfj89M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0320/1067] firmware: arm_scmi: Fix OOB in scmi_power_name_get()
Date: Tue, 21 Jul 2026 17:15:21 +0200
Message-ID: <20260721152431.752439099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 356e83631664d9..6e01f70c3a9eee 100644
--- a/drivers/firmware/arm_scmi/power.c
+++ b/drivers/firmware/arm_scmi/power.c
@@ -194,8 +194,12 @@ scmi_power_name_get(const struct scmi_protocol_handle *ph,
 		    u32 domain)
 {
 	struct scmi_power_info *pi = ph->get_priv(ph);
-	struct power_dom_info *dom = pi->dom_info + domain;
+	struct power_dom_info *dom;
 
+	if (domain >= pi->num_domains)
+		return "unknown";
+
+	dom = pi->dom_info + domain;
 	return dom->name;
 }
 
-- 
2.53.0



