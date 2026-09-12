Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91939365A0B;
	Sat, 12 Sep 2026 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204213; cv=none; b=P57xU121sZBYNpB+HhH5oWPI348DnYGpdycYHw6/pe0T67L25ArmYmqGDWaVdEwh/QwNxhcZAqjZQ96H2ryHvjUrxQbf1sWiS2oO9PS6JYZg284odOHEXt6gwuOghtxFWLBtUMPXLs2993GqHgiAxfyDKEchz/jxRMCoavdO2rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204213; c=relaxed/simple;
	bh=3By1Yyv1lfm+J3ErG6nuQI8Va4NJNfDIq9k4KYHXe98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6SdHV0+HFt98eOeEUJa6n4XZhKSqilKV4mxxqRqN7IZH2sY7NZ1imDonMkUtQw8J3K6u+HcxcTHkw11eJNei99dHsXY0eUD/SjMDTZMBzD4NKcuFDPxk0kOpaULM0tQppMk64Cc3TSJmXOlkQPzmyKFCPJ3H78RLAEfQcUfPQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WInJKEZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WInJKEZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C4A1F000FF;
	Sat, 12 Sep 2026 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204212;
	bh=2P6GneSB7ytISWxJREdLyLON3j8B5CzH+RjLIVecB3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WInJKEZ5Ik+wIpEmHaWmQSLN5+iqt0ZMZZOk5cMgYU8eTIp8GRCBbqsSWWD2uxRtI
	 NQZzX88MHpS+rBEkz9nblmnWxe0e5rXCmiCgbVK93PKndUbY/NjVXkpz7tti8k0CvE
	 5qaf362UmrRBheYa1rOAPp5DPL9pjECtU5PmnbKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1567/1815] net: dsa: b53: fix error propagation from b53_fdb_dump()
Date: Sat, 12 Sep 2026 08:55:17 +0200
Message-ID: <20260912065725.781151453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4f1d06cf8aaa9d2cb18e5ee8835aff6177256bc6 ]

The blamed commit replaced "return ret" statements in b53_fdb_dump()
with "break;" which jumps to the mutex_unlock() -> return 0 section.

This is notably problematic because it swallows errors from the
b53_fdb_copy() -> cb() path, and this will result in FDB dump truncation
when the netlink skb overflows - see commit 21b52fed928e ("net: dsa:
sja1105: fix broken backpressure in .port_fdb_dump").

Let's go back to "return ret". We don't need to preinitialize "ret" with
0, because the "do {} while" block guarantees we cannot reach the end of
the function without at least once calling b53_arl_search_wait(), which
will have initialized ret to some valid value.

Fixes: f7eb4a1c0864 ("net: dsa: b53: serialize access to the ARL table")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260812201121.2012356-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3f5b9592794da..0880310c9ce3f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2219,7 +2219,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	mutex_unlock(&priv->arl_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-- 
2.53.0



