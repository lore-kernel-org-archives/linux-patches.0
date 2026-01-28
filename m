Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292CB2D0C62;
	Wed, 28 Jan 2026 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614582; cv=none; b=eja6wBx21KOc2D9wQdrbfhsdZGo/OCf062O1YNowgdlVKPJbiaHfqLRFiVSIogTSu3Q4BzYk+gt6mtRX6JqvGQO6nRy6/wvyAnj8cbUjA+tHpYpv0RtnzPcrMGg0NND0JQzPicLc8xlTn602PdErQOwRLr1K+/KdJIdVpUxtmzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614582; c=relaxed/simple;
	bh=t7jV0OPIDOtbvMwb2WtJSuCcjPbj8UYOpc5uuT49gjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnIfcBGfYXwIcQ4VmABRQ91zNC5LVKDN0Rr9XD6YRswM+zUdssBIkvp/V8uTZQ5oPuMPjheGdsUIyQmq+CALqlVi4oSB5m7eoWohCvg5p9GqCY6vB0KPH2A+tHCFpea44WdLFAC+T2VogBYQwoKEoApDsYX9dvo7/GbvpkXAQvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npfur0n7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npfur0n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752BAC116C6;
	Wed, 28 Jan 2026 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614582;
	bh=t7jV0OPIDOtbvMwb2WtJSuCcjPbj8UYOpc5uuT49gjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npfur0n7PL+Gh1XzUQJIMdj4v/NLy9mEBYyxmwIo1qf4QqCiLMCtE1zupf8/W2V8j
	 CqbLRUYIXM8g4/JWnW36i1bZh0J8BEHNaRur/Zp6tiCGoL0BwG/aLJF1CWsfy+dKTo
	 FLYzN3ma9FBEBIK43WyymuClpZQUlh3o9vZUma5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/254] be2net: Fix NULL pointer dereference in be_cmd_get_mac_from_list
Date: Wed, 28 Jan 2026 16:22:29 +0100
Message-ID: <20260128145351.031725886@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 8215794403d264739cc676668087512950b2ff31 ]

When the parameter pmac_id_valid argument of be_cmd_get_mac_from_list() is
set to false, the driver may request the PMAC_ID from the firmware of the
network card, and this function will store that PMAC_ID at the provided
address pmac_id. This is the contract of this function.

However, there is a location within the driver where both
pmac_id_valid == false and pmac_id == NULL are being passed. This could
result in dereferencing a NULL pointer.

To resolve this issue, it is necessary to pass the address of a stub
variable to the function.

Fixes: 95046b927a54 ("be2net: refactor MAC-addr setup code")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://patch.msgid.link/20260120113734.20193-1-a.vatoropin@crpt.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 779f1324bb5f8..0cda78b78fb87 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -3797,6 +3797,7 @@ int be_cmd_get_perm_mac(struct be_adapter *adapter, u8 *mac)
 {
 	int status;
 	bool pmac_valid = false;
+	u32 pmac_id;
 
 	eth_zero_addr(mac);
 
@@ -3809,7 +3810,7 @@ int be_cmd_get_perm_mac(struct be_adapter *adapter, u8 *mac)
 						       adapter->if_handle, 0);
 	} else {
 		status = be_cmd_get_mac_from_list(adapter, mac, &pmac_valid,
-						  NULL, adapter->if_handle, 0);
+						  &pmac_id, adapter->if_handle, 0);
 	}
 
 	return status;
-- 
2.51.0



