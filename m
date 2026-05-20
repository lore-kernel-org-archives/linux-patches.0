Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B236EAB8;
	Wed, 20 May 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296106; cv=none; b=rvguVK8zkTckVndwSQIGQrQ4px/YN8v96Z8xo2OME+4GWs6LFJ47d+7C797hyraH+h7qTxgn9oreZlaB5J+aj1MEZNFzhx/fnLlgR8IcIBFlrD/ETNZILKTZaFn7JcULEeNR9aXASN/X1nE4hWJSEcSgaXhuJyXYCCS7mK+WCa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296106; c=relaxed/simple;
	bh=jL4oIweNSj/F6VV7MIDG5G2sZwLgKIWpfIF1fF+nKlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK6aKTqqB9vkdSxgPqxSzGjAm7nlNmB7fHvR8+qaV//VC+3FLUgSMqaQ1GhdcoT+JAOWGeeM/YjX51mDxdZU7Mt4d1f8CMlgrfI1RpUrmEhjqq1YQlxCWxbl9Xk4uTscRRzT9trNd61iom/3BXCADwEf1xEUxpBxi3BzmmJwKTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We8i3YyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We8i3YyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B581F000E9;
	Wed, 20 May 2026 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296105;
	bh=rDXRPwXqAz0RWarINjtlHHw2QZ0TwISwEOhbceqTxP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We8i3YyZHwds3TSn1YzAx/dZUuWECmJ/IPtkvaBuUtpnpxPoN5pZRY9tbx9Wu3nZA
	 PO2y8Ggf6zgmc3qJRhcTMqAgkXJSvkcpnaVpJb8giElytTLjbs2c4WHdYDEnIuqFzF
	 2xL7HZ13sd9tE3M6h4wkqKzgu523OQPoeEfEn6sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0673/1146] mfd: mc13xxx-core: Fix memory leak in mc13xxx_add_subdevice_pdata()
Date: Wed, 20 May 2026 18:15:23 +0200
Message-ID: <20260520162203.417493486@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit a5a65a7fb2f7796bbe492cd6be59c92cb64377d1 ]

The memory allocated for cell.name using kmemdup() is not freed when
mfd_add_devices() fails. Fix that by using devm_kmemdup().

Fixes: 8e00593557c3 ("mfd: Add mc13892 support to mc13xxx")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260120102622.66921-1-nihaal@cse.iitm.ac.in
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mc13xxx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 920797b806ced..786eab3b2d03c 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -377,7 +377,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	if (snprintf(buf, sizeof(buf), format, name) > sizeof(buf))
 		return -E2BIG;
 
-	cell.name = kmemdup(buf, strlen(buf) + 1, GFP_KERNEL);
+	cell.name = devm_kmemdup(mc13xxx->dev, buf, strlen(buf) + 1, GFP_KERNEL);
 	if (!cell.name)
 		return -ENOMEM;
 
-- 
2.53.0



