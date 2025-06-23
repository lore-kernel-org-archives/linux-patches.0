Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C868D1AD3FA;
	Mon, 23 Jun 2025 21:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715853; cv=none; b=C5CuplbPdeQYpvuDtJl/ZsgAfWzZInoYOHE1ow82celgfKwMUtm0YkeLLZh9Ftog0dZw3mEEEGYVYWhZMIFsIEHTb+9/IpWxsVQXJQ9a2vURl5r6oQ7Bx9Efv9VEtrJOIDpTULrNAqt7A7nH/CnDEb/MzSw9ocNJKCQl10RS6Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715853; c=relaxed/simple;
	bh=6kfQUZZg3k+dORl+5O4iXq9+0nNpM3ND9HTXQkBSl3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZabbIAxsYf3xRrvOTA4XYfGODF3QELyC+Tedt5N9naly1iawy12myVJYx1mL1icZyTcNM73xQbWcDHsPol29XS8smT8B8x3/TprPoZ1gdQ5Cv9qy8UNx3cHE1vO3wBMOnYqme/jqhzlWeFHFFviNJH/a580VCmrshzyej78kono=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQICwlym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQICwlym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F681C4CEEA;
	Mon, 23 Jun 2025 21:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715853;
	bh=6kfQUZZg3k+dORl+5O4iXq9+0nNpM3ND9HTXQkBSl3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQICwlymA6MYMO4okxXsA+hEm0DTMROIFwR9XuYzcohMERFPkdGeuh+59VUJv2EuT
	 D87mQAitw1Jv4muUjh3JYJfXLV9roGim4Sqks88txfWc9Mu8mved9QQsujHTuguu5X
	 U9T2+o7JEk9+K27O9DgIFbRH8Mz019eo7Ep5Q/cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/411] emulex/benet: correct command version selection in be_cmd_get_stats()
Date: Mon, 23 Jun 2025 15:07:32 +0200
Message-ID: <20250623130641.396970875@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit edb888d29748cee674006a52e544925dacc7728e ]

Logic here always sets hdr->version to 2 if it is not a BE3 or Lancer chip,
even if it is BE2. Use 'else if' to prevent multiple assignments, setting
version 0 for BE2, version 1 for BE3 and Lancer, and version 2 for others.
Fixes potential incorrect version setting when BE2_chip and
BE3_chip/lancer_chip checks could both be true.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250519141731.691136-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 88f69c486ed09..1cdb7ca019f57 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1608,7 +1608,7 @@ int be_cmd_get_stats(struct be_adapter *adapter, struct be_dma_mem *nonemb_cmd)
 	/* version 1 of the cmd is not supported only by BE2 */
 	if (BE2_chip(adapter))
 		hdr->version = 0;
-	if (BE3_chip(adapter) || lancer_chip(adapter))
+	else if (BE3_chip(adapter) || lancer_chip(adapter))
 		hdr->version = 1;
 	else
 		hdr->version = 2;
-- 
2.39.5



