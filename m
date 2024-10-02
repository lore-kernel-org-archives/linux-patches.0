Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4681D07B5;
	Wed,  2 Oct 2024 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880489; cv=none; b=jGf2BfqqN+QZXN/RksuyhE5SdmO8PmnlvMZbuVAOFuLe+OhxmUJvR5ZYiyAn+jVrykzX8ijpur+664ZCaW9v+28cwv7/1pg5O7aX3X0pQxSZLeIT+W6IhYYzfnKK3lEjRDkPZA7e7SLbyQHhB+H2VV/Ekoda4W99xEcvODA68H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880489; c=relaxed/simple;
	bh=IeNhZHrfDqCHML5tBfkyZmMu2cX+hoIbuHa8Vhm1IKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ9Li+hY1dY9Fqw742LRG8b1u69jiG90GkVT19GOiLihpFpFdfevJjDNl4YT5ElHo59Z8qdGOhz2/5y/Y1ozpmL/LvAScfh55ze+GosbAJc4AHYB7iKWCG7NC/eHmf6WgxdIc3/kZ8gmHxFBJCCTqa+broQXxSJrDblaV6Pt3ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdQ1TiL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdQ1TiL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D6C4CEC2;
	Wed,  2 Oct 2024 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880489;
	bh=IeNhZHrfDqCHML5tBfkyZmMu2cX+hoIbuHa8Vhm1IKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdQ1TiL8gPJCFwLv+xQK69+QYmmbZVT1sJmX83v7M1Q1f6qHaEzvBOyggDn2JUMEx
	 2Zir5cfBPQu2eJojfO5XTA/8fB4sM1rrcdqhATtOdGt0xFrQxlVRcEb4oa2ro0u0eu
	 DTl634lqqqwRa4/buzrNc8W/PCOFYhD0Ykr/17VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.6 477/538] EDAC/igen6: Fix conversion of system address to physical memory address
Date: Wed,  2 Oct 2024 15:01:56 +0200
Message-ID: <20241002125811.274431325@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 0ad875f442e95d69a1145a38aabac2fd29984fe3 upstream.

The conversion of system address to physical memory address (as viewed by
the memory controller) by igen6_edac is incorrect when the system address
is above the TOM (Total amount Of populated physical Memory) for Elkhart
Lake and Ice Lake (Neural Network Processor). Fix this conversion.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/stable/20240814061011.43545-1-qiuxu.zhuo%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/igen6_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -245,7 +245,7 @@ static u64 ehl_err_addr_to_imc_addr(u64
 	if (igen6_tom <= _4GB)
 		return eaddr + igen6_tolud - _4GB;
 
-	if (eaddr < _4GB)
+	if (eaddr >= igen6_tom)
 		return eaddr + igen6_tolud - igen6_tom;
 
 	return eaddr;


