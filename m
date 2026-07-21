Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F5A40B112;
	Tue, 21 Jul 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655901; cv=none; b=T1HsQBRpr/EdHR2JqP0rnWL3uWLJTEDJ16sjj2e10Xn+A7J01wfQFeXjSO+0GCpLuDvo+EtgVVDcqmmrCFqj56vaGX4C6k478+ze4ynxOvrfaZNN7Wy1sRMJ36tVGbtQoUehgKpFiPSQn8El9p7UdaOK0O6x9rXztahfNw0cIiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655901; c=relaxed/simple;
	bh=ecgzom7yVhnfoD5R6fx8cge/TVN42eNo6/rdKBj9Uf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0dnnae1V9GM9wWc5TwFc0abNnBJ+kRDCssiof4632J9tTwOlnO/jDTkcaownzPMdjxTm4pPHY2ng95WAy2E5aM3W0R4Y0Cho362LBuvYuBntVdYc0Oh6d0xQnDWtU2RqdmrTWPyOmTylvF6NleazkEiC2Y406y3OxX2CORWW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSj1ddDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSj1ddDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF241F000E9;
	Tue, 21 Jul 2026 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655900;
	bh=fZQTw/9EYpDjcOnioMG+b05avmnlPYIZaMVr1a1EuTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSj1ddDTOUBXtHByCVQTtnkAsgS/P1cBqgqJNLkMmKAVqZU+xdZd9dJH9qklTuZNR
	 rSbO0cgigzt+yowmgHf8nxokTYCoAgcAAS4f6grCPR+gI4RUULnK1jnHzYt7hj2w4z
	 8Ygj87bG/3Md58xcwXwLXCUILowIbJwtnTY101cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0182/1611] firmware: arm_scmi: Fix OOB in scmi_power_name_get()
Date: Tue, 21 Jul 2026 17:04:58 +0200
Message-ID: <20260721152519.016922157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



