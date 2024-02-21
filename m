Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D78B78B4F;
	Wed, 21 Feb 2024 13:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522917; cv=none; b=MMDDBSOn86RQkA2cF0gvWqPFkIYQEWwNgCKtkiGesjAP1MRdq9uanNA8Ef79Ox5d3FyqePQIt6k+eGenL2+BKzO9IJbXnCYNYCWl/Go0CC3VHDm4qmpMcwTf08KhfTckY6u8by4IfdSLzipZM5P9q3ZjTKnsEpNk5FU8Mc3mWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522917; c=relaxed/simple;
	bh=OhVyYIJIp+ULses6Iio8NETouSlGCIhWpYy54in5oII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBaKmAhuO2pwrE/4uLllWMVbIS8StWe9+ts2LyB7EsY8nSTmsb7rTrN70wP0Hjlnn4ke4ADs5scD/Q4JZp2ZMJwuu+gkOVP0onuAhTz1UmKxhC0azgVEHh/p+VLlAvNYVs0lutyWPNw1X/yB2j22gMp7ys5CFHExtxPm4ZLod/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOGUF4oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOGUF4oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C4DC433C7;
	Wed, 21 Feb 2024 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522917;
	bh=OhVyYIJIp+ULses6Iio8NETouSlGCIhWpYy54in5oII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOGUF4oqaei+jB19wLxtMwTQl4k4Cs2VzUTRhYa/LEzIs6KwNVQEP9UQf5r/b8+6d
	 TIX14eeI5YM0tvJFLGVDQnbU+CzbB+++SfguTE57B648y5kEkNZARwtqZ4x0l/R+N4
	 kBjgWegtGWvNBasnNAPIrZfXbzQLnmhFsQaeb53I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Bailey Forrest <bcf@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Kevin DeCabooter <decabooter@google.com>
Subject: [PATCH 5.15 291/476] [PATCH 5.15 6.1] gve: Fix use-after-free vulnerability
Date: Wed, 21 Feb 2024 14:05:42 +0100
Message-ID: <20240221130018.758454764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Praveen Kaligineedi <pkaligineedi@google.com>

From: Bailey Forrest <bcf@google.com>

Call skb_shinfo() after gve_prep_tso() on DQO TX path.
gve_prep_tso() calls skb_cow_head(), which may reallocate
shinfo causing a use after free.

This bug was unintentionally fixed by 'a6fb8d5a8b69
("gve: Tx path for DQO-QPL")' while adding DQO-QPL format
support in 6.6. That patch is not appropriate for stable releases.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Kevin DeCabooter <decabooter@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -350,6 +350,7 @@ static void gve_tx_fill_pkt_desc_dqo(str
 /* Validates and prepares `skb` for TSO.
  *
  * Returns header length, or < 0 if invalid.
+ * Warning : Might change skb->head (and thus skb_shinfo).
  */
 static int gve_prep_tso(struct sk_buff *skb)
 {
@@ -451,8 +452,8 @@ gve_tx_fill_general_ctx_desc(struct gve_
 static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 				      struct sk_buff *skb)
 {
-	const struct skb_shared_info *shinfo = skb_shinfo(skb);
 	const bool is_gso = skb_is_gso(skb);
+	struct skb_shared_info *shinfo;
 	u32 desc_idx = tx->dqo_tx.tail;
 
 	struct gve_tx_pending_packet_dqo *pkt;
@@ -477,6 +478,8 @@ static int gve_tx_add_skb_no_copy_dqo(st
 		desc_idx = (desc_idx + 1) & tx->mask;
 	}
 
+	/* Must get after gve_prep_tso(), which can change shinfo. */
+	shinfo = skb_shinfo(skb);
 	gve_tx_fill_general_ctx_desc(&tx->dqo.tx_ring[desc_idx].general_ctx,
 				     &metadata);
 	desc_idx = (desc_idx + 1) & tx->mask;


