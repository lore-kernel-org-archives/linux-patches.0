Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBE32BCF5D;
	Thu, 12 Mar 2026 20:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346736; cv=none; b=KOrSwQ0XMbeOQAkJmEYa1QUBGuaD9omCoH5Ybi+/aUyFDS0h7QZ5FVVPRwn9k7GqhLrOUnwRUgYWU43CLP/wuHgFfkWj2aMHnLYNMIAmGFgDe7ncjTKkyvyQpt7hDtZgZ+Pk0Pyxf0jc7rCTM626PqjUcpJRDrZE6Ao2uU8fXQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346736; c=relaxed/simple;
	bh=2Lu0Aq4cIAbLk5MwVNjqrCh2P+nV4B386SAwfitzMak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayOwvogTjzZXx0pKxMJxT0M7ALWVRRxBxbsqv2GNFMx5ISemtJIWZoJ65xnW7+qpXjrkVPhvQDzwXu8YpC7urMQ0P4Y13jEUkjFdp5UnhHAPmEBTT58Sb+ae+ark3qnLxhf5ZRMWec+h57fj8XtTxRTc8EavrmaoJhk9PybAW34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcApBq+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcApBq+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFDFC19425;
	Thu, 12 Mar 2026 20:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346736;
	bh=2Lu0Aq4cIAbLk5MwVNjqrCh2P+nV4B386SAwfitzMak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcApBq+tsDJLnrl92qaOGYgAPQ/CxpXvc4GzI/LetfNcqMbr0qLhAzMc6OZRAAbu6
	 r5BuDd+KZdO5HGBRKM9dFy8c5uqX8YtQ1olX+YSMwBQTkKBfQU6cHySv6DcMsLav9b
	 CcdwIhS5Vh6wZdpEHwFR5lw6sknTODLBB2VjyoUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/265] usb: cdns3: call cdns_power_is_lost() only once in cdns_resume()
Date: Thu, 12 Mar 2026 21:08:18 +0100
Message-ID: <20260312201022.248303122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 17c6526b333cfd89a4c888a6f7c876c8c326e5ae ]

cdns_power_is_lost() does a register read.
Call it only once rather than twice.

Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://lore.kernel.org/r/20250205-s2r-cdns-v7-4-13658a271c3c@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87e4b043b98a ("usb: cdns3: fix role switching during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 98980a23e1c22..1243a5cea91b5 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -524,11 +524,12 @@ EXPORT_SYMBOL_GPL(cdns_suspend);
 
 int cdns_resume(struct cdns *cdns)
 {
+	bool power_lost = cdns_power_is_lost(cdns);
 	enum usb_role real_role;
 	bool role_changed = false;
 	int ret = 0;
 
-	if (cdns_power_is_lost(cdns)) {
+	if (power_lost) {
 		if (!cdns->role_sw) {
 			real_role = cdns_hw_role_state_machine(cdns);
 			if (real_role != cdns->role) {
@@ -551,7 +552,7 @@ int cdns_resume(struct cdns *cdns)
 	}
 
 	if (cdns->roles[cdns->role]->resume)
-		cdns->roles[cdns->role]->resume(cdns, cdns_power_is_lost(cdns));
+		cdns->roles[cdns->role]->resume(cdns, power_lost);
 
 	return 0;
 }
-- 
2.51.0



