Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39D10A31;
	Sat,  3 Feb 2024 04:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933475; cv=none; b=T3cmrG/NoKXRsa0uzFo6vigiN66BySjKpTtLyQJOPj5hisfM+a22pGh9pkq7pwddhs3qk7n6SWfXkDCpmC6/bPdrby9jDh3VyfjRTa4Ks2tGRDibQBgVBWLELtMSrp1ZEegcP+w4j2J8yaeZxH5oNq8MXPnspUROuKUn+FC2i/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933475; c=relaxed/simple;
	bh=Uz7LYP8zyKbbPAwuQ6kYf6GHmuZETXV9ETqb/u+IMGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8G9RbmUW7h+ieZ8elNen3SEJu/+BUBPR/V0xrWursW5N1eus7bZM/mJ/zj2n3/tCGHuSlsMXymultVoyokd60/vXlDBqThRZYdMm/IN42Cc/8Y5X4CtHe0obiOmjwL/X2WseXR7DchgKMAEY1dPsJbSK5cHxIHVsagoruK63m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQQoiFZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQQoiFZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10120C43390;
	Sat,  3 Feb 2024 04:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933475;
	bh=Uz7LYP8zyKbbPAwuQ6kYf6GHmuZETXV9ETqb/u+IMGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQQoiFZpMGt57uWVafwWVxc5TFsvTcFjVxEcoYVcpzS/lDBCUHfmGHo1mOVSZ+2lL
	 owdKcTNGbJ4S07eE7pMsrw7Jf+AD1DDa4fRWKic8y0lyMOdiYafVFVYf7r1i9S4hch
	 CRTvsfXwntP3hOpQ2hChe5e3jWvOo6EUXWF/nfIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Bailey Forrest <bcf@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Kevin DeCabooter <decabooter@google.com>
Subject: [PATCH 6.1 218/219] [PATCH 5.15 6.1] gve: Fix use-after-free vulnerability
Date: Fri,  2 Feb 2024 20:06:31 -0800
Message-ID: <20240203035347.276973351@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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


