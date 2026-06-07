Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB404CB5B;
	Sun,  7 Jun 2026 10:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827638; cv=none; b=WUAks+zcY/9J4tZDmFmR3DKWC49pGAShUIs6vyqC4NjQWImHfDRnrXSemeOxC3oRekKRcWDii5Vo9F+kDOdv0cXhP6pJeHLrwUpuzmvzM07hgYL8so8UQBdR58cQ6F6A5D9DG1UqRMNK8aijq7onXKGe23xX1Riw7XIQYmciR04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827638; c=relaxed/simple;
	bh=cCB3wsH6xOqOY29AxtpOp0GALaqDRHvm718ptjUL6WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYdS7rULeKVw11N7R+GDKgwDKje5SpvnoUvGVosoI7xUHRbqALpIXbFSUo5yzdQm7hqKinRnVNqgRkB8bhNAFzCSlF6E8tHceBrbHBMmGt5UyzkVspUyyXz+L41ZlDNgiBsjomaU6Recf+pKdSba6yVV/K5ielQ7xkvyRnf9BXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCsEtdf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCsEtdf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9171F00893;
	Sun,  7 Jun 2026 10:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827636;
	bh=NOGUe5weAe4FEDcH9sfC4pmm/0wnv7ao8zDFnt7Xjss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCsEtdf6B5/I9BLl+3SmeSu2xZ5MxaocoIMTessdGw9OqvbPoax52vtyt6ESDvdg5
	 SajadKTZurolEeERFfO8N5F71dURx9PMOj2Zz3jgk8yCa23PYgNGba1fKUWsdIEZHY
	 /NQnzosxxuIYhv9X6XbmsLgFoib/8rvGnbQey284=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/315] net: mana: Skip redundant detach on already-detached port
Date: Sun,  7 Jun 2026 11:57:56 +0200
Message-ID: <20260607095730.894620374@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 5b05aa36ee24297d7296ca58dfd8c448d0e4cda3 ]

When mana_per_port_queue_reset_work_handler() runs after a previous
detach succeeded but attach failed, the port is left in a detached
state with apc->tx_qp and apc->rxqs already freed. Calling
mana_detach() again unconditionally leads to NULL pointer dereferences
during queue teardown.

Add an early exit in mana_detach() when the port is already in
detached state (!netif_device_present) for non-close callers, making
it safe to call idempotently. This allows the queue reset handler and
other recovery paths to simply retry mana_attach() without redundant
teardown.

Fixes: 3b194343c250 ("net: mana: Implement ndo_tx_timeout and serialize queue resets per port.")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20260525081129.1230035-3-dipayanroy@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6ef2a3ee44c6b0..1f723c0ea12837 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3322,6 +3322,12 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
 	ASSERT_RTNL();
 
+	/* If already detached (indicates detach succeeded but attach failed
+	 * previously). Now skip mana detach and just retry mana_attach.
+	 */
+	if (!from_close && !netif_device_present(ndev))
+		return 0;
+
 	apc->port_st_save = apc->port_is_up;
 	apc->port_is_up = false;
 
-- 
2.53.0



