Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D10251121D;
	Wed, 30 Sep 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786632; cv=none; b=qgPuAxZPeFwWpmGsD3eGn579M9xb87tcHhNPZg7kgmuiNZIk1ItJYj754UlMSow0xZPNqrqToVPvSB9IPeLlLckGUQNCe1G0CS3LBmZPNFH+/EyUE0KEFd34G3F1I2Xke+CEGHQlNKfoQ1Za+aw3ZuDqvU3/ACqd1gN9mpebgGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786632; c=relaxed/simple;
	bh=IF+komBU9PxrBkd5p0AyZAeKR3oAVm1F7dgtOdPrIMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJ4hwrnT4px7TNx6VZOO5FiY2mCkZJ1eW5a8y5S+JWAfPmaOG1gZ0DDsg5l677u2Ba9uB9HCmtRFfyhboiwnWXKzVF36EWtqqLcwei4jIz5tIse2MK37BkK3j5BK8a0aQZ5aZk/V5+xEL9y82z2fgWwEbjuaDW5fjYSvCwzbut8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGss5sHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGss5sHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5822D1F00898;
	Wed, 30 Sep 2026 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786630;
	bh=cVEdzHV1lOWDcs4lM/5QJE9a+1YYjoYaBoWfdHEygss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGss5sHYq0uKHjPpOGMVCAnRTUaHVhMXrZb7DLwW7W6kydHh+5hsf+7BstizzBJ/i
	 CexDUGsfapTx9u8+znSdElgCFy8hDKHrwwmSspW4RGTWItaMrJsf52yEsy7TAythEh
	 cH+hVlzxOg2loX36BlqzNc0I99HqINNjKXg8i5qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 885/982] nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()
Date: Wed, 30 Sep 2026 17:27:01 +0200
Message-ID: <20260930152435.757396611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



