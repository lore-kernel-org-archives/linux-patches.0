Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F76248F71;
	Mon, 12 May 2025 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071031; cv=none; b=fgi6wRMjhokgHqQduhesnWtbXPgKjac027t5QazzpImLj1ysQQeK9wIHHAFUipfMxlBlpF/9eSdt3OiapSjsVm/dMnQr9m28FdUixiHPrRyHJbt/IycxQRfUzHAt68Vj+IbrFq8th6YmhHw56UFqdJ15b8asGyXZBIKWBneuEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071031; c=relaxed/simple;
	bh=Ok09LN2FXtBZZ2zqSqp84ZrVjuHjozIJU+PrG4ij+QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3ElfNlDPnFPC2sUBl7ztm7qooD1Dw6Xodr2VFp1Al4ZeL0r7vruUQvn2IAQKRWP0NtbrUFX+4/tzDrNz4WlLXIBWDXpwQSDUoMprNEu1uWEdbbnFZsLGiUMsdNjVmPEW5q5V/J9DfCrR2PN3Xo52LmmUUmn1bKou98xhhqQsVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GexRLCfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GexRLCfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAC7C4CEE7;
	Mon, 12 May 2025 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071031;
	bh=Ok09LN2FXtBZZ2zqSqp84ZrVjuHjozIJU+PrG4ij+QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GexRLCfPpJnOaKuYAmYi/ZF6j9esW+FMH99dstZ2SQqBUtL58Gd/W/XxwWpdsWfhN
	 GcW5SNYvOZZhRuLof0JBk1IWOTcDIe5IxPX/zIPJeWgbveorT/OEfNPIn64b0bvSBN
	 ZjVwz4hbAUFmmjtrd1TUSnv6k4JpVSRXtV40jqF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/54] net: dsa: b53: fix learning on VLAN unaware bridges
Date: Mon, 12 May 2025 19:29:26 +0200
Message-ID: <20250512172016.224218345@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 9f34ad89bcf0e6df6f8b01f1bdab211493fc66d1 ]

When VLAN filtering is off, we configure the switch to forward, but not
learn on VLAN table misses. This effectively disables learning while not
filtering.

Fix this by switching to forward and learn. Setting the learning disable
register will still control whether learning actually happens.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-11-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 429ea5056235f..3bd0d1632b657 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -383,7 +383,7 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
 			vc5 |= VC5_DROP_VTABLE_MISS;
 		} else {
-			vc4 |= VC4_ING_VID_VIO_FWD << VC4_ING_VID_CHECK_S;
+			vc4 |= VC4_NO_ING_VID_CHK << VC4_ING_VID_CHECK_S;
 			vc5 &= ~VC5_DROP_VTABLE_MISS;
 		}
 
-- 
2.39.5



