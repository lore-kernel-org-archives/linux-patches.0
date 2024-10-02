Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E931D270A;
	Wed,  2 Oct 2024 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879195; cv=none; b=crzonO6zgWNSGps+B2e4kfAmrQvOzbwRVmlic3/IN2xQG6hkjtOgFitP2X83TsCnGMNTa1MNPjkB2D2BEZaxz1u2a85f3PCrvIDDz0656AyrJie/4saFFgIQeywgU8DclOUmqcMqmsc+4lIByGsQmiz1THOMPej5GUXwt0t4sNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879195; c=relaxed/simple;
	bh=stnrL/Uv/cDj1VNoj82MUi5aPpPyFDynw7x3G2XleyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQ6wgXsNstGNj0Ov0rISDptMjNVSrm38BIknhlYunUhYxe8ZbY5ZBWJxCDq5NKuxxmW3aEcW3I1s9+JcfJuWSb8Byt/SEIX41j3S1rftvsj6Ymgltf7AC0RIhwispq41FV4EyZx/29uBlHxkgdojkQVikOqzhI8dlbPeB7bJfgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHLEwkmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHLEwkmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0C7C4CEC2;
	Wed,  2 Oct 2024 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879194;
	bh=stnrL/Uv/cDj1VNoj82MUi5aPpPyFDynw7x3G2XleyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHLEwkmArP3lbzPhkFe8rpxpIh9wwKHsrrXJm0SND/n//MCCWEUnXs06fOqiu88tq
	 83Yrmg21bmNp5poYAYOKIvhUhOBmPat0hnMwP2AkIlOpnFXkRAkAMsG8WFD+gyAvbc
	 qVBGritJWRifkGO3g8EMdrKoxxicYdKuqfciHM9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/538] netfilter: nf_tables: remove annotation to access set timeout while holding lock
Date: Wed,  2 Oct 2024 14:54:35 +0200
Message-ID: <20241002125753.451930511@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 15d8605c0cf4fc9cf4386cae658c68a0fd4bdb92 ]

Mutex is held when adding an element, no need for READ_ONCE, remove it.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 842c9ac6e2341..6b6c16c5fc9ae 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6691,7 +6691,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = READ_ONCE(set->timeout);
+		timeout = set->timeout;
 	}
 
 	expiration = 0;
@@ -6798,7 +6798,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
+		if (timeout != set->timeout) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
-- 
2.43.0



