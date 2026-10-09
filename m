Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B637D45D901;
	Fri,  9 Oct 2026 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555554; cv=none; b=FRbyM7cYFrHRP3uCtS0I+qI9soaf/55LHVcZbw/VG5hNXa2AgnF+kStk1u/1JX9KJuVSHckOQ5HqEYj5V86DF5JswodvSq/ylvppysH4ckZmHdevJuWXtuwjraM3Hl7CNO7Po0yPuJdye8IkgoGx0v0ePb5wUhotcYkGoNGe48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555554; c=relaxed/simple;
	bh=5bvXoA8eyvZ6e9mmXfZEc59WdZH9ItTUd6H03EjKpQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYLnec4icBsmWceULociywuPs9YdClnjTTdfletHCO6RYbr5jXmZrG9szWqMiKgIlO2PegYmEfmgs/n0Dno1QGzwVt+OnWjSvBGsSeTHnHeRDrsGp32Wpg76tz5ttXnYJP6UbrpZ29T0XOOc3hOkqtT1G+qH3XaN/6za8T6qauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC6woBJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC6woBJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB4A1F000FF;
	Fri,  9 Oct 2026 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555551;
	bh=5fWkIMlGDB6wyZ6n1dmmkRmrbECRVambLZMnDA0wsMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sC6woBJUQEquMzEXNm6qVnvzVhwbj8wjfxcAgzkwyw90wSb0OW+nMJvysyVQkc08B
	 wGHnQ1EOhKLybWedMfJPoQi/s+Bf5791pN2fcjVBMrQzLXgvAh3mKR5n7iESgIllJS
	 g9UprCsGe6t9h4kjsalCIzRiYqLyWpCqgVQSu5cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Julian Anastasov <ja@ssi.bg>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.2 027/428] ipvs: bound LBLCR and LBLC cache growth
Date: Fri,  9 Oct 2026 16:06:04 +0200
Message-ID: <20261009140946.670848049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 2a3c3de660f96865f303fd25f1285f2ffbfd521d upstream.

ip_vs_lblcr_new() and ip_vs_lblc_new() create cache entries for
every previously unseen destination address. The table max_size only
tells the periodic collector to reclaim entries after the cache has
already exceeded the limit. It does not reclaim entries that the
attacker continues to use.

Reject new cache entries once either table reaches max_size * 3 / 2.
The extra headroom lets the periodic collector catch up while the
existing scheduler fallback continues to use the selected destination
when cache creation fails. New traffic therefore stays serviceable
without growing the tables further.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c  |    3 +++
 net/netfilter/ipvs/ip_vs_lblcr.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -204,6 +204,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *
 			return en;
 		ip_vs_lblc_del(en);
 	}
+	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+		return NULL;
+
 	en = kmalloc_obj(*en, GFP_ATOMIC);
 	if (!en)
 		return NULL;
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -363,6 +363,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table
 
 	en = ip_vs_lblcr_get(af, tbl, daddr);
 	if (!en) {
+		if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+			return NULL;
+
 		en = kmalloc_obj(*en, GFP_ATOMIC);
 		if (!en)
 			return NULL;


