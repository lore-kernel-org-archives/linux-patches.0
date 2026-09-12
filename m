Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB9D41169F;
	Sat, 12 Sep 2026 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211591; cv=none; b=dgWFfZ8+T0NjMVtw2nkkwEdTMIFB4IOUzFkkKnqd6F/jconR09cGKsVXrimtjk0AmYwd/qzYrGdR5++FILiG3vHcolT3sTB+kdIX7Cdpmx3fRx5czgTFuap0HTV2SP2ANu/oHIDWNUV5Ks3ZEwHAFqr7g4rr3Na68FYfTEczSfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211591; c=relaxed/simple;
	bh=RPly1hY6L7FLP0kNGgSOKnm99qE6F9jY/cr/tMycrP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3U693emo3RWcAI+mSfnXNlR6MLyGU/Bfrx+zYR3/i1A+GnrBAyrfDNOVBTNXc7w5ILLNUh14iWKTESrktaTmrk9w+vj1fv4LFD5k8J2jUVy/fwO+gcC7Sb2tPDeAqAp7BQUloDPnZiGXHGlwjxZmByCHJAAzv2a1rxbGbYyELM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Cd6ldW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Cd6ldW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DA71F000FF;
	Sat, 12 Sep 2026 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211589;
	bh=oWkDpccwuuRrLRlROTQvWoKIKf/YorV78Db1/XFGq0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Cd6ldW+3S6uBYrdjw8KBZNtHgON2tbrY1cw57S8rcSee6JAUd9uNTVnRJLJ8V055
	 U1KB+30OgtUq8NGmwwaYOqhsdZ14PPPnGSxFkuwlGzv6dJV7k4PABDWRz1PEKjMw1q
	 OpArPTk6yCrWNJrY84wibLxzqochJW1Xqiusftuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1262/1518] net: dsa: b53: fix error propagation from b53_fdb_dump()
Date: Sat, 12 Sep 2026 08:57:11 +0200
Message-ID: <20260912065652.060637736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7d6ec2eb7c75e..508b46237011d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2204,7 +2204,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	mutex_unlock(&priv->arl_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-- 
2.53.0



