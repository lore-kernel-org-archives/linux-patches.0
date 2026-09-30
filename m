Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3F051AEEE;
	Wed, 30 Sep 2026 18:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792583; cv=none; b=Kje8QnspT3kwjHvyO/3rma438bhvNeTWUKWc32uZM8zSUX+SeGw6bvIIseICArhgh2Ru4SERm9p13+f/z0MAB2zHmgSyevoWWeyKTiN0DTwShYTdBaO/2hxpNYSRb25Dwr5HwLBS9DuXtB0tzmOqVbpISAGppYL7l4ZKZh4PNuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792583; c=relaxed/simple;
	bh=dzpxIWbhsGC97Q7GLLMM3Qs1+SHSwrGBPeTkEqLBvfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKBLF/IQIFFmLygnv3b4nwUW2BIMm2gHCQdn62yYZ/BSsG/acVvOzJy+CzBHbQItiCPvRV31yFWr8gsIIBDlpePTtNALyh+p9JOlwpR203sh33YRFaVZLEhd8PujNjHOp0Ut4OwojhGqeKYuMcVF0R2DlLLG+35hNKCQxCQHgtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdqAJG7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdqAJG7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4071F00898;
	Wed, 30 Sep 2026 18:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792582;
	bh=h4jd0uFLzCrYICtGqjR2IDSNhTcp0AA+3WbyYD8tU1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdqAJG7oD8hSgLYM/W05OqyKX22jSGG7aIs5PKLNQwT5iLfHghTBuaMIBoG0nMBLp
	 IrLhVIVtEFYT2Zy0rhQD1NRG8Wy7FMjxiQjjoJDgOURqAd98w+/B7sdLcm1zC96HvF
	 01UmSGlFXYwXjlzsLrPj48OlalibIeZYDpGcebks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 660/752] nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()
Date: Wed, 30 Sep 2026 17:28:50 +0200
Message-ID: <20260930152412.541764872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit 408cff6bd60636df201274d320edfdfde9ed41db ]

nfc_llcp_wks_sap() compares only service_name_len bytes, so a short
service_name like "u" matches longer WKS strings like "urn:nfc:sn:snep".
Fix by requiring exact length match before strncmp().

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Link: https://patch.msgid.link/20260909121437.33744-1-omermetekaya0@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index aebd4b1ab81d3..f4e58fd5cc1fa 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -369,7 +369,8 @@ static int nfc_llcp_wks_sap(const char *service_name, size_t service_name_len)
 		if (wks[sap] == NULL)
 			continue;
 
-		if (strncmp(wks[sap], service_name, service_name_len) == 0)
+		if (strlen(wks[sap]) == service_name_len &&
+		    !strncmp(wks[sap], service_name, service_name_len))
 			return sap;
 	}
 
-- 
2.53.0



