Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02036415F0D;
	Tue, 21 Jul 2026 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656813; cv=none; b=fnr+4lU09sonmSqLvvhcuTrpMxYeysJ8aHDx6CnLfE9tUYGnIN0cfCCrPI7IDpIAwnfp+oEKp+Jy7W72emp2M/7wxAE7Bkd39BfSFvIcthr6p+pAcEvxET2l/inXJUxuBNmzea1SUKloijx3AxeUTSiPu5kAFV8figUvG0zVdwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656813; c=relaxed/simple;
	bh=F2k4qKHo/oUy13zTejFeKj0M4K4lglSGMOrmVsF8HKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayHtBZNde5c6Tauecn9Q0WRx1OkZhnERDDlm8Nm7oMsotH+4HIOxON23NtUJLzFB5ruPvQFOZijRhEAoNz6waTWbs/KA9KW8owDTNDs7yVEkvJdS+rClOgI+LKenrTV/il9JbOdSHKuMkWDCQnaiE7xHVS+aMZbGNdcqbHFNY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r07ifC/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r07ifC/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666E31F000E9;
	Tue, 21 Jul 2026 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656811;
	bh=DsQd5Di5tgNJZOTV+ML6Ze+5cryuJwgv0zr9nYjlv64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r07ifC/mywGhlTER4yn3mBBkaRbs202SnMk81yCIXjwpy50oIsQBhodrV3NuWp0Uu
	 ggFI7ZyPXkZVUsQdrZ4MgNZyVOrFLZ5caxgvfa2t9kdXVnXpJ/f9741YwACp09X0Rn
	 FHcTiujjG8+atdo7T8j7E6zSoPTS3zCfL5rfjELk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0529/1611] net: airoha: Fix debugfs new-tuple display for IPv4 ROUTE entries
Date: Tue, 21 Jul 2026 17:10:45 +0200
Message-ID: <20260721152527.248721937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



