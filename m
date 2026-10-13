Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4622C11E4;
	Tue, 13 Oct 2026 12:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894899; cv=none; b=kKYiveNdy6I/zpn1Jb//0Rv/usTUzd4Pjf2RIe4bUpyRZ6jXe64bJt2s9nXsOle+yliStdx5QlJyjj4MAYzNZWiw9jQdZnlCHPzr6IrINH59Mp9hmfNT2U2DEhjsQFwvUjxaOpTfrxHXo1GHbOq69aW2UINuvJdJmt3k69+9ywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894899; c=relaxed/simple;
	bh=Gmf6eoEgIVmqPlveKNV5FBdsigdotC9JOBnoqEXy9tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxQIvrEvWAxsfPRF4Gl2NUQ8Sv1bq5oMERakrH9NVb0Uzr7KHZbrFxE+zzE1RNU85oV4uoK3vJSRjcIktEHGkKWIRU49Ht/cgdmAQFdId9Tpqfu0VsUvZxN57K46NbHG2450J70GQat0H5L4gq4QxggYiOT7nDcKeItCwpa84yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ay+3376X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ay+3376X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6261F000FF;
	Tue, 13 Oct 2026 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894898;
	bh=OxjJ+8F0ofWHFscaagt1vH+1XC+ik1SQSTiahD35KeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ay+3376XrnEAWnzwWsHICJPENYWpkfC3T/xJDKCwlu9eHbPCZ4iJbd8Jl5iggds5V
	 RsC3NrIDbeuCvuigPtDgmIkzj/nhoEjC9WoIy2pIR0Gyd2+xLO0H5AsEYKO7a7oZIH
	 XnuqgI1ApNWHCcAGfNBEDhnRXYIOcBg3fxRtd6Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/497] ipvs: fix missing counter decrement in lblc
Date: Tue, 13 Oct 2026 13:34:22 +0200
Message-ID: <20261013112910.145502796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit bdac17779f46817f60103baf09f0370546c3f023 ]

LBLC may delete cache entries for destinations that are
removed or overloaded and replace them with available ones.
But ip_vs_lblc_new() forgets to decrement the tbl->entries
counter after calling ip_vs_lblc_del(). This can lead to
increased shrinking of the cache with every new garbage
collection.

Fixes: 2f3d771a35fe ("ipvs: do not use dest after ip_vs_dest_put in LBLC")
Link: https://sashiko.dev/#/patchset/0bdd5abe9968ded7ca2b9cb6844ba83d94cc8d53.1787318053.git.zhilinz%40nebusec.ai
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index d22f8154ff949..b8bab41ee6ff5 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -204,6 +204,7 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		if (en->dest == dest)
 			return en;
 		ip_vs_lblc_del(en);
+		atomic_dec(&tbl->entries);
 	}
 	en = kmalloc(sizeof(*en), GFP_ATOMIC);
 	if (!en)
-- 
2.53.0



