Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D70B3B27F9;
	Mon, 23 Mar 2026 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279729; cv=none; b=qEocTrz/E+1sMFpgA8yNymgLLAE8RQvQLuVVU4JFzs3kEjpRCmkblg5nFk2EoiFrT70DBU8FQ4+YVcGnn9tui+iH80jWh0tdWrn4Wexo9d5+QrBBOb+o2LvQXnfBy1Gd1uBD+7URWHuYoqOWwU55SUp6nThMLLQE04BBuaWh7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279729; c=relaxed/simple;
	bh=r0FfGvvLqUVA8mbPQHptREc5QJxOlrOWSIq/dQth7s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1FGV0p+1hTFIf2kERsNU+/KaEEvGGT69ELFTVugQgDcbHsC0py5mm+aIJZpMnNNuQ/Ug2dR/migJmyIKTdlJXudYcFUEd8ptnWlEn4UC2Gz2yI3Lu0PasWLVEz70AP2YElPpq//FvI7O2zYTwnQHPcCFDWB/BF70yixI7I9i1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZftwizD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZftwizD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBF5C4CEF7;
	Mon, 23 Mar 2026 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279729;
	bh=r0FfGvvLqUVA8mbPQHptREc5QJxOlrOWSIq/dQth7s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZftwizDITCv7L/OmHNaG2hSL8D/0LglE8kHU4C7UNoJKnPQYl2B4RJ0hTpkTSbP5
	 VtLrZ+PuGEWB7xmPD8rNTTp2ARVmr9dnpmNU28XaiKfZSyGibTSR1ciPRYCuohoDr+
	 5J+IaJQ1yo7zsttjCqWernIIhkbZ429qhrNMbQf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/481] usb: cdns3: remove redundant if branch
Date: Mon, 23 Mar 2026 14:40:42 +0100
Message-ID: <20260323134526.687038263@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7242591b346bc..d272d7b82bec1 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -528,9 +528,7 @@ int cdns_resume(struct cdns *cdns)
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



