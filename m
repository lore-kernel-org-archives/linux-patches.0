Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283D82D9ECB;
	Mon, 23 Mar 2026 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277713; cv=none; b=mW8ayy/jYvaq+Cex3fj0SRC5/Gpxfju4SsNK4Sf0SyxLrGGW7/aWagweMmATiZx2TqbHtlJmFq0VkZDZNYmzCcvplNq3j8YqRiMsEHjVFoKBM3xKi3yXi3kku+MrDqwWoQm8fMQhRgxZ0sRwmMcU5i83jvXBER2A+2wzsSuvfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277713; c=relaxed/simple;
	bh=C4jBifK6lSvuKwmUA+RuAZkyCFPQcV2sjc1vJfBz4ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlHLlbx+FyG0KZelVVlPSB48PQwb7F2Nfu3J/INS18XjvSSXfm7ikDyAdYV1EcIbEpwBUARJoPP/sSeHPrFMIBAFoXNGBrL1ZSLk0vjcR6QE7Iha7am+UJJPuiniFp9TufhtkBJGXiIvvSN16AHV0M2ZSelh8ZevEH1rLMKzG/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MWu2xUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MWu2xUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AFEC4CEF7;
	Mon, 23 Mar 2026 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277713;
	bh=C4jBifK6lSvuKwmUA+RuAZkyCFPQcV2sjc1vJfBz4ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MWu2xUkoW5h/NEWiX1QsI/J+s6AWe+4v72OA5VTFohsZU5sp5qpoeReqTnBRiuKe
	 M1WKeDJoNxR0pccuJJuOqn/2DvDf6cZUBKkQOdBgHbPVtATy1K5NzpFQzZI2b+GkQs
	 Uvo/aLZmmaT8xM5nMPdT9JQulAQuuc/GTrp/Qics=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/567] usb: cdns3: call cdns_power_is_lost() only once in cdns_resume()
Date: Mon, 23 Mar 2026 14:39:58 +0100
Message-ID: <20260323134535.756118829@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



