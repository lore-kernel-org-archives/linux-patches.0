Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4A421A07;
	Tue, 21 Jul 2026 21:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669661; cv=none; b=XMokTxFLeLMLA8AvGONpDuNM+mB2rQbve225wEus13BFRRJo2/DdaCufAsHba1yAUC1/P31zG8Arcvt2T4/3sLRbFU+VuO4DwxGXkVYcWAlBn3yrARuflIUd9WqsvjHQB8PVju9DZHtoYBBmOJKlON94Euir/6q1X/o4dZ0sWug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669661; c=relaxed/simple;
	bh=PK4/gmQCUZ4UcoVLoYj2cP5agLsrc8NcM5riYv2Ohog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwoYke/clpFpgBh3fZAVff5XbjF3q6qgDJFoN488J61EjP1DIP5+jK2jBwZRiAEtINoTfGzA/XE+W0S7XHZ5GaMCjJE138R4zkC8+AR1omfyiSynIWVa3/cIiYrrvGrRZ/seiZpzNkdt0qRvfh3vclaXv5KDXGCfYAF2sYCxvko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rI1Plbt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rI1Plbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41DC1F00A3A;
	Tue, 21 Jul 2026 21:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669658;
	bh=Yg4S0fiMoElg6Ep86KWr2AqTslBQuh1CBx29SNWPuJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rI1Plbtnr4Br6NWw6WRn1gEBPo2m+2aHsAf+TgeDdLExofEvNZfAOcCsMP6RQAcG
	 kyo0pwrnfqzrWgDSoupjEHjbRLEXu4lQiJlgL3XkfDR5dDAPZU8cjGzoMd0yIotIC7
	 JkLlPTk0eJaDkDg7aFpP1Z1uMATDmek1l4AQimuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0637/1067] ipv6: fix error handling in ignore_routes_with_linkdown sysctl
Date: Tue, 21 Jul 2026 17:20:38 +0200
Message-ID: <20260721152438.844361862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit cf4f2b14401f29ccac56393ca9e4b42a2505f540 ]

When writing to the ignore_routes_with_linkdown sysctl, if
proc_dointvec() fails to parse the input, it returns a negative error
code. The current implementation is overwriting that error for write
operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 35103d11173b ("net: ipv6 sysctl option to ignore routes when nexthop link is down")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-3-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 2ae1548f58737d..7994b93ccaed9f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6574,6 +6574,8 @@ int addrconf_sysctl_ignore_routes_with_linkdown(struct ctl_table *ctl,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_linkdown(ctl, valp, val);
-- 
2.53.0



