Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19F646D55F;
	Tue, 21 Jul 2026 15:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648609; cv=none; b=a0BimTMSeKpi0vvMbhYtUC5QNhcSJ7JPPELkCTM+RpdpfjfjzXmpnGmrw153ssmL7gIU/GXT0yvqjgghye5jNghb2utAu5WvIfEpbmc97zfz1pfI3usrFVcN06a6ZlH+AemKV6Fdwxh7LRuBmWWAso3Rf0ZdApMGcg2sNBtGeCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648609; c=relaxed/simple;
	bh=c9guzoIges84FCjfsdpuijmeJNvgmG3HCjfIPvpDsso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iro2sYM1LMqBkKMlOfSGBswFi4XdTCJClcS5yBOWAirm52moChzAh0/pll+5R6MsT2RlZhiKExM9d+hDvtN6vlRrk7K0M5+JJCSGN7x7aHZwK+2nBk47AHiR2XYJDa2m4i+yqpQF1EPRHPpyZDWJ6kNSH+zQJEik2TnGd/WHwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqGDJ1CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqGDJ1CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310F61F00A3A;
	Tue, 21 Jul 2026 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648608;
	bh=MDSh9wTx9Fapav81Htmyy/02c1uoPt9LPIujkKi+rkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqGDJ1CPvEKHu3cd6ZwOLtWIxbVF4JzK8d0OLZTHBA28ibRzKBSXtqaW8nhnpMH8m
	 xgPAwjy2jj3fhYlZhivFmfn/Hj39rtaVYbpsqbFzTmcU554j8CnZJJxMZmWQgqMdwA
	 LKKdc/l3FFHLf4PY4dxCikxXt30RUvhq480reZnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0262/2077] firmware: arm_scmi: Fix OOB in scmi_power_name_get()
Date: Tue, 21 Jul 2026 16:58:55 +0200
Message-ID: <20260721152558.858957654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index bb5062ab8280e0..28ef63a4ecc2e1 100644
--- a/drivers/firmware/arm_scmi/power.c
+++ b/drivers/firmware/arm_scmi/power.c
@@ -204,8 +204,12 @@ scmi_power_name_get(const struct scmi_protocol_handle *ph,
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



