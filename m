Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D513D9535;
	Thu, 16 Jul 2026 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210829; cv=none; b=p7gwj6P7fOWZgx9ukcf/Uo4uGpodIP5M/cx84FaTsAkIzju3bNfkj4y7WkbZ8wmWMhvkzAyM+IkPKu1ZjqXdUAo2T0rtTQUf5ADYVg3qj00R3WZvtAqMEB2rYz5Sg8LbDjS0BcY9kuBt3FjOh21QWYhZyUYSbkoKNdSO3qv8v9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210829; c=relaxed/simple;
	bh=NUtNbJLDiWWM9p/2vLStGyhCn8gM362jkYvub0cUGdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7M1JMj+RVKuUddebb5dWym/SBRm1C0sbXONjsBjHnuJlG5jwmrxYWWnWqHkXkjLeJePl8CxmUM1UmUGuqMy5oE3TlzMKp8KiY9ASjvx1KUqws2tyBwAn14BekgQM+aUzSCQVCYSW9ornlJsPMbGBSWCPyXabJPL7wBhosl+6WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVrssOaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVrssOaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045631F000E9;
	Thu, 16 Jul 2026 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210828;
	bh=D2J1NyN5s8ffblmWwYxUT+JiSHgEbau2ngbT5gVW3kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVrssOaNJKiztarjhF1fUYQ756aIq7YJ8UGyt6kBvoImPQ+hXq8TIjptcSDG9yHAd
	 Yf0nvoCs1gM+Gq+hj/3CN/OpTeaf1ZG2Ks+wdfefcfyQKQa1pVJ1U04jhd9U07Cs2c
	 ZobFoTOVdoGTWuu+SmG7qaaMCWJC8UvnCSwF9jEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 197/480] netfilter: ebtables: module names must be null-terminated
Date: Thu, 16 Jul 2026 15:29:04 +0200
Message-ID: <20260716133048.989474668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,6 +403,9 @@ ebt_check_match(struct ebt_entry_match *
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
+	if (strnlen(m->u.name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return -EINVAL;
+
 	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
 		if (!IS_ERR(match))


