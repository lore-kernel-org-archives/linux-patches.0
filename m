Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0927CF26;
	Mon,  8 Apr 2024 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582492; cv=none; b=AGrCcFgO7E4i5vUGzbo7y1wkbsEwLd7hmWo1kyUBSmzSrMoiGfD+qaDFKDU4gZmgFFADuRSh8QqIdzE9Q5CMdIR0YcUXty/95m5jEKgYJlSlDFLeVinMlN3stRnLFA3WXJW+/2fdtIvZenUfGjWVgWTVj+FPsGpWRqywTE4s8Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582492; c=relaxed/simple;
	bh=VoUcRW5e8govJwMJ+r3qND7M5AkVNZu6uxruMHGWPZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWpXCuFDaIZHluiCij5sM8o57OlFf5wNaeJpR9ZDw7jWYybyi2bwkzO0OO+lpnw5w73A1nUHmH8Yt3nkJVUFjkTxd5sWSN489m4FbxacRVSVsBY6MYnVLRceESyuB9ABd4muf8PLtR7qVWhcOZk14DZ7lYTg+UkchgagneOxb6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+MJJ+j0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+MJJ+j0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7CBC433C7;
	Mon,  8 Apr 2024 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582492;
	bh=VoUcRW5e8govJwMJ+r3qND7M5AkVNZu6uxruMHGWPZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+MJJ+j0m7EH/9Zgj09YrTFwfNHl4O5nWlIcFz4avv0bE9Np1vnPad71P/8kwNZIE
	 9c0W50YsPesVgRH8Nk4YeOKIcLnreqJyYcVQddQKl2uvamNSYHpVt86+9ZWqEFanZS
	 UkSoITXN5EmXH8GJSOP0WUOxZfcyfIyDUTVhI6fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 097/252] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Mon,  8 Apr 2024 14:56:36 +0200
Message-ID: <20240408125309.662649475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

commit 1bc83a019bbe268be3526406245ec28c2458a518 upstream.

Hook unregistration is deferred to the commit phase, same occurs with
hook updates triggered by the table dormant flag. When both commands are
combined, this results in deleting a basechain while leaving its hook
still registered in the core.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1209,10 +1209,11 @@ static bool nft_table_pending_update(con
 		return true;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		if ((trans->msg_type == NFT_MSG_NEWCHAIN ||
-		     trans->msg_type == NFT_MSG_DELCHAIN) &&
-		    trans->ctx.table == ctx->table &&
-		    nft_trans_chain_update(trans))
+		if (trans->ctx.table == ctx->table &&
+		    ((trans->msg_type == NFT_MSG_NEWCHAIN &&
+		      nft_trans_chain_update(trans)) ||
+		     (trans->msg_type == NFT_MSG_DELCHAIN &&
+		      nft_is_base_chain(trans->ctx.chain))))
 			return true;
 	}
 


