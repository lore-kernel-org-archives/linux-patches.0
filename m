Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E76744211F;
	Tue, 21 Jul 2026 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674091; cv=none; b=m26IYZrQZHpvCEMefBiGvv3fVzL+sKGryWQcxV/Cbzb9okTtVwoFWuVaBMds8JObNazbjYlgxXrKjdY9Jy6bDTkPm5nK1yl2UC8wPJKQ2G9DUgcoAl3nIruT/lJ639aUqmGRkXwNgyOk2JnB0/gug0ej7DfQtb9JgWbHfrctliE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674091; c=relaxed/simple;
	bh=YYbiw6UHjS9TUKJrVpvveklMvBoZtzlKuaw9PQunOC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7f+xfp5msWIfwT6/Nw4MdGxkEJwkmoanwFQ8jCWYrU42KtO/+/tjpzwB2nkAwKuBtPljyKK7VZ4bkGM+hEfoSuHpwg3X467bI2VcYs9dI26PRzMsALT/3ZMChWxrrFCFojk9Mf2RjRSdR5Noovz+kicyrLUb6RaHRkqLxE89Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRBl+joK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRBl+joK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DF01F000E9;
	Tue, 21 Jul 2026 22:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674085;
	bh=mZ6N1nFArLYVRLr3WZkH/pcDfrLJ6F2J2mbefFA0r8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRBl+joKq7P/YVhYvDP99STdEezc7wJBTCKRZn5KIyor1PRvFZsO4VI84dMpUB0CV
	 rkJu3m2+Lq6wFac9pIvRgIYP+aXsoO+HcDZuxzLM68K52SRgUVYBSlbj7sRCA+bXRn
	 pzENJ7L9UhhDKjJw6oQN03oG4CgIPP7SRI6z0TpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/699] ipv6: fix error handling in forwarding sysctl
Date: Tue, 21 Jul 2026 17:22:04 +0200
Message-ID: <20260721152403.927505238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 058b9b19f9639fe1e1225a17c540f61b65bee6ad ]

When writing to the forwarding sysctl, if proc_dointvec() fails to parse
the input, it returns a negative error code. The current implementation
is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure. In addition, adjust return code of
addrconf_fixup_forwarding() for successful operation.

Fixes: b325fddb7f86 ("ipv6: Fix sysctl unregistration deadlock")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-4-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8c33e4cfa320e4..288178ee2c72ce 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -907,7 +907,7 @@ static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)
 
 	if (newf)
 		rt6_purge_dflt_routers(net);
-	return 1;
+	return 0;
 }
 
 static void addrconf_linkdown_change(struct net *net, __s32 newf)
@@ -6194,6 +6194,8 @@ static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_forwarding(ctl, valp, val);
-- 
2.53.0



