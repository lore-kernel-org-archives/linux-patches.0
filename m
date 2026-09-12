Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8F035E1D5;
	Sat, 12 Sep 2026 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231669; cv=none; b=aF2tiyOHPWQ3jObHDthQc5caKD7B0EbBLnayLxsFoxtIjW7rhfF6Awe3sKajEy3meavB2BlgztYCnjJH4SVI5CEhLDuqKY3r9obbqtrWLqZ4G0bdHwcLpIX55T6eiSZoAGFyHbHgOX/+RiW8C6bVxmb8XvADLkUJRq+Jpp/ESTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231669; c=relaxed/simple;
	bh=pkkPkT3MUdYK2O90lNLRwJJWHPA1AkGnw8r7nKD2aQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bx5M8+h42xDk541+2Gx7iz/IH+nTYVaCBfaX6pw/n/SpMZhqvIIPxQ/7nxdobzGzR4qCFFSTpDkdN0zcs7eYTxvQgAEI+HAaiCkMz8572wLHmwwKzac/XybyNDmZflLdT3tVIOvaORSVsKHEsRRijh7zId9/SUddP7vQLpHCK/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+7nkbml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+7nkbml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08601F000FF;
	Sat, 12 Sep 2026 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231668;
	bh=SAtC5wfm5CFOytzoXrDyVXlmxZUHPcqvSdNxb/ssD+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+7nkbmlvr3hZfWwHLzxUCcCAon6a7OhFUPL4sVA06BsUIvqnT5XLJrWQ2UlW5FEA
	 lwTfTGZUvpOVGNNywjsV7mpGK9mAvZ1Lz4y70hGPhQFP2FQnHyiWntNeiP6n50lqXP
	 herrcXGnAacSEKoDGp47BJ0TdVvbJizHC6SUAbwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1045/1191] net: dsa: b53: fix error propagation from b53_fdb_dump()
Date: Sat, 12 Sep 2026 09:02:53 +0200
Message-ID: <20260912065611.648367166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49fb610db484e..aaf9fbaefd6b9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1863,7 +1863,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	mutex_unlock(&priv->arl_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-- 
2.53.0



