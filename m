Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3288140B6D4;
	Wed, 30 Sep 2026 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796897; cv=none; b=ryA/AlfLErmBHFzJUa/JBMHBPgQpyGC0MPsiEKut8r0/KkyrS2tRpaFmZsTGn7Agq+JvPK0SrfRQkJRtxDIP81PyUSClSiXsYPHzMpR75O78ifv+XWZprt94elvSkCm9hIAcRA4EDm0VhiYjooPioL92FkFgY/HJDweVtOmvT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796897; c=relaxed/simple;
	bh=hFyROQtSLdUbiXiQVm04zQRF36sRItwiMga91U923Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XT1PXqxGPfgtLUPJkEgQ5LEmG7rVFuKCekgzHQsP2RJYVwVMEgQ4OT2m6Cii4W+JruQItEHvqo5HjupPQ/SF56pm4mO/9mD8fG8IoMTF5xPX7a620EPmeO1P/nqdE7MYdZG08IfBwD7gxRupJ/1Wl85moTJLw7ap6ORvD8XbcNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TITP7Nd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TITP7Nd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911A31F000FF;
	Wed, 30 Sep 2026 19:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796896;
	bh=CVtXaIu0vgXygdClQYSzUNCseyN3S1K3mkHiTH3qFTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TITP7Nd9EtZPzRI6Xya7zw2PirHWSNXNpO92TXcbikQqr36GaASnIktyzkZjk8/AX
	 68r3iwh35M6vCBcaBOgQmEAiQ7Oo/qIV5Rjbl1eSwdylsXSEcLMW7+NA5/tgB2aDhX
	 28sWaYOL2IC9bmnOlaT/BBh8pfo1/Dv079RQcNsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1048/1193] nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()
Date: Wed, 30 Sep 2026 17:28:52 +0200
Message-ID: <20260930152457.503630573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a4d7b2eaebd43..0b1a2755f58ac 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -367,7 +367,8 @@ static int nfc_llcp_wks_sap(const char *service_name, size_t service_name_len)
 		if (wks[sap] == NULL)
 			continue;
 
-		if (strncmp(wks[sap], service_name, service_name_len) == 0)
+		if (strlen(wks[sap]) == service_name_len &&
+		    !strncmp(wks[sap], service_name, service_name_len))
 			return sap;
 	}
 
-- 
2.53.0



