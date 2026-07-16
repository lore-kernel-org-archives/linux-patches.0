Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6913FD12D;
	Thu, 16 Jul 2026 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209480; cv=none; b=VllJOwTThxkcqKEh003M5zn1X6Y8Nu12C8mUcrbu7BT0U1QcLRKdZFfqeTO2iP1EXksyNYc8aQMiA69yAWYvw4rOlX/PzF8NsSgjHwftZ5/JsKB9sBU+SWHb+gdxGMj1jTkP5kMytURKCFrwojX1KXe/cGYYlsSeXLKCTT27wkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209480; c=relaxed/simple;
	bh=sJSe85Wr1SwlWlYd5I5w1nN4pCtO0Dy8lqjE/X1H+T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEFW471hFF30gOGXVjRNzpbRXe7EEAbc+iIRlThDcBWjbiZcjLJ3VGk2FzuJPpDbMltWK73goQKEjvdfhrhuM+BIwA/DTcCHyc6W1vCBkT1G+Oc0I0fYA3OiXNpoRhA+tZyXexstNXK+bqneivC8Ev41+ODfePsVYalz7uB7wbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8e1RKuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8e1RKuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB261F00A3D;
	Thu, 16 Jul 2026 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209479;
	bh=jQIZmpK6W5VDU967R5b1JUnO7hp9fpiuovfjEFVPnng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8e1RKuMv4geT8geRLBbGul/UOK0EM3HGuZNX2+cqR907ZqdOegU9UGmt6wsENeo+
	 yRMRJlYqjpwY041FNSK0YllUQl0+z2WYn55FWXi9Ow3TCz5VlbmtGeC+tJh8Hleo+K
	 hb0RSzBsM1PMnLXhSgHP688o8Rko39V56fTBN7RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 200/518] netfilter: ebtables: module names must be null-terminated
Date: Thu, 16 Jul 2026 15:27:48 +0200
Message-ID: <20260716133052.199508838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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


