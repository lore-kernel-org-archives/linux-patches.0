Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E58415F20;
	Tue, 21 Jul 2026 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659885; cv=none; b=LzrtcWyP9O8OIzcACmiZO0VcNppJMjjI+holk0PVFNKcedGMFIP9HuPKY/oEW6bBozliZfxAIlsGjfuWgV2NP7k6vqe+z5Cz+DOqWvr34VG5LSS0yRy/VlZJiR2t1/rlLQhzPDIdfLBT0dM8lQOVXprn03nm4DRWE27p3jDD+30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659885; c=relaxed/simple;
	bh=rlOT20oyma+ynov8KZWP2oxx32nsOZOcpEYIWNzQAdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMZfgIrWVnxbXmAnEQK4hOQqomKOksBG+KBctXXOnxW7Tgy/3CLKOqAl7VV3h0F1XfVjAd0YlmmVpDx8ebkgMS0SozlBD2bkXy5Xd0rXr6GtjRrwZ+LKNhjOTs9dQKoQf9asrjwbTclrUnoUbZ9U5bAD7awhxzlwDn26EWtoCE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBb/IK0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBb/IK0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257E71F00A3A;
	Tue, 21 Jul 2026 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659881;
	bh=yKwi4xB2JBb6Poke/r1KGCpuFgGj8eDBdgKJgooWWRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBb/IK0vnRJQzS4S0IDoKxz9CWd4APw1TZPk/PMCNIQqGhVkZGZWo8JuBY0+Aqglx
	 zCZvnZqDP5gONU8YrjnffELhFLNpfFpJuwaMCV9JDFdt1eqa56TNGQ+y5mQNkV5fVS
	 x7OMZyFhZqG51XYUbPqn2unx2ru1vxZqy5rh2WvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0768/2077] net: airoha: Fix debugfs new-tuple display for IPv4 ROUTE entries
Date: Tue, 21 Jul 2026 17:07:21 +0200
Message-ID: <20260721152610.910539659@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit 1c3a77471afbb3981af28f7f7c8b2487558e4b00 ]

In airoha_ppe_debugfs_foe_show(), the second switch statement falls
through from PPE_PKT_TYPE_IPV4_HNAPT/DSLITE to PPE_PKT_TYPE_IPV4_ROUTE,
accessing hwe->ipv4.new_tuple for all three types. However, IPv4 ROUTE
(3-tuple) entries do not contain a valid new_tuple — this field is only
meaningful for NATted flows (HNAPT/DSLITE). For ROUTE entries, the
memory at the new_tuple offset holds routing information, not NAT data,
so displaying "new=" produces garbage output.

Display new_tuple only for HNAPT and DSLITE, and let IPV4_ROUTE fall
through to the default case.

Fixes: 3fe15c640f38 ("net: airoha: Introduce PPE debugfs support")
Link: https://lore.kernel.org/6a2b40ea.4dd82583.3a5c46.e5a2@mx.google.com
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2be54b.ef98c1b2.3c3224.2ed8@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe_debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c b/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c
index 0112c41150bb05..e46a98514486ff 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c
@@ -121,8 +121,6 @@ static int airoha_ppe_debugfs_foe_show(struct seq_file *m, void *private,
 		case PPE_PKT_TYPE_IPV4_DSLITE:
 			src_port = &hwe->ipv4.new_tuple.src_port;
 			dest_port = &hwe->ipv4.new_tuple.dest_port;
-			fallthrough;
-		case PPE_PKT_TYPE_IPV4_ROUTE:
 			src_addr = &hwe->ipv4.new_tuple.src_ip;
 			dest_addr = &hwe->ipv4.new_tuple.dest_ip;
 			seq_puts(m, " new=");
-- 
2.53.0



