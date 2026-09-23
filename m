Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6983334C3B;
	Wed, 23 Sep 2026 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173320; cv=none; b=TNJx/SIOh9AS2mr2wy9mSw5dp6uEmPO3FEaRNLaDhQ6wHixsITa5G1ADnHKy+pqoS9Q08wCuBpsgofHNydlVo8vsN9rXloDYVn1um8aQiW6Q+93pJRhGxbK7DuFtCBOms/pDGcyz8s9MAghlYz+jPEiq50u07I4aPd38+ut/cIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173320; c=relaxed/simple;
	bh=7qE6rp69nR2Icatmff2YmYqAVMqthcHSCymDQDxjKEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu+9BSEycqJwVM4XrTFQoG/PR6GLhsUIWMowPF2A7qe66pkRCTYOJcmQZ1FTWrWt4RWu+1C0rdC3tMBA+ubKyTxW8PNyh14f8mV6Ni2rEpULwF8qTeTgdrn/kg1MBr/hTrEvqU50J/Lffel1z+sslC70ZoAVtwhh2HYQA8Q5H1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09tJYVrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09tJYVrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99E81F000FF;
	Wed, 23 Sep 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173319;
	bh=pBzxbri98l5hfILfqDGmezhdA5SKZ4DicipzYSIPSsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09tJYVrpUCNwZmtu6a4sWihGuTuamOVuIaEcVCHEuhS/LyRxhrZblXg77N0IPhQNp
	 SQucriAKYg3XDCLeCayH/EgyuQ8xrtTv1K7msPdOKMorGMvNTVay/Oq1sWuOYn1MX0
	 10u9Sll5nznp78uXzE10X7sCDSqTGA7DBWIs0aSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 209/438] net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check
Date: Wed, 23 Sep 2026 16:03:50 +0200
Message-ID: <20260923140650.177967426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Farhad Alemi <farhad.alemi@berkeley.edu>

[ Upstream commit 150dba2c69e93302af24a0c868eebe4871e2e107 ]

ipip_fill_forward_path() and ip6_tnl_fill_forward_path() look up the
route to the tunnel's remote endpoint and set ctx->dev to its device,
which is the tunnel itself when that route resolves back to the tunnel.
dev_fill_forward_path() then makes no progress and trips
WARN_ON_ONCE(last_dev == ctx->dev) as soon as a flowtable tries to
offload a flow through the tunnel. That routing loop is a configuration
any CAP_NET_ADMIN user can set up, and ip_tunnel_xmit() and
ip6_tnl_xmit() already treat it as a tx error, so remove the warning and
just fail the walk, as commit 008e7a7c293b ("net: remove WARN_ON_ONCE
when accessing forward path array") did for the path stack overflow.

Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/CA+0ovCgKDOk+Bg6Gh5Lwx94u_jJjQ30-vY1JcY2BYfhnWJJbPA@mail.gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 679e75d3699ae..ff25e4c71588e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -789,7 +789,7 @@ int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			goto err_out;
 
 		stack->num_paths++;
-		if (WARN_ON_ONCE(last_dev == ctx->dev))
+		if (last_dev == ctx->dev)
 			goto err_out;
 	}
 
-- 
2.53.0



