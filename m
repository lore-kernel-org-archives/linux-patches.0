Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9241D95AB;
	Tue, 15 Oct 2024 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992539; cv=none; b=iI9sp7xBvwDzVw/iyll6V/6+3SJcdQ9fIW5t8X3obR5ZqArckV2PwFFhQA6JtB++XyHgrLbYceSG9KDJN32w/cdr3XuT+VDevg9LwGxZHW1uJRHIi2S/+HLToS+Qedg8vPuTnqquvF47f4++7s69gjTQll/KOXhJma6bk2l2/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992539; c=relaxed/simple;
	bh=VhV8gp4usdxEXHanQATIJrMzTXm96J6V3szuFcauNdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmjJRCkHqyMwfb/uW+Hw1FNtNb/1m+IWwlaKzsNAQrD+6klBscirff/Pws4KMEM0v3pUBQokQfEoM5mPun+hWCqsZD5T88Jvh2EcliRKi6c7/i5jGdRSHtNXQEQ2AUPl9V3vR+RGMIX8AY5wLKnsIQODZeSbV7HA63umNniFPzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDhIxHye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDhIxHye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FE1C4CEC6;
	Tue, 15 Oct 2024 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992538;
	bh=VhV8gp4usdxEXHanQATIJrMzTXm96J6V3szuFcauNdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDhIxHyeKhxrLi4Tx3nptWoiewo3EuQ2vQvzwAk+I6DNaECRAfoGceuVO9RHFGNgj
	 djIRmdIld/+kH4Hg2NRsqAG2iN7rHSbfwHIBoN9gQrvsU6MlkMWQb7gEiB5Fb5dMGw
	 j9WuXmGMfe2xVuNAyyjs4uEEAjSW/LX96yUxet7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/691] netfilter: nf_tables: remove annotation to access set timeout while holding lock
Date: Tue, 15 Oct 2024 13:21:02 +0200
Message-ID: <20241015112444.884824567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dff7e507d03a5..f493f4351ca52 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6288,7 +6288,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = READ_ONCE(set->timeout);
+		timeout = set->timeout;
 	}
 
 	expiration = 0;
@@ -6395,7 +6395,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
+		if (timeout != set->timeout) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
-- 
2.43.0



