Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F244582D0;
	Tue, 21 Jul 2026 21:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671081; cv=none; b=S3tqhx4frK+MD5iN7d1C5R3guySHusB0XleeKCc5Ygw5Xy+nDjtsSgm5wRkf3hUQe5i0gY+vwU4RLTyhdx+t2Gs4zx6Qa2OndRjleeFGocbH7jn0Pnmxy88gaflS9+134FDYA1D7gFmsbnZWjLHnMVAhdvf6ptOtq8vkouLtg5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671081; c=relaxed/simple;
	bh=K2jJu1SZ07l9Opp2FwwFmF8/+t+mbuDEOk9KjlMknkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9kwbqWtxrXZKV8+gDABTLH368iXIAGfOjtM4WSnnYe0cCFcJdyZPHM+qxEmEqSkLeACUdf+OVmMob6vvbyQ02CgztxxRSic+nCu72zj0NkXNzTlsYgWh5XFPZKn5k+ratkT088MwgG13GCwjY6msOFm0wUdTHC3E+Ibi6Hdo4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EERi+lh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EERi+lh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1486B1F000E9;
	Tue, 21 Jul 2026 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671079;
	bh=7aQVKAZ4LoE5MgtRMm503QF9B+Y5GXSmhxQNfLNmEUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EERi+lh68UZOBGLD3GF2ZZXXIKE4e4v7s09EI+b2CQpIuhyidPNL5ErGUUG9BLBHD
	 /gfq98wYFaFMMA+zSW9DJQ6xiJ9KYmU401IYBBPbUjj2kmv+2Wv90x2OelMqk1BJL9
	 8yCSLxOaeEarUb5K83noNOvl3h9Jx6U4Rpnzpnsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 110/843] netfilter: ebtables: module names must be null-terminated
Date: Tue, 21 Jul 2026 17:15:45 +0200
Message-ID: <20260721152408.475869419@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 084d23f818321390509e9738a0b08bbf46df6425 upstream.

We need to explicitly check the length, else we may pass non-null
terminated string to request_module().

Cc: stable@vger.kernel.org
Fixes: bcf493428840 ("netfilter: ebtables: Fix extension lookup with identical name")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -402,6 +402,9 @@ ebt_check_match(struct ebt_entry_match *
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
+	if (strnlen(m->u.name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return -EINVAL;
+
 	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
 		if (!IS_ERR(match))


