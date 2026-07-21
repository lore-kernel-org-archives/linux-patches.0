Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D73B8120;
	Tue, 21 Jul 2026 22:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673241; cv=none; b=nVBvLFUv5e5neUOlffHP5hkOXhGQGtRmCsFtrs87qy278OtCWsubBUIeoKUZEQRuVbpal565JWwErFQz2jAFuME9IpAJfNiSeu0KliVsd6GFCM9QhXte1YJAhUJGIuXbHKA08uirIqdS6by3xpYrINEYzrAiDKbrnplwda0XL2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673241; c=relaxed/simple;
	bh=Wcn9xIDQVIku2wi9qNDK1mGuvvF95LvHHoUrLxDKGf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEpEaeA5HaA3CvWjDBALDp6hbtRI2qqmKEw7MWgFXe4ThuLP0KOjt/x+TRYd/6vy9Ej18tbYRQVhwo2I47EPxMlpSsJwV4ewb5myIt/WOAzXw7N6pJdkxIQsCGPba/rpX8reb3nZEQ9uf0NnKLWKNwafws+n5UFULg2eJ5slHoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6MEM1Wy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6MEM1Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0CB1F000E9;
	Tue, 21 Jul 2026 22:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673240;
	bh=P8l2YikIaIcFNcQwhn37wA5LOacyTUH4IPLR5/ZK2Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6MEM1WyXzl+FHQeRJ+Rp8t7eThC4aDoDm9wOw9ORVvF3c6f2c9vg10SQyNeR4Rhg
	 zn44RjUF0pKQSNYYTmM2SbWOIgm3SCzo87ddXbmbBZkJaJhnOp6II5wSybUXwVvFFx
	 KwsNSe8QVHqzC8GwmHpGW+5hiF+MuU0/Al805pCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 081/699] netfilter: ebtables: module names must be null-terminated
Date: Tue, 21 Jul 2026 17:17:20 +0200
Message-ID: <20260721152357.532933193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -363,6 +363,9 @@ ebt_check_match(struct ebt_entry_match *
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
+	if (strnlen(m->u.name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return -EINVAL;
+
 	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
 		if (!IS_ERR(match))


