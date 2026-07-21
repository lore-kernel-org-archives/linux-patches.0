Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9821417D67;
	Tue, 21 Jul 2026 19:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661175; cv=none; b=pnYgSyslBFQuKv9EoPVPTq3s3EBLSu1nVQTM8hluAJa/4YC7UHDHugWg49J+c59VGO48GNMNf0QvQnGHSyvQaqKt8U9H42NIDJ2fSFoD+6kwAtuMrK51Ra8JFlQl2tAxf/iPrfyLaamMAi0d9K/0K9Oxg06woMsK9Cjl4g76yu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661175; c=relaxed/simple;
	bh=9bMihvtWnvvK8fFnDmC/w0MAI+5RnknmNyTzA8pyvgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF+bWoFtNvHDeC/in/adauh+sEXfNUWNWfsSdOqBM/eWllygzQ+jnenFEuGrR0wTqSXRSkMiRCYwzS4wHOWobdbn0U1hsuZXrl4QXqcBLceVF8p4hGagZ+Ry5A8V+zYMg8dzHoPj4WL7dgNBbTMIwLVt9KSR9rFRQhmNMe55Too=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3HTFN8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3HTFN8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB6F1F00A3A;
	Tue, 21 Jul 2026 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661174;
	bh=3ls9aIpc/ikVXh37P7EbJvopr07yhpbouo/bm29+obY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3HTFN8U6CDl3X2wih+PKPZHpyMBOz75jFxZDHJsb57oNhzwZ3bM62XJ4fOSWyuBw
	 6GDQfexANuGrfS9BupwwQyjiCe/XkqWQNW55/jmAOWo+24H/x8sgIaD8Me/Ly2lYeN
	 EnB0qMctSqEmc0yMZmihi3Ngj2GmSIPD929CsYb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1260/2077] ipv6: fix error handling in ignore_routes_with_linkdown sysctl
Date: Tue, 21 Jul 2026 17:15:33 +0200
Message-ID: <20260721152622.533546844@linuxfoundation.org>
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
index 0cd225c9d7a846..da6531f5d0ef18 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6663,6 +6663,8 @@ int addrconf_sysctl_ignore_routes_with_linkdown(const struct ctl_table *ctl,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_linkdown(ctl, valp, val);
-- 
2.53.0



