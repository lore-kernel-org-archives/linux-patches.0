Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5739733E;
	Tue, 21 Jul 2026 22:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674797; cv=none; b=R69YDwz7LaAkZ8dUpas9zpl8p6p+6ao6GBNCV8bX3uTodFShxqzpHOeAWyJVb1omFuxHpdRelzlIodi64dLO9+mALjzthlMfO8IR6jv7eAU6lD48xF2mBq6wnH8ftjsVGnh6y1GgXEdHAGDNS1NOHXFFSo9keMZab+3X8Cz3umI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674797; c=relaxed/simple;
	bh=qg4hRSXXEoRg3di5n56U83mMkNTefQoE/FNQXwacZUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv6s5BMt2qgrD6VXEjjQZsUzuF+QjrCANB5S6tWgf+kiQxA9kSrLWlK3NC0r95CMTPieW9gfp5mvF7ru+hmhNrNQJrU4jRuvXPjXo4/Fkb+LR469Aj1gw2CF+4nQidCs5vK7Q7rwTQX36sReQSO9bEq7GhFIs94a0yLgT3KzQ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYdIr76d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYdIr76d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3351F000E9;
	Tue, 21 Jul 2026 22:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674795;
	bh=Eh5QF5u6oSwTWsAelYeLNd308zopqZhusNppUz/tfUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYdIr76dSa4VDlJ3kT/5y7CVi0On0I8t76i1BN3Hu+WnHrCaxIj/JbMlOsli4qG6F
	 cyIEHwuilbfucg7h8Ge5AxNvd2QcYJpQyExOOyyWO7g3EKPIsdMQZU+9dsjF/Wwrcd
	 twsqnHhn5sxGmg8jVPT8U+DXMxQRdIFdXony2ERw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 674/699] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Tue, 21 Jul 2026 17:27:13 +0200
Message-ID: <20260721152410.970969455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 9cff680e47632b7723cb19f9c5e63669063c3417 ]

VDO() second parameter is VDM type (bit 15): 1 for SVDM, 0 for UVDM.
Using 'vdo ? 2 : 1' corrupts SVID low bit when vdo is non-NULL
(2 << 15 = BIT(16)). Enter Mode is always SVDM, hardcode to 1.

Fixes: 8face9aa57c8 ("usb: typec: Add parameter for the VDO to typec_altmode_enter()")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Yan <andyshrk@163.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260604105059.18750-1-andyshrk@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1671,7 +1671,7 @@ static int tcpm_altmode_enter(struct typ
 	struct tcpm_port *port = typec_altmode_get_drvdata(altmode);
 	u32 header;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0);


