Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3A4E1D5;
	Tue, 23 Jan 2024 00:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969779; cv=none; b=n3zagJrq0E1XvoHdq7qvnqIC0XkSI1PDRpGrSRkNabOxnUd3JGYBSoK9yWYy/aWrKuHlMuwwITj3PuCWoFP3Mwk2mhOyKtZleQ+kwYw+x2Wzwms3O7xJfofjRhfzT3v+HWjb41BICnZZmYJceqqKLEUh4KDv8V7P/R3sjBnU7eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969779; c=relaxed/simple;
	bh=L10JW2MnL3F7lL75ZHTM9ArefxfiuZV9iH+SY36MUmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0aUzgEhWTG618qX2nY2k7uOi9AmvsWEI8Shm8TMJ4fWxTPLN4y1q1BPlEvAo4+PgjcQ7bh06OMztiS461sl0j6SXv/cB3KOrwy1nkZcNGWAuaFFvFqLGwtYooCextR3h+P7qYUwcIVPpxslSwOqcIt5FFRObCcDfI0z7kboaLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm2P/sRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm2P/sRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236DC433C7;
	Tue, 23 Jan 2024 00:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969779;
	bh=L10JW2MnL3F7lL75ZHTM9ArefxfiuZV9iH+SY36MUmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm2P/sRVEquKhO+nj5NCumOnEarDfT7JnBYt8qrmc5ja1DT5k+RKiajRVI+FyHjaa
	 GnY021Ie5boQCNMMeKQvl8C/oLolx3PlODvAfluPMzpsr8yGBN4L7E7+RDS+YKVx02
	 OZdt+O5cEb62vNsCVr0MC3tg/nxyLXguO8ZTD87U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.7 444/641] netfilter: nf_tables: check if catch-all set element is active in next generation
Date: Mon, 22 Jan 2024 15:55:48 -0800
Message-ID: <20240122235831.916874964@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6487,7 +6487,7 @@ static int nft_setelem_catchall_deactiva
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active(net, ext))
+		if (!nft_is_active_next(net, ext))
 			continue;
 
 		kfree(elem->priv);


