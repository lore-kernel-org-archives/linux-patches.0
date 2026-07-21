Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C77403EA1;
	Tue, 21 Jul 2026 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672170; cv=none; b=rCo25I/v9qdqisDQEIyBPjzyqisprKKfO4hqkuTJtbb9DjY4aQBAB7D5LSuyLXOMEryg5UrFas5LO6RX5nLsgfpajGoTTg/wox6VtVdXO0Mf+K3K2/lLfWfTOxP64ZdqTyF8v5kfWYAaMcweWUxYBeQLulAm2tmrI2oQ/SeOTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672170; c=relaxed/simple;
	bh=iE2WNQQ3GJwnzaGvofESZuEqLnygDtE/WG372xxDP/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtrEpfOXGb2YZHecLyEKyQDL+4KQqUfsF7uG/Jlg17Itsa3SAH7HncLeONzdXveNNTnsloADwh9UwXH4zLK1cYs6uGoVqRQ9EUO8LfJvnxkGq83+FRR6VulLpKZCHNeto+lYKcRzJm+VvjG5066Id6w8nsbbDApEfsiQDUsBKOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GruNu1hd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GruNu1hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB051F000E9;
	Tue, 21 Jul 2026 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672168;
	bh=A0TAPTHgrGI8bxoQw3RijprhgBjuUx7c7Wv31PEKUD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GruNu1hdNtwwKUyHmt9GiCqiad2VonH+o5Lr+Mo9vgO9IFO1Kk5I6+BcmOmqIw3gp
	 3SYwXhB/FuE3ttMjTrlQk2AR2BoxEhMrHJdP46nwTipMFqGY1CVB7FFIPXKdqk0LSM
	 nc523xcKQF7gxZEBnkw1+DlUoavF3GAMFXBHLmMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/843] netfilter: xt_connmark: reject invalid shift parameters
Date: Tue, 21 Jul 2026 17:22:37 +0200
Message-ID: <20260721152417.772444103@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

[ Upstream commit 1b47026fb4b35bac850ad6e8a4ad7fc018e09ebc ]

Revision 2 of the CONNMARK target accepts user-controlled shift
parameters and applies them to 32-bit mark values in
connmark_tg_shift().

A shift_bits value of 32 or more triggers an undefined-shift bug when
the rule is evaluated. Invalid shift_dir values are also accepted and
silently fall back to the left-shift path.

Reject invalid revision-2 shift parameters in connmark_tg_check() so
malformed rules fail at installation time, before they can reach the
packet path.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_connmark.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 4277084de2e70c..2cf27f7d59b95f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -112,6 +112,16 @@ static int connmark_tg_check(const struct xt_tgchk_param *par)
 	return ret;
 }
 
+static int connmark_tg_check_v2(const struct xt_tgchk_param *par)
+{
+	const struct xt_connmark_tginfo2 *info = par->targinfo;
+
+	if (info->shift_dir > D_SHIFT_RIGHT || info->shift_bits >= 32)
+		return -EINVAL;
+
+	return connmark_tg_check(par);
+}
+
 static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	nf_ct_netns_put(par->net, par->family);
@@ -162,7 +172,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.name           = "CONNMARK",
 		.revision       = 2,
 		.family         = NFPROTO_IPV4,
-		.checkentry     = connmark_tg_check,
+		.checkentry     = connmark_tg_check_v2,
 		.target         = connmark_tg_v2,
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
@@ -183,7 +193,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.name           = "CONNMARK",
 		.revision       = 2,
 		.family         = NFPROTO_IPV6,
-		.checkentry     = connmark_tg_check,
+		.checkentry     = connmark_tg_check_v2,
 		.target         = connmark_tg_v2,
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
-- 
2.53.0



