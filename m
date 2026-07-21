Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30491438FEE;
	Tue, 21 Jul 2026 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668315; cv=none; b=h0Ic0p6uLANVxKD02MoUsXIRC9C/9XY8i7HMjle2UJnXbv2CFhJcC2ZIdHqFIBcygt1WDMLvjNJ8/dqIKf6fOYaBrWiiV9GYl6mGilWB1pU2yt8+KG4Wh1m6Ja41dONF0xVkJSOCbxCtsUk3KvIvOQhUQ9LWaQJj+My4JtVMjyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668315; c=relaxed/simple;
	bh=KKzaqFvVtlRPgrVioM2h8XWXPvJHzr5AvuHuynZ/thg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8Vu2QX2ZnNsUczrnkmJ41oxhDJsnVPYQUeokiisQ5dEF/hGDoGKcm/Wna04BtMKEizFd2KSsvcAdeQE4ntGFtH4SPbD2ee+DSokHm5DFQ3Hxz8q5K2e1QQs5GW3xLv4W31Luu4kuyjOp68tBoMIYXs/AOjnhHkIXzIfotf7mEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjTeS2oi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjTeS2oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911451F000E9;
	Tue, 21 Jul 2026 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668314;
	bh=kknZrDGk/2xvwrQpm6I7Y4TkToUq2y1mm+/Ny+kcbGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjTeS2oiPvZEQwVYP9u4zX/HLCMzF6SGLN5cVs4ygtV/998rcTKhd5F2eQLY3e793
	 CZ7ncztZZe9/OiO6GpZvW14h0RzRHAIcQSZ5NBxPqieRrGOHeyWPPij5B+G8mPj/f0
	 PnUegDgdoZG7uOMQg11pJObBsJcqsQZwOgyk25pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 0128/1067] netfilter: ebtables: module names must be null-terminated
Date: Tue, 21 Jul 2026 17:12:09 +0200
Message-ID: <20260721152427.456232739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


