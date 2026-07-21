Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA263EEAC7;
	Tue, 21 Jul 2026 19:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661178; cv=none; b=Q2AZ7uGMEw9z/aZJne6uzaAHDDaqli3tPnGaB+sPR07Txi0QfndFs6ooeBD7occ8RA8Vd958k37GUHMdJTFI4c4dZdBXtbQOMBWcxAG76XZaMzq6o13vdV7KkRUq0Kb5rS4x8QgwyLYxBfHJgBQEzY9bDl/sS/WHEcE1f27LTNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661178; c=relaxed/simple;
	bh=2CKbt1sIcHDee7uAg20gkDncsK78wX+PDLyg52Vh9ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7dL0c0U3rQV3jtT3nmMKaS9EF/QkpH+0keajIdN3xf8zQ6KDY5QrsMIg77DGEQH2cXPjeQzF9pxl/57zpKxCIErhlU0HrrxpV60YrUDOi9MDtVmQS9tWBuUksoTPeQ6Zdmmoz8LmnyU0XUYIkUCESz8TfJBIKRjy3l1I3t9S+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkDpLJ3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkDpLJ3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C781F000E9;
	Tue, 21 Jul 2026 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661177;
	bh=8S8RrPqh0H05aP3pIsTlnsYNzuBPKXpwZ7SnxY3FebE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkDpLJ3ejMbTC8JoJZbnNPo0kDcngNo/bI45bMWneM8mfqNFmAVDET5oJ2PTCTkWM
	 fZXyYv4V+WwZ7OD1pKl31RCl+O+gGyfyGACn4FTX3ZJIAPy9Q8gIldX8eJHv8o4BBz
	 0rOQo4y+p4dQo6UUD3m4KiEyMVCPBdK7TtzsPcvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1261/2077] ipv6: fix error handling in forwarding sysctl
Date: Tue, 21 Jul 2026 17:15:34 +0200
Message-ID: <20260721152622.557661355@linuxfoundation.org>
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
index da6531f5d0ef18..c15c9e63a2ccf3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -913,7 +913,7 @@ static int addrconf_fixup_forwarding(const struct ctl_table *table, int *p, int
 
 	if (newf)
 		rt6_purge_dflt_routers(net);
-	return 1;
+	return 0;
 }
 
 static void addrconf_linkdown_change(struct net *net, __s32 newf)
@@ -6362,6 +6362,8 @@ static int addrconf_sysctl_forward(const struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_forwarding(ctl, valp, val);
-- 
2.53.0



