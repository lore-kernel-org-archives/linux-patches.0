Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44E400E09;
	Wed, 20 May 2026 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302919; cv=none; b=hFm6ZVri2yM+vJQlOn0u9JshPUh6hNSS4vqPWZjHT9tVmCykFIe033UEaQeOuamstPsXQQ1CtKaN0ryOg+W86EN7yz+JKQBRhYAbozXqmDQa9TjJBOTi2dy6lu8FFTh0eglobMTlCegBtlIR5u+oiUkn0gUA9d5wyRjekhNAMC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302919; c=relaxed/simple;
	bh=EYIvuIxASjM8lB0DrTvetkLJqGOAfXf9vG0rH6Ju+ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sTulmCYHTVlZH736Fs93OzkPpQOo6pLzaOgrLzizhbR6thA+xM3NVVv+QvN/Qg1TaTF4hFvutvJev8h7gj0fJo8d1t3okp8/xK5BNv20VR3OCzLo1oSS0CGPIb/FttJ/+UFn2r12B7CfjY+44BTXxrmO3sW0JYeF3C6BIWkTUvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYaXuYX1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYaXuYX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E081F000E9;
	Wed, 20 May 2026 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302917;
	bh=V4l5xTNxGoQQL2B5qcJoPAqIiLDsovhXUkE/Vt93KXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYaXuYX1qeW0f2dd2wRMB+aBwWN/7ayPhuy4U1+ADHgHImFnSCrmFvXnIUERuTDkY
	 AiwWTzwkexZBsVKt1ik3j6F7nIiOQCkBYzksv0okGTRySmrp45IcvuznmHAA+VXY8H
	 KG8S5vhx48NHS1EV2G3p5Xb/ELd3V5h5SOm3l3x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 450/508] bonding: fix NULL pointer dereference in actor_port_prio setting
Date: Wed, 20 May 2026 18:24:33 +0200
Message-ID: <20260520162108.346487527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 067bf016e99ad72aa4ff869d6dec1fd62a9c6202 ]

Liang reported an issue where setting a slave’s actor_port_prio to
predefined values such as 0, 255, or 65535 would cause a system crash.

The problem occurs because in bond_opt_parse(), when the provided value
matches a predefined table entry, the function returns that table entry,
which does not contain slave information. Later, in
bond_option_actor_port_prio_set(), calling bond_slave_get_rtnl() leads
to a NULL pointer dereference.

Since actor_port_prio is defined as a u16 and initialized to the default
value of 255 in ad_initialize_port(), there is no need for the
bond_actor_port_prio_tbl. Using the BOND_OPTFLAG_RAWVAL flag is sufficient.

Fixes: 6b6dc81ee7e8 ("bonding: add support for per-port LACP actor priority")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251105072620.164841-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_options.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index f4ad0fc624c98..5b6c01b31f985 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -225,13 +225,6 @@ static const struct bond_opt_value bond_ad_actor_sys_prio_tbl[] = {
 	{ NULL,      -1,    0},
 };
 
-static const struct bond_opt_value bond_actor_port_prio_tbl[] = {
-	{ "minval",  0,     BOND_VALFLAG_MIN},
-	{ "maxval",  65535, BOND_VALFLAG_MAX},
-	{ "default", 255,   BOND_VALFLAG_DEFAULT},
-	{ NULL,      -1,    0},
-};
-
 static const struct bond_opt_value bond_ad_user_port_key_tbl[] = {
 	{ "minval",  0,     BOND_VALFLAG_MIN | BOND_VALFLAG_DEFAULT},
 	{ "maxval",  1023,  BOND_VALFLAG_MAX},
@@ -497,7 +490,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.id = BOND_OPT_ACTOR_PORT_PRIO,
 		.name = "actor_port_prio",
 		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_8023AD)),
-		.values = bond_actor_port_prio_tbl,
+		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_actor_port_prio_set,
 	},
 	[BOND_OPT_AD_ACTOR_SYSTEM] = {
-- 
2.53.0



