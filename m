Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1121B411661;
	Tue, 21 Jul 2026 19:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661173; cv=none; b=FvYjPmXa+VAh/CLZC5H+ptOaoXJA8yGJ8k39vZ1UoqEM+DNxzujqCN4BNn+NAmTaucgATNdyONvFJkuripVRZt3yV99Otf7EEvA/mNvyoX9vnCJzDK1+PxQbgMLj8ziynHcBNHl4W239IjSdIRvII5W36w9TcCcgwHw88DFr0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661173; c=relaxed/simple;
	bh=9Mw/CiPRmZHZlJXqJWR5eLFXEigMJH+w/pJAVNKolBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR2B5AZPwcoq6NbQbqbJfa1/z/+tnl+CzeYHj9bYsFsrcn12inOsnLk7nTDRNmOZdx0dJZ9MuEHZCQdQxBFHjsU3ec8mdcSUJFqr9MWx3BYOGW/5EgvAk3MFU0kSj9QGjhrWTJw6t2cRUWwGX7BKEmbhFtYfVCAN0Tz28Ti0G4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reNRyjs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reNRyjs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778DA1F00A3A;
	Tue, 21 Jul 2026 19:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661172;
	bh=GCWMmWDgGlx/er5eFYNkZd7jhSxWPRN0msCBWzCLcDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reNRyjs12u5zuPFFqibPHdRI/1L63JxAHyTtlTgt8u9MLVmn8XXQEAUxVUiHUeKNj
	 hBWDsyTWjUSJJsPikgdwK660rrkW0PVs8+FdTTMbP769uGbkqbCA5otLMRiFhLQ8zW
	 Fr9ME+nx7a9ZLbs3V+cRU8af2BUjxMWy1X0yr8OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1259/2077] ipv6: fix error handling in disable_ipv6 sysctl
Date: Tue, 21 Jul 2026 17:15:32 +0200
Message-ID: <20260721152622.510613624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c779441e5070e2268bdfe77f6e2e0de926c431e3 ]

When writing to the disable_ipv6 sysctl, if proc_dointvec() fails to
parse the input, it returns a negative error code. The current
implementation is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 56d417b12e57 ("IPv6: Add 'autoconf' and 'disable_ipv6' module parameters")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 7953f5653451b5..0cd225c9d7a846 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6459,6 +6459,8 @@ static int addrconf_sysctl_disable(const struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
-- 
2.53.0



