Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ACA2DA76C;
	Tue, 21 Jul 2026 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665080; cv=none; b=GFmbCISRGQxeNsCfc7BJSt99z6OCymvdmbuekYdqmuhTqw966i0LP4gc2EVaz2liTJzcSnQ8yBswJmAJekSiA7yCwZC6E20fQqdii22s/Z97ODZ0Fij39JBCJbBGzMtxvrDMv1PGQMCcrqthU5LffVylzj+NWg1PhFTKfFbn0ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665080; c=relaxed/simple;
	bh=BNABnEcSTw/W7EtJLxalu5532Rf79NtEzlmwPf9ka8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+ombrAsjO/gExa3lgP28vsscfr0lrv72xL2rjkwlbYz1QCLUhteKO6o6XA3Mgo6M72k2ItGxykKAO/y9ULGkW4K/htnFZbSpN6tgWJSsP4PHcTVRuLqmtM9OBAJkm6z0BSXiKZ0Dkkd6HcKHSXqT1JRa2l4O5kzHTmtOtjXsZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MhSnfLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MhSnfLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B01F000E9;
	Tue, 21 Jul 2026 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665079;
	bh=ERPc1EUF5RPek67q7nl1GqFagwssPl6yYAUWdR9jAb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MhSnfLjaekV0DecBvVJV69ceLbGHnwtlWXE9qYfl6bJ/O1XoHwkEoySoIkYdXeMF
	 IktJuXQ8XSeuh1NHSNqyhjku3xJAxWsfimyJU71ygoKjnx915jufnUPthGkSBD57Ef
	 QDGrlXERcIxIFUyu+AwnCJe6SqJHmBK10IfCNdJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6 0168/1266] netfilter: ebtables: module names must be null-terminated
Date: Tue, 21 Jul 2026 17:10:05 +0200
Message-ID: <20260721152445.565030944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


