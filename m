Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C746A4CA784;
	Wed, 30 Sep 2026 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787289; cv=none; b=iXSSnVHLrSkMl82wnnAmTUYPT7T8DLB2nUIFkNMj5HAFTNoZQqcScDT3eIRmZIAQcec2nrKLwiWnpijiWpfVDNI7UHetTBg10zw46tAyqzXi3MKus1/Y8/6Nl1qhLBBnCXc4HDHnPjEj/0ACAyJd6oR/64nLIcIixZgHb7mcdbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787289; c=relaxed/simple;
	bh=YkOHHxBSsU7zR/5Y/quc1QScFOKb1utuP+/Fy8TWZ+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ke/iv6p/xKL8RRvRfS+d0Yu8+NTgEpnJ9A36OtcudK5oUE9hoHL31lFiIv+AXQhpT+DMe5UUAZfHUAozudOmaBct05iEecmCR8WI0bMBc6sTaRvTJyEai5iCs7Ou1GBczXfOVTU9T28XwzuNPfnxfgB0QEZ8ymVUYATAEarPA1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtRAjJg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtRAjJg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC1C1F000FF;
	Wed, 30 Sep 2026 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787288;
	bh=zzPcA5lqwlRzig0wR4ZHtyN0aMCQAuKDIbsfbhiAUxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtRAjJg/WoGbFYgiWhQOFttFvxMvla4gECLwPYGbOyVTTDOAxGXzTcq+3lT1MUg5y
	 eKTaxOOGGX40hnBWVqSajnrCBqjk2VpjiKCGiZTM348zYf3VIX+3yu615yue+ACs1y
	 iZGLPUMIGvInRJuBsX33HQpiKrUZStDV51fVpt30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 178/457] nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()
Date: Wed, 30 Sep 2026 17:24:43 +0200
Message-ID: <20260930152349.896735287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 23553e7426ec2..fc267533a67f2 100644
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



