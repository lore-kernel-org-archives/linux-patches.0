Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F65534E75D;
	Sat, 12 Sep 2026 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225781; cv=none; b=USZXRwQuSX+3OMS+xoDzo4sHs3Pj0XH+Z+gGXb9wY2++iP3kDwQov1cN7ImAuJsUq6toOzUd3w3G7N8gPEF7VGHxVdLY68w744edKRBelLRjLFGGRbJ/x9PC8A/Za+NsVAOEBIU6Y203rtvqetNpMFHYP9cTwy+xBeWWeovo/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225781; c=relaxed/simple;
	bh=QiPITlSl6BVQUOL0HfEU43aRMptMlQJvVm8O7jUGSoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FU9lam8Zicdw7SqqSl16IStFoOcj0GJSQIgbyGX4m+D0jgsqUtlR+7rDuABD/OskjB6OneaPS1bkNoJLudugakEPP4pORUc/wsi4UdQAMK/44fgz0Hukp5elNjT/lpH5G96btAjhPMgwAWtJMJWY88gFATivJsdXw93UtPlPDVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz9O9rUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz9O9rUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DB41F000FF;
	Sat, 12 Sep 2026 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225773;
	bh=6/2X6HYP+y9ZuWQD1nVt2+N7Ctwp/r54jb5OJT6w4Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vz9O9rUcaj0LEF6x5EufDFELyBHbAnWMdVe2qvUHxp6WQMgVPzEfnnIhRq3850xcm
	 w4jUPc7E9d3O5IvEtq1fye314gu7HW8yAANLsQzKs6SDJ5VBeLDuOAQ90iQZzGsE7K
	 XzDiwb03+SeeyqsZnYb8L3yjMJnYzGV9O7eut2ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1265/1424] net: dsa: b53: fix error propagation from b53_fdb_dump()
Date: Sat, 12 Sep 2026 09:01:37 +0200
Message-ID: <20260912065635.609226543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee20f6487a020..f8b34fa8b99ee 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1894,7 +1894,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	mutex_unlock(&priv->arl_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-- 
2.53.0



