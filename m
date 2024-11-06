Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30DD1E00B1;
	Wed,  6 Nov 2024 12:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897853; cv=none; b=fY4+GfgMvAmnzkqtbzKiuuA/RyN41f8V5z4rukhVzq2lCq2uHxyHzvSl06IOWz2ss+eQpVBoDCoTNsVMSnlDlwooIvwsdsXfvju/jVsQul1xCh4cVARdK7EURJ0Vwwpnr+WU7j3T85Aedp3cLm5ItN3L/fJZ2HZM52QviPp3mAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897853; c=relaxed/simple;
	bh=XmHss6lVGYQ7FYzvOeIpbwybS53hONaEnWSBhZOCLps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ht3aU3oUW9mkQqo/e4smaHiUCxLEKbSgMfMwnNQY5Mk6fcp6OlEXke7go9NGzybyE/kGDKohU2djhVTB0VNB7LbnQUPwdDs8BZmLqcVUoRUPAdkSTv3oL5kY2lvT4SdB5PBbDPAAGFqGFo1hrOC85fnP9XD4sX7MoogrJUAv9Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Neg8fDTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Neg8fDTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D00C4CECD;
	Wed,  6 Nov 2024 12:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897853;
	bh=XmHss6lVGYQ7FYzvOeIpbwybS53hONaEnWSBhZOCLps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Neg8fDTOR5UkC8r4YsLrxoAZOM501Bwp9rqxPY3YlGPupQyGwM1PwcZSuH/Z5vHSX
	 FOnrq+MxNqW3lkgeE5iDvCE4gQnaL+YXD7TfJ4Parr+Q2D9hzTVN5t2c2P1N1Pif8E
	 IWSuu0sc97Kr/UrH+p+fq0JyHieztKp3J5VDBmd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/462] netfilter: nf_tables: reject expiration higher than timeout
Date: Wed,  6 Nov 2024 12:58:55 +0100
Message-ID: <20241106120332.559290430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c0f38a8c60174368aed1d0f9965d733195f15033 ]

Report ERANGE to userspace if user specifies an expiration larger than
the timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3c4cc2e58bf83..7812cc3cc751b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4894,6 +4894,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &expiration);
 		if (err)
 			return err;
+
+		if (expiration > timeout)
+			return -ERANGE;
 	}
 
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-- 
2.43.0



