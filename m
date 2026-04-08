Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6923D9DB1;
	Wed,  8 Apr 2026 18:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672595; cv=none; b=OsCm1CkBQJt+TTZOP3Su2WuYJmTekDACIODejJixqsWR1TFRRy+JNz5ZVz3ZnGRX4rVWOAq7KbKVJKLgrz5NuirVDHr4plNHTwOLSKoqAybT6rjOsCRzcx77xUWX5udzIkeKXdKtypFMR0awGvfW/AMnLBkGC4kAY8TjgN01N9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672595; c=relaxed/simple;
	bh=Sz8NP7jGYCX90GUdQJPnXHu7iTWMiUreEZhOD9q8BOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbFAeJORXwaIEo31AG5FgKH7D9+BuHUFYPpJqZ1ibC2U4S139EPINh2QIdmuXw7fqLYOSvSexiJ7vgQIN+lPZu2JukuuvaVZWiUCpgxWcLfj158fKY+ZUz4G5Fh2Vo1fhusuS1BzMXqAO7mLYI52SmtgROIG31yW6awIyT/ZzRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKcPUe+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKcPUe+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7623C19421;
	Wed,  8 Apr 2026 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672595;
	bh=Sz8NP7jGYCX90GUdQJPnXHu7iTWMiUreEZhOD9q8BOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKcPUe+GhDyzv3zN9i5cu5qimMBrD6l7VMRaK+uYqmAjY1dSSDH/rb/zMP+dl2ocK
	 NslOKmJgzWaPyHkQ78Ih+CG9vYmm3ibgLYt/aRXSIRCmcbMzCJn7OstAo8DUPm5NfR
	 MNwWmeCgOyrs7BWMLEyEyKtNDQB6Z8qUweDe68Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/160] netfilter: nfnetlink_log: account for netlink header size
Date: Wed,  8 Apr 2026 20:02:02 +0200
Message-ID: <20260408175914.521061474@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6d52a4a0520a6696bdde51caa11f2d6821cd0c01 ]

This is a followup to an old bug fix: NLMSG_DONE needs to account
for the netlink header size, not just the attribute size.

This can result in a WARN splat + drop of the netlink message,
but other than this there are no ill effects.

Fixes: 9dfa1dfe4d5e ("netfilter: nf_log: account for size of NLMSG_DONE attribute")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index aa5fc9bffef0c..f96421ad14afb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -726,7 +726,7 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
-		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
+		+ nlmsg_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size += nla_total_size(skb->dev->hard_header_len)
-- 
2.53.0



