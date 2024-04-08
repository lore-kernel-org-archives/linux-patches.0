Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF13C80604;
	Mon,  8 Apr 2024 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582614; cv=none; b=bj2pL62LGoQxV2PAu1IuRgkq4H8Cluv6ouSnB3QD9euJGjEhlDb/O7B6p7vyCrvZ7NJQmDSAvXbIQSkBAKGxWSXX//WBA3iwOerWahwRLAh1N/3cynLIw84a95VooAgZLGsQdDFL7Q+6JzDabGX8AuLhTDVEgQXAoDUaxX4gAPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582614; c=relaxed/simple;
	bh=dOLHdskRVFsMZX4d5rOUvDTF5wqJi9U/NyRskaSRBtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7luIZnW6mi7RkEaZCNbyuqoACrhFgCCNQF9t9jToh7MUEG+NV5sstXJMSF2BppR6RTkK826BiHi/TwQL9Y3whPqK/MUh12JFa80PPlv+pJGUeHTBIUAdDQmeIVeOn6+lEeRC9VtFOVNQ2AsNfzN1WWOc7M+FtEzlDtMPUx/gzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARJn6NDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARJn6NDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440A2C433C7;
	Mon,  8 Apr 2024 13:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582614;
	bh=dOLHdskRVFsMZX4d5rOUvDTF5wqJi9U/NyRskaSRBtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARJn6NDaOIq99kn2gmREw8S92kMJnt3U9x22BeCrHSbXDbYmxNAJRXqLb/Lp3+S/P
	 OT0D8b4aib+zX7FerxR0GdRLQiV4pAXsZwin2T97V8f5ZV/rYr8GRDdH7P5jmzbsPj
	 v3yH0O8iwLjwtlkbtdcKKy5QN0p5GNMEYuT+qBM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.8 090/273] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Mon,  8 Apr 2024 14:56:05 +0200
Message-ID: <20240408125312.098046187@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1207,10 +1207,11 @@ static bool nft_table_pending_update(con
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
 


