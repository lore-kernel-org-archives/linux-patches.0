Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4322B20ED;
	Thu, 13 Jun 2024 12:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281863; cv=none; b=ICRdwpOvTbv1ouvLweR4mCs5bFQENVU+e6enVGH5sqDI3YO/gMLVNwlFHqKvBnnopSN7WQfpFGDumjwZRSxHFkNIy5TW0nGDR0d95RBKtwguFpNQcZALdqfickeJ47Fn+rUAmVIPyRpIM33m0wYKtgJQyRtCIn5WM1FKGI0l+FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281863; c=relaxed/simple;
	bh=Ai80KAnQSiky6KlBFDPx6eWtys3WQq/CnqOXrtTLqd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfdVdGBUKuV8yn7vZizGer6pPt4B7kf5XeeiBlbe+Xfd9jEj96fMqjtRvWoonMRXSjzdpqebqsra4fJ+P/dkzvr3texCfRSSQ/9Vk/4Q9Yka/oNzgDInNnLbWBEHLww2I+IshDiutQEFWX9AlHN5KoFjcweCGBPN9r1NH0SBW1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC7oDp9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC7oDp9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C16C2BBFC;
	Thu, 13 Jun 2024 12:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281862;
	bh=Ai80KAnQSiky6KlBFDPx6eWtys3WQq/CnqOXrtTLqd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC7oDp9NiSUInfZh6SkochVTAbezSdW6foOmJWrYnxBqCW8IlnOYaoTGUWUFnr/Nr
	 wvWCm4cpQVnrsYReYe+Yhp+ZbOuJBDnGj6SKE/MoLGyJOy1Tt85eqSiI+eCVCObOnp
	 N146s47RTiZgc9b7FjNiAsmfJS/MThKIJXngqBg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/402] scsi: libsas: Fix the failure of adding phy with zero-address to port
Date: Thu, 13 Jun 2024 13:30:37 +0200
Message-ID: <20240613113305.257136481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 06036a0a5db34642c5dbe22021a767141f010b7a ]

As of commit 7d1d86518118 ("[SCSI] libsas: fix false positive 'device
attached' conditions"), reset the phy->entacted_sas_addr address to a
zero-address when the link rate is less than 1.5G.

Currently we find that when a new device is attached, and the link rate is
less than 1.5G, but the device type is not NO_DEVICE, for example: the link
rate is SAS_PHY_RESET_IN_PROGRESS and the device type is stp. After setting
the phy->entacted_sas_addr address to the zero address, the port will
continue to be created for the phy with the zero-address, and other phys
with the zero-address will be tried to be added to the new port:

[562240.051197] sas: ex 500e004aaaaaaa1f phy19:U:0 attached: 0000000000000000 (no device)
// phy19 is deleted but still on the parent port's phy_list
[562240.062536] sas: ex 500e004aaaaaaa1f phy0 new device attached
[562240.062616] sas: ex 500e004aaaaaaa1f phy00:U:5 attached: 0000000000000000 (stp)
[562240.062680] port-7:7:0: trying to add phy phy-7:7:19 fails: it's already part of another port

Therefore, it should be the same as sas_get_phy_attached_dev(). Only when
device_type is SAS_PHY_UNUSED, sas_address is set to the 0 address.

Fixes: 7d1d86518118 ("[SCSI] libsas: fix false positive 'device attached' conditions")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20240312141103.31358-5-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 9ae35631135d8..ee6607dfcdfa5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -256,8 +256,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	/* help some expanders that fail to zero sas_address in the 'no
 	 * device' case
 	 */
-	if (phy->attached_dev_type == SAS_PHY_UNUSED ||
-	    phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+	if (phy->attached_dev_type == SAS_PHY_UNUSED)
 		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	else
 		memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
-- 
2.43.0



