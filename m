Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F00D4E1CC;
	Tue, 23 Jan 2024 01:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974728; cv=none; b=pkKjKCRtnzRWmQCQUSYnwaTSfkEGop1ETDaaRD5XNjWXJVvjmy7fS2PagJiwJVFL5TXfSrzucSZsaK/pxxNujlrtaKPCAHIOjmLJ5VZN6q8KjzQEoF4nNinB7Mvb5o/nrJpbDAhZtnRgI52vSGOqG3U75VNpuy0n1W6ix4YtNFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974728; c=relaxed/simple;
	bh=Ky5jjM0BezW6cZVGdc4i7VhbN2Rj5TwjsoFpr9cYoEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlNqqyryH5z51doFQiZlqtG1BEoptHuv1uRJtitwabtFyWto+D9i40AMnXxZopFBdTCnA9nDyyDOuePFT1QtSz6oF5O5WRpVDYAvZ3NPAEsmAKBgXdwLLe0qxmO87e+wUcPUAv40Vn1PgiQXsfCoziBbqRbETIZsxbrghYVWDBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9aup4Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9aup4Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157DFC433F1;
	Tue, 23 Jan 2024 01:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974728;
	bh=Ky5jjM0BezW6cZVGdc4i7VhbN2Rj5TwjsoFpr9cYoEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9aup4Z/X3eE0+RjLUi5Hv8gDWZiXaTCKGD3YqcCSyMB4wFISv3WzsXpsiVidyQuv
	 vtiD9WEYOsIpx6IXaXPuluLWPDa1UeRwfEzTYZ5Tr88k+EhBTFrLSQ5++R4VjMFT3S
	 TDJwULEvoW5sIOQVDgY8oCShpSTGT9gNBEeKMUWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 270/374] netfilter: nf_tables: check if catch-all set element is active in next generation
Date: Mon, 22 Jan 2024 15:58:46 -0800
Message-ID: <20240122235754.163956903@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
@@ -6034,7 +6034,7 @@ static int nft_setelem_catchall_deactiva
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active(net, ext))
+		if (!nft_is_active_next(net, ext))
 			continue;
 
 		kfree(elem->priv);


