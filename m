Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97813B42CE;
	Tue, 21 Jul 2026 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665854; cv=none; b=gU7y2EpqKz/TywkI17ZZXeNXmk+KetawTgHzYV0p4xYFgm2WFYbCTCHxCnj5bZSwBFrUIdkQVVwNLYogaqojRDm4ZjZemKQkhf4L+2IV+c+53FxKs5R2SaHZ9VuW1VX4hh1f9ef2D+snTiJ5WpAYDx1Tdi67lpWP8MNR/p6Ci0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665854; c=relaxed/simple;
	bh=MFsK2it74FwJ7pPcsRNqGGE3/EOLOtqEVBVKIDAipOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4viD1vaQG+aRLaz/HjZklGOwVkFwEyBN+y5Az8uU+3tGi5BNileLSJj+57PgJyCMDW88k+faTbqDvh0hzvVgF1RWu3t3UTnkjxtUNY3wOMVpb3+7kB31tkVxYPh3f+INTkIWQy1hFbSYl3yKGs/uDWMYT/IkHmooP/MNOHxbfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riBtDPt/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riBtDPt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1161F000E9;
	Tue, 21 Jul 2026 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665853;
	bh=jBW0omYFD1NIWetBLIIE7jqfNC1wCIeW2hFlhFq3imw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riBtDPt/XI9ehWLwOJpjCNNHXNVWSnULYjZqk2jZs0BXyGun8QG8aVqyn2k3rtdjJ
	 Uk5y/HGq8Ozqp7ybJ53CVEY5+XqniTFllKjZGGJScjoZIeNyYJYb2gYtWVy6MOtaG+
	 6sauMqpJk6dlZ2SbwpTrJMiY3DZXSux5uYsWm4Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0418/1266] firmware: arm_scmi: Fix OOB in scmi_power_name_get()
Date: Tue, 21 Jul 2026 17:14:15 +0200
Message-ID: <20260721152451.192640044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



