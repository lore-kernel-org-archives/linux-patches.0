Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958951CA8F;
	Mon,  1 Apr 2024 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987616; cv=none; b=h4EfEAOn2yD3lxjk5UOLdc5Fi35whGaZrRfgj/RWzVbR3FINIzGLm94197W464dB0hHPJ7f2+2Opi9mSy8S/ggvZ5x+fAZDUIzYy6LapfnuGQ4MRLRw5cVpWnFWp/c0Ibuw2yKcTDCkLWlUTZq9asqJ/Rb+Az3FddDV1z7CUrN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987616; c=relaxed/simple;
	bh=EPe03qv3NFEoSBCeR769xWLm2Hoi5dX/NdnsfSgzQRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obFGh+04b/iHiRbZ3yB0V9zkwgC8HCqzj/qTW+F/i5FWgAQu/ljfxTTmAx03tQeHwFo50EiwEF4/8HhFRtThO7yPOzFnKMyvpQ8TY91HIdXTcAUe+3Ch93t8bqBcxGtK+UpxBIf39Xc0Luybr4Dd0Xz7wquxouBZwN62smwmMbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1fxRmYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1fxRmYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15E3C433C7;
	Mon,  1 Apr 2024 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987616;
	bh=EPe03qv3NFEoSBCeR769xWLm2Hoi5dX/NdnsfSgzQRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1fxRmYP9du9LnjqZdyqPNpxI68C5zXaBK7yHeB/PMg9U3m583GIGyZaf6f+sWxnR
	 wqWtvZBrNJUo5qLNa4atvEPY0+hFQx+zq2gbuVsKoi02pAFC4vbpJX6E1fNOv7i2TJ
	 RObkW0Bbf6pVWe/Fsbm0vD7jnhSWJ7fWNIdqYYho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezra Buehler <ezra.buehler@husqvarnagroup.com>,
	Martin Kurbanov <mmkurbanov@salutedevices.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6.8 341/399] mtd: spinand: Add support for 5-byte IDs
Date: Mon,  1 Apr 2024 17:45:07 +0200
Message-ID: <20240401152559.352734404@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezra Buehler <ezra.buehler@husqvarnagroup.com>

commit 34a956739d295de6010cdaafeed698ccbba87ea4 upstream.

E.g. ESMT chips will return an identification code with a length of 5
bytes. In order to prevent ambiguity, flash chips would actually need to
return IDs that are up to 17 or more bytes long due to JEDEC's
continuation scheme. I understand that if a manufacturer ID is located
in bank N of JEDEC's database (there are currently 16 banks), N - 1
continuation codes (7Fh) need to be added to the identification code
(comprising of manufacturer ID and device ID). However, most flash chip
manufacturers don't seem to implement this (correctly).

Signed-off-by: Ezra Buehler <ezra.buehler@husqvarnagroup.com>
Reviewed-by: Martin Kurbanov <mmkurbanov@salutedevices.com>
Tested-by: Martin Kurbanov <mmkurbanov@salutedevices.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240125200108.24374-2-ezra@easyb.ch
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mtd/spinand.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -169,7 +169,7 @@
 struct spinand_op;
 struct spinand_device;
 
-#define SPINAND_MAX_ID_LEN	4
+#define SPINAND_MAX_ID_LEN	5
 /*
  * For erase, write and read operation, we got the following timings :
  * tBERS (erase) 1ms to 4ms


