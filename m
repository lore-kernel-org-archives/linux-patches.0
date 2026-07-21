Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AAC385D67;
	Tue, 21 Jul 2026 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660818; cv=none; b=nZfIYQwh+bRR4bdqZQDCPbvvChL5gzJocOl9Ak7aurrauM0+3qj1ONQZacd2YN+Wbtcj77XuFeSEZyZz0ts3DtfDNLB8XRVwVe8hQXnazPUG0OAbGgjfIyp3fklz2KKoI2fzkoxBxY+DRP+TW7AAoMtm8bHv701246fG2RHHqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660818; c=relaxed/simple;
	bh=scXiamANRYPdc82mUanxT2yt73dzr5D5EIqhUP5jsGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7EgNhN9FjMIVh+EWLTlZfyqgoPzzrWzRmYBYqc3VfpTOsPWyaZFgUXXz3gFRH8jxMccSB5RmeQDuD7wND9qKSfC4zKyynYKuGahnN7bxek3t2QnpRy/36cWkJ0j32qv0IBpFvi28P+UQ4NeuWRgDYSn58v3LeXfT2VUhrprPn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MifXfKJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MifXfKJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583851F000E9;
	Tue, 21 Jul 2026 19:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660816;
	bh=JVRCLybeAMkbmk3P49pgrKbtt+kgenis09WhC5nuh+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MifXfKJelksXKZGXuiXsVnJUQpvvTNacZ6eaFnQfAt7IFBowUXGr4VlnS5+EcaT+3
	 I9vOR8W9EYxiVvY7CxqkEx/MtAjqUPEu/sueK9KfO8MVBtAWrWs+x08/AztnyFzhgP
	 7a6Ria39/81p7V0+G757lgpxBFiuptUMFGos5JVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1123/2077] net: airoha: fix foe_check_time allocation size
Date: Tue, 21 Jul 2026 17:13:16 +0200
Message-ID: <20260721152619.307990561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen Yan <win847@gmail.com>

[ Upstream commit 5c121ee635680c93d7074becf14cfbaac140f80d ]

foe_check_time is declared as u16 pointer but was allocated with
only ppe_num_entries bytes instead of ppe_num_entries * sizeof(u16).

When airoha_ppe_foe_verify_entry() is called with hash >= ppe_num_entries/2,
it writes beyond the allocated buffer, causing heap buffer overflow and
potential kernel crash.

Fixes: 6d5b601d52a2 ("net: airoha: ppe: Dynamically allocate foe_check_time array in airoha_ppe struct")
Signed-off-by: Wayen Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/178161119471.2163752.14373384830691569758@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index a124f15345a916..a1f9939c21f20a 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1578,7 +1578,8 @@ int airoha_ppe_init(struct airoha_eth *eth)
 			return -ENOMEM;
 	}
 
-	ppe->foe_check_time = devm_kzalloc(eth->dev, ppe_num_entries,
+	ppe->foe_check_time = devm_kzalloc(eth->dev,
+					   ppe_num_entries * sizeof(*ppe->foe_check_time),
 					   GFP_KERNEL);
 	if (!ppe->foe_check_time)
 		return -ENOMEM;
-- 
2.53.0



