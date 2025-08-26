Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6413526B747;
	Tue, 26 Aug 2025 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215860; cv=none; b=jKPEYnT36dWrYjKh2njSNNdmrcRwMcSjqU2dB1WhVszhqoeFkMMLGKNZbhhAOx5EfwYNOxI/HafyTtUz4stV867iRzOE5rayYafQihrcKqKrbu8HD2zMedwgn1rucL26O1YklwLvxxc21F7fi5obz2dFr5nzGPLNaF4ZfVeSuU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215860; c=relaxed/simple;
	bh=mkrg6r/j2XawwhfTvqAFeU5g0V0/BMVIlUDK9it6pJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzkOPPLvQTcGNVjjUFqZZb5j/yImvavY0Gi0I8eME+Vkbc7PzgvDrgDBJqu6NuP3E9rSBU4ryut/oekCmkGlCaVx5uALObOluRRrsHmcIEmZWtompaf/pnNuNJb7xu4W5RPCgFc5XBM7s7oJ5ayCF4Bu1gP7n1AXQvm73r6Qv8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AA4Wc+BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AA4Wc+BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF7DC4CEF1;
	Tue, 26 Aug 2025 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215860;
	bh=mkrg6r/j2XawwhfTvqAFeU5g0V0/BMVIlUDK9it6pJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AA4Wc+BOaD4vc2ucA3Z9dC2/LI25h+druVIzttaGlWGt0MXdn+MDON/QS8vkkTNas
	 U7/RtUiCMvfKwnABZuep32x+WyqGSMJqNvMS6yFbIJQv/D3W/H3OGS8J+vWsZgFHqU
	 llRPSspjXgRyw81TqFJiG7wxvAKans2qX7Vug8kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/644] netfilter: xt_nfacct: dont assume acct name is null-terminated
Date: Tue, 26 Aug 2025 13:04:13 +0200
Message-ID: <20250826110950.492207757@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7c6bf1c16813..0ca1cdfc4095 100644
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



