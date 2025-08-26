Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD5E3568EC;
	Tue, 26 Aug 2025 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217367; cv=none; b=uKiFSG6MHCCCRI0yfdqAF4xPts7TrVl5L1PG5Srnv0SDyH58tR+7rjDSZ2QO85WDQ/G+SjTWTANble6gflKGRHXs4OPRGK9o5vuXjKiYWvEfue5CNsanekOO62aUfftth0dBhXbmQI3hkM+U5D/dE3ZfZYh7CjoeOa7WqSH/BmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217367; c=relaxed/simple;
	bh=sllNx+MkKnEu1KuuVuEjogaTKCbTUa1+UJSPNssQbHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmB1h3d/vim885IrwC95cmcbgJ9y/zHPfKiiDuwtnwZUL/Ubny0FEZ6yNeKTa79psJn2ImiuZnMNztCH7fJH3tjLTYquLkXQ5kQ2tamRz7bGrz1TFVh6eOXKXL3oHtk06x4v8iY9/JvDq3jiwxPuemLLwOCYQSim+aESX9aLELA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+dqlAab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+dqlAab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709EDC4AF09;
	Tue, 26 Aug 2025 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217366;
	bh=sllNx+MkKnEu1KuuVuEjogaTKCbTUa1+UJSPNssQbHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+dqlAab4I2PdUzAo3K7eOLcWRwOxrUUS9dBDkmPx6Pjq4YqOAdwS6ZHrwEKIDP7r
	 ZOPgHQV2O4ROmFvZIlkdEJp93KIl+ErpIQ1VNRrYHSq9GTmgsJ19oeWY3dNt9pw3bA
	 KIL7Im4gGW+0CvLBO2kM+utwM1iRgAepVNcFrg+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/523] netfilter: xt_nfacct: dont assume acct name is null-terminated
Date: Tue, 26 Aug 2025 13:05:27 +0200
Message-ID: <20250826110927.405924914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit bf58e667af7d96c8eb9411f926a0a0955f41ce21 ]

BUG: KASAN: slab-out-of-bounds in .. lib/vsprintf.c:721
Read of size 1 at addr ffff88801eac95c8 by task syz-executor183/5851
[..]
 string+0x231/0x2b0 lib/vsprintf.c:721
 vsnprintf+0x739/0xf00 lib/vsprintf.c:2874
 [..]
 nfacct_mt_checkentry+0xd2/0xe0 net/netfilter/xt_nfacct.c:41
 xt_check_match+0x3d1/0xab0 net/netfilter/x_tables.c:523

nfnl_acct_find_get() handles non-null input, but the error
printk relied on its presence.

Reported-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4ff165b9251e4d295690
Tested-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Fixes: ceb98d03eac5 ("netfilter: xtables: add nfacct match to support extended accounting")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_nfacct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index a97c2259bbc8..dd72f6fc57aa 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -38,8 +38,8 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 
 	nfacct = nfnl_acct_find_get(par->net, info->name);
 	if (nfacct == NULL) {
-		pr_info_ratelimited("accounting object `%s' does not exists\n",
-				    info->name);
+		pr_info_ratelimited("accounting object `%.*s' does not exist\n",
+				    NFACCT_NAME_MAX, info->name);
 		return -ENOENT;
 	}
 	info->nfacct = nfacct;
-- 
2.39.5



