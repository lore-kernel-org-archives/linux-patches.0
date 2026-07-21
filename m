Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9733B6BF0;
	Tue, 21 Jul 2026 22:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672053; cv=none; b=eDJJo3npeQ1LVXDPgwtWybkywo5y8OoJsObqgFwQ7sAhsh9novJvzerWiIu/FUXV4VhAGTg2za0YNhJUN2ZOTA1RcM0BH68XmRD4u7wF3FTR6lIisWekKooLaFCPaIzR9nLDPIwjhA2W4cQFDbufnKDAHkLdWmlM/ETfMb5b72o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672053; c=relaxed/simple;
	bh=cW87JOWdUW//5KHXKnViWwDUcbZza0kQJd06OhPqw9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfdeqom0zx3/j6w3yyTYhn0rP1wvHuDOQkB1ngf8zHElWPW0qByXn3S/MUyIANdNCeT3LKTo03f3Q+yuDCEkmoNhkP+xnoubb+AbxSUiJY+fek+LquZrQx/zLQL33pALSRhHMc4D0Hg+BTHUmxTc5etW+OUC5v1Ej5M/fZQtKE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6LWCq+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6LWCq+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2219B1F00A3D;
	Tue, 21 Jul 2026 22:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672052;
	bh=OPpPy05FVJs4h4Y7xyca5kYrEW7cThnYoZbytFwHL1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6LWCq+tzYXQaLx3N9231X4Jm8UnaUrYRgekh/dMyZ5KSX4HWzG24qF0WeduB+fA1
	 KMdZd/AbqRLLaPiTCm0ksCbrkXdy2iCo3P+ApGUcpYUxWWkS5ZhlOb9nlVN88DG4/O
	 9H7V59ohza3D8J41cgZtE/hG4Y7CDh6aEbmEcIAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/843] ipv6: fix error handling in forwarding sysctl
Date: Tue, 21 Jul 2026 17:21:53 +0200
Message-ID: <20260721152416.787682526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5f257a133b2ab7..2e46a570b162a4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -917,7 +917,7 @@ static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)
 
 	if (newf)
 		rt6_purge_dflt_routers(net);
-	return 1;
+	return 0;
 }
 
 static void addrconf_linkdown_change(struct net *net, __s32 newf)
@@ -6253,6 +6253,8 @@ static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_forwarding(ctl, valp, val);
-- 
2.53.0



