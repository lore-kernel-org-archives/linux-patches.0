Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F743B7759;
	Mon, 23 Mar 2026 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279732; cv=none; b=BpJCKDMfKQgUJU1/5ImI+JI9C35q5rVXlZN31lpodLVXxN/dPzkIhH5pC/BGcElDiSZ5RVUjD7iVV7bCT9MBTPCR89cf3czKlO4jg8QNJBXGjx5ZH7LfL+In0TVHeTqIfj84i9uHLzm8WbVGpr17xs7SZmlDSDxR3tIMxUjL/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279732; c=relaxed/simple;
	bh=Jc7VzgeAID/z3EP0o1+87HiqL50ebwKhfs4FCtol9LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewuIEPoncVmdoZy9U7Hbew16nB3eViYJDL6xezQr2ipoQLfxSK5LPq5ZKVU18pWeJtRdrWfLv1P6Gt7MWLpNtEQ/hsUGYMsn7cQBLRSeqX7+F/tWuB+zSj4n9YDgg8H0n85SQCB0tZ4eTuWt2HegzHGZ6CEhrZeMNxlmM84Gzqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt6gx574; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt6gx574"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB94EC4CEF7;
	Mon, 23 Mar 2026 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279732;
	bh=Jc7VzgeAID/z3EP0o1+87HiqL50ebwKhfs4FCtol9LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt6gx574ldrkx19ZVE5mqUNhZL+J6nBusMOv5KZD3grTqtNNeFMxBKyIoXPStW5n6
	 +Qbx5Po/foxnRDomKucJ79jirmiHQaiFl1fs0Ovb3kwrky+X8txzSkfy7C+TszlM/U
	 9WRfTH4uJd95n/1DpdSP0sSezi42MGGTb5aVJbVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/481] usb: cdns3: call cdns_power_is_lost() only once in cdns_resume()
Date: Mon, 23 Mar 2026 14:40:43 +0100
Message-ID: <20260323134526.711128618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d272d7b82bec1..8e46fd36b0e56 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -523,11 +523,12 @@ EXPORT_SYMBOL_GPL(cdns_suspend);
 
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
@@ -550,7 +551,7 @@ int cdns_resume(struct cdns *cdns)
 	}
 
 	if (cdns->roles[cdns->role]->resume)
-		cdns->roles[cdns->role]->resume(cdns, cdns_power_is_lost(cdns));
+		cdns->roles[cdns->role]->resume(cdns, power_lost);
 
 	return 0;
 }
-- 
2.51.0



