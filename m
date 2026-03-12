Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFD92BCF5D;
	Thu, 12 Mar 2026 20:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346732; cv=none; b=MHJEceaO9Nj3PKPklrF2HSxCU8PRo3b7ohPUphEas3/LhK1Wtk+HIFuvql9hdCVbapIEdFpE7thceVm38vYI+7TaLm9zI2WSkTBPs9kvX9ikB6O21ekKfrIKjl5v3PqPBnedwvF2xU/Fsyo9fbZutq0mvWLXe0CXKPsFBTATMh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346732; c=relaxed/simple;
	bh=xwz7Q3SUJ58la6JtaKgWrtX7rwiK8mv9HvRYMvqlCW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axIbx9DztU+rnmqdoSesh7KyZ5Z1kI4MVJsfYHLvOq/OZSoB8n1znRq9gOFfWKqCd6Nvv+aLHVNF+yyDAGEW0exCrJJLVWWpMB1rf2ivgDTs1PyQgXhdwqV6S6mVtkYWNpZOzs3TSh4Lig5Hm7+RyuRxapZu2H0NYnYx4UFAY8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuGdZJSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuGdZJSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CC8C4CEF7;
	Thu, 12 Mar 2026 20:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346732;
	bh=xwz7Q3SUJ58la6JtaKgWrtX7rwiK8mv9HvRYMvqlCW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuGdZJSBLSWIinkO5X2XwTCc2oDqpDI4KBaaKCkGYHVc1OHWnBh1hukxGkXs48MtT
	 fTVsIvqd7aFwRiaARsx2pavT/CzU24sxePsm0dtXBcg5fMW9KJ9gdrTZ20UtI5YEZq
	 CDwVMxzL56q1yxG8ibfQ6SEhmvPl7mX1ukrfDrag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/265] usb: cdns3: remove redundant if branch
Date: Thu, 12 Mar 2026 21:08:17 +0100
Message-ID: <20260312201022.212289321@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

[ Upstream commit dedab674428f8a99468a4864c067128ba9ea83a6 ]

cdns->role_sw->dev->driver_data gets set in routines showing below,
cdns_init
  sw_desc.driver_data = cdns;
  cdns->role_sw = usb_role_switch_register(dev, &sw_desc);
    dev_set_drvdata(&sw->dev, desc->driver_data);

In cdns_resume,
cdns->role = cdns_role_get(cdns->role_sw); //line redundant
  struct cdns *cdns = usb_role_switch_get_drvdata(sw);
    dev_get_drvdata(&sw->dev)
      return dev->driver_data
return cdns->role;

"line redundant" equals to,
	cdns->role = cdns->role;

So fix this if branch.

Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20241231013641.23908-1-xiehongyu1@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87e4b043b98a ("usb: cdns3: fix role switching during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 465e9267b49c1..98980a23e1c22 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -529,9 +529,7 @@ int cdns_resume(struct cdns *cdns)
 	int ret = 0;
 
 	if (cdns_power_is_lost(cdns)) {
-		if (cdns->role_sw) {
-			cdns->role = cdns_role_get(cdns->role_sw);
-		} else {
+		if (!cdns->role_sw) {
 			real_role = cdns_hw_role_state_machine(cdns);
 			if (real_role != cdns->role) {
 				ret = cdns_hw_role_switch(cdns);
-- 
2.51.0



