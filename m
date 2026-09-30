Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418223515DC;
	Wed, 30 Sep 2026 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793151; cv=none; b=l2V8UEdAka55nOS9EjJ64jJSOcG8wQvkX2/lwNUBcG8aYwz16wcv9Mn+T5M7mrSwn4YoSX3M9hZerYH9tVVYc6wCjOdYa3aBf4HUwWupUUQQzeS+UWdmnFHWeQmBp2IMEZSJDgAgbtlb2k9AfEfNgun2w164N4ubyquGrWdWZNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793151; c=relaxed/simple;
	bh=vW6SVQdg2dqt2DQXZzlhrhGHR7BN1CYuwJPsE5Xw93I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OE686TMe9/IWeQ9389foqqcMQlsxg5c8lWK1zPjq4zg2DNssQeHIjPgsgw1lbb2rFnoE3dUprcDZL7M376WlT9ZpdIDQv0ncGmjlnDwH082z/en/VQBdIYuxqer9/TBKCz3mjQ5i1oZseLCdk+cAestiO3A5X6ygiZFLXYZh2ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B27Eiuev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B27Eiuev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A4C1F000FF;
	Wed, 30 Sep 2026 18:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793149;
	bh=bXn9iSx/72FQz+pKUYUBb+Ib3jw7LbOKzHv55qhtIzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B27EiuevxT1ng1i1tagK2QgmO4AmqhLwCb2Zr761RipadsO7tKQ2AZYLp6Bq/6i0Z
	 GLuGarMfhFJQDfJpTQB4PcBoOYgTKmRqIbZzhzjgrtty70bC8NU09n2ziG3e2Cv188
	 sdDlsrEyUzt5MbWMLLR9bgWKnIMjafBOIwXMCCkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/395] nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()
Date: Wed, 30 Sep 2026 17:26:54 +0200
Message-ID: <20260930152343.941141270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 856b3d1710020..db729dc9def5a 100644
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



