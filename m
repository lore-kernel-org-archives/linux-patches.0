Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C12533E36A;
	Sat, 30 May 2026 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162040; cv=none; b=p20krZEe7/xmD5DWK0cSdAYdfaeMdpKbw7ysa2eplrintp4IxP/YZe1ooRp+lXCxgjfbuEXhMBzYAn2/4hSlhhccN8CQo5ejhJysxn4lf4fOUsC73r9lY/OJVB56OKxYzAld7M8LnPJal58OX+4AOkngH1auxI1bPgLzXAfDlSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162040; c=relaxed/simple;
	bh=CbOw6TFrSFKhp8Lo+/zrU4Z7DBlnF2gyNa/NRijSHe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJ7KAAL3rl+YPpysWKG2FSGNtk9Q2vsRPG8dwaSiofybarRlwjoMu7obJauda0N3F6sa9maiBdeCQCziZq0M5qeZD6o/h6LdS+UJmUBG/3Ep3uLVm7Yf5MvW27/tGvsB1hSV7T2IO+0sptS4bLhu1sIzYAMiGbQYfRF9ZZJ5/+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8giFRTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8giFRTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507831F00893;
	Sat, 30 May 2026 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162038;
	bh=jTFnTYGQ7Y7rQrWb0c4j0SSsC9GFG7k8ZGXobeY2dwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8giFRTzL9/rYranqokUkCi7Ai/jW+C1X54+62Xd2MzLyqfURYJIfGnl+0PMLdo/t
	 JGxLKIJ2o/xAG4OB+Bq42zXMeDIBXdlZ6TDcgNqZUGIzXZP5EPk3/M1/kHBzhcqjP6
	 yLNamc2clWvq+Qa0K5HAhnqsLY0bB+uayBjER7ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 803/969] bonding: fix NULL pointer dereference in actor_port_prio setting
Date: Sat, 30 May 2026 18:05:27 +0200
Message-ID: <20260530160322.804040003@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2991290f450ee..40731d180bb50 100644
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



