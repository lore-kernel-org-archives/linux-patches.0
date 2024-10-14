Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703FF3A1B6;
	Mon, 14 Oct 2024 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918488; cv=none; b=baowBU4YnbbEAJZVSohVPd5DL4PW+JyfE2OGoORCQtffgxib5243iG9VwksNO2oh/AGnkYlEtygQViVrbMxL/0MFp+HYlIf2Mp//LsCJDn77t/HNaQ3ank/OWe68dY8id1CpClIEFXk2mTAuYc6dQEF9xBpW2w1Wvs+aWfrJgdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918488; c=relaxed/simple;
	bh=JNGf2cZBc8cwAISM59IL3dT1Jc8iV6bZ+aYTU5B6qnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3r3JxbQ7E3I4nhY0vy+Kb88NFagpnwWEytZ2pfMKv5oGSWXEFbcbVAzFdyTfe+KBCXyBPZ/xr5/uR4IMMBq3A7VePFT1tsB0qdkwnYXqvrR/JiS/HxJc55kBcoubeWVAw+MCFfY4ZMQycx9Lp17KpmYg6XF+MysxObfBWx/mxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZa/oeTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZa/oeTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8A9C4CEC3;
	Mon, 14 Oct 2024 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918488;
	bh=JNGf2cZBc8cwAISM59IL3dT1Jc8iV6bZ+aYTU5B6qnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZa/oeTUHyiW4fBZSyq+SbQwDH7wHLzGKgSbGvu8qmwRm+9UquF8zrUpB1e1++UoA
	 GZRPJx1HVdyIxxoKseAX4aoIR8qaBylkp9622WluueUhd+O+8ADN4CU5AmU6QOKCc+
	 ihVDVmzE8Jzi4wiyhiINXIqneNLjT/oeFIT1Wvos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.1 339/798] EDAC/igen6: Fix conversion of system address to physical memory address
Date: Mon, 14 Oct 2024 16:14:53 +0200
Message-ID: <20241014141231.266832830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


