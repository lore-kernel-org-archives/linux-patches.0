Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F20666B52;
	Tue, 23 Jan 2024 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971683; cv=none; b=sE3Pjr7XOKvTpcM2P21pLv+votFswi7VyYh5O5uw9qCmtAeRmH/L8E6Fy3+p/4C3/gMJqmfEU80J6jCdx2UY5ZrVtgUpesvR0Oqpo5fX/0HeIlrhghAkC9IAsfLH+E4HZE0OyiQXtpmKYTofEeb6NfGPffVAV2NGobhER0b2yl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971683; c=relaxed/simple;
	bh=pKqEQB3Q8Nb3ClSoVtsnQ0jW8PWxmou6vzaxWC3S07g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXyd3MD7dxoZGSb408mK6WuQ7qYoZxNfK2vVpMPEspU0D5eKR0+rCBS1GII54J7wslYZ46Pdjb/LLk22Cqki9QnWo9O6vGhjyGsrmKF72CaC5Pc7/skfOyLJs7c1HwOVJIoGm7/5PwdGBQ9yFv9n+3sth9DsbsEcWJYRcHVXBVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+/krGzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+/krGzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B19C433F1;
	Tue, 23 Jan 2024 01:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971683;
	bh=pKqEQB3Q8Nb3ClSoVtsnQ0jW8PWxmou6vzaxWC3S07g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+/krGzbXyjqx3UQwwjNqNXqu3sfIQ+Trw1GkWRm2FEX+mUMQEmhmScKle3U+gz5m
	 585GSI6yhUyAU/iFpi+2YGpC5EO/LvUcXK3LmWsNhXNirKxY8Zt47dfr8WNPqhF9rh
	 fW73ZIhTbLa+2tZ3Lt1WR70/y29v0NsVVtia5BvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 297/417] netfilter: nf_tables: check if catch-all set element is active in next generation
Date: Mon, 22 Jan 2024 15:57:45 -0800
Message-ID: <20240122235802.116414638@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit b1db244ffd041a49ecc9618e8feb6b5c1afcdaa7 upstream.

When deactivating the catch-all set element, check the state in the next
generation that represents this transaction.

This bug uncovered after the recent removal of the element busy mark
a2dd0233cbc4 ("netfilter: nf_tables: remove busy mark and gc batch API").

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6152,7 +6152,7 @@ static int nft_setelem_catchall_deactiva
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active(net, ext))
+		if (!nft_is_active_next(net, ext))
 			continue;
 
 		kfree(elem->priv);


