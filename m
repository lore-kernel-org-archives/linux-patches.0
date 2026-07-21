Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859E83FAE11;
	Tue, 21 Jul 2026 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659901; cv=none; b=uhLhKHTnWlI5O7G9NnOHwRTGQx01ArNKbfLNRVwjyEEGOFe0AD6Po/n/lVkGEINNaeDzL9F7oAx/OymH8pBNsJdtOw7YESyRR5A+n1SV4WEk8UJfk8C+rdDTV9Zn5+i4BKYnL7+QycuBDgL/ctLf/yx3SDHfxsVaiRhKStjr8Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659901; c=relaxed/simple;
	bh=iI3vl8521+bY4yADloci3z8NoQuVvxaneh8U761Zf70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNgOxhfziimK8F6iD7XPMZUbCLgv1BXaBSnAy8xgFlLbqjniV4kCjGgljLNuttcZsfoO3z5P00c7CWeXY03N9d4vVqT7LZq12LrNvP9n2xVrjS1HoBJVBRx460UTntODCRXtfmgIK+e/Nkt0/gpj9+pVdBHGrdG0SFLIIWOQQCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKqnPgxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKqnPgxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD65A1F000E9;
	Tue, 21 Jul 2026 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659900;
	bh=5sAy7HU1Ok0QxSVthFCzMMW4WqdWfXF7WHhTgk88kD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKqnPgxfkrs5sOysPOnxzSkFEL1dHWE+Bq2J08CUtJTFaoLapgFQdivNx4coYJRAr
	 YoShjf8GPpmEf+zCLt9LBMaHGEh++APRwCwA2GG5kjDDhk0kNsAf/4GqF6d1lr+bgV
	 kxEvIOiZIKYVJOtfXrJbLwmwt3LEY9AkyOuPZCzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0774/2077] geneve: Fix off-by-one comparing with GRO_LEGACY_MAX_SIZE
Date: Tue, 21 Jul 2026 17:07:27 +0200
Message-ID: <20260721152611.050752705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 2319688890d97c63da423a3c57c23b4ab5952dfc ]

GRO_LEGACY_MAX_SIZE = 65536; total_len being 65536 is too big to fit
into a u16. As can be seen in skb_gro_receive, packets bigger or equal
to gro_max_size (or GRO_LEGACY_MAX_SIZE) are dropped with -E2BIG. Apply
the same boundary to geneve_post_decap_hint to avoid writing 65536 to a
16-bit iph->tot_len field with an overflow.

Fixes: fd0dd796576e ("geneve: use GRO hint option in the RX path")
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260611192955.604661-3-alice.kernel@fastmail.im
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 715180c3a1b34e..b2e74e815e5778 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -603,7 +603,7 @@ static int geneve_post_decap_hint(const struct sock *sk, struct sk_buff *skb,
 	ipv6h = (void *)skb->data + gro_hint->nested_nh_offset;
 	iph = (struct iphdr *)ipv6h;
 	total_len = skb->len - gro_hint->nested_nh_offset;
-	if (total_len > GRO_LEGACY_MAX_SIZE)
+	if (total_len >= GRO_LEGACY_MAX_SIZE)
 		return -E2BIG;
 
 	/*
-- 
2.53.0



