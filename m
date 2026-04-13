Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385442EBB8C;
	Mon, 13 Apr 2026 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097162; cv=none; b=PCnUs+9vrGyGsgPfyg6uLSHTO4UZOXLtL3y+gr9xpM1SBm6CP7Fe4IBksh2esbXJqGaf83wFaJBD3UHB4H/CvVuXwmj3BlAdEY3NVQTb9f3iyiF+86UIjE0yMQdFsjmfb/momFKD5SyLZQ1ZpetqG9sOU/y+5TfoKOM9KTHpJL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097162; c=relaxed/simple;
	bh=wg5l14RG8KR4N5VhdByd6EgUcIPw8T8+I2AyIzCg5Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMyjO+QpiEzQlD6CcxsyY6bSnG+dFMS8X5Q5ZiwjMY3AGu/R4yDxfjXdWTkwUYZ5i9LuCU8C+zaSjI3ISz728QCeDJdUVcPKw0sI8k/AfiILHkmZiY/6+rmGl1Xs+APGDmNvk782X3NH7fJoP3dbUstwb3WzbMYkU7j398GwZ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLDo6zfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLDo6zfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B15C2BCAF;
	Mon, 13 Apr 2026 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097161;
	bh=wg5l14RG8KR4N5VhdByd6EgUcIPw8T8+I2AyIzCg5Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLDo6zfmaE++qRpQRYo2Rx+22gYkmLDQWV9+C5IDeIkjstA/vRvba/gyOdgc9o7Kj
	 lVvU9KYeIWe5wn1KhvSOJL7Yc5Pm120gylFY1jnZAKktl79tlcAck/SxJrmw2XNxmI
	 6GKzU15m9bXhtB0zCLs6jhN0oc9ny6BYV44YraeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/570] usb: cdns3: call cdns_power_is_lost() only once in cdns_resume()
Date: Mon, 13 Apr 2026 17:52:41 +0200
Message-ID: <20260413155831.552182016@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



