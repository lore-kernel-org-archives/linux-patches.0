Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276EC1D0492;
	Tue, 15 Oct 2024 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993284; cv=none; b=nz/XZyrPNY5uCxoKHE3TABYzw0YuKojNwB5ynx3eMpVd6gpIQ1+q2zgmXmEYQKsiNLy4is7c+Sa9Yk+g3HAGpLRsntFeKEY17lyi0YlJdcZPdJEK/Kxj07YIBBqigocg5MCedCQoEAADKZ/yTjv7tR6VLpVCYiSibhyPaX4BYVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993284; c=relaxed/simple;
	bh=mSiqFcot80xd3L4aT6nKSB2n8p7ZuRnJJF0DKlytGjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKM4dX1SpRRIFDvzekdJNPQEND4PQ3zMBd1PUcAVlijn/nZuV3SkLudZHCvLDhpUZgbROZKptuBaDtu+kmY7LK460I503eykpbHgeTOJrv36uZFaVUlV2vMhseGmAJ288mAmVjeta0JurcE1VZBWWy4TamFd1dayguT7m8DLwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJbQJ5S8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJbQJ5S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8663BC4CEC6;
	Tue, 15 Oct 2024 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993284;
	bh=mSiqFcot80xd3L4aT6nKSB2n8p7ZuRnJJF0DKlytGjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJbQJ5S8uwvYYsrHLYY/ZjMEDqKtTX46G0gGNYH+cShXRUQ4NhShhWnZQIODJBZ1c
	 l2ovgvoK+QvZymuo1BIdMBRQPYd8sPPUAem1RTAPA5O72oAxn1c8bYDzymq3LzrJRd
	 zQ+4z1jqbphElTttAu8tVwluwayG5jqHa1Ty1inE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.15 348/691] EDAC/igen6: Fix conversion of system address to physical memory address
Date: Tue, 15 Oct 2024 13:24:56 +0200
Message-ID: <20241015112454.152861867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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


