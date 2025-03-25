Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3653226A1C2;
	Tue, 25 Mar 2025 12:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906172; cv=none; b=NuCu2VnnNE8hSPJ5AeluiWvRKYrajaPtWevpPBzNW7nbDCL1frO8w5TNHO7w0m9UihImOQXNpuIvFCln0yKJjSREdzsQZXi5ZjDYMvegw2OHSCxP5PswzVXTJMSODfSZcEJomRjjIhPuoAAyPgJLcCvFJPQqhcpHhoTJ6CAjFuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906172; c=relaxed/simple;
	bh=MgY+N+mKN/61N+yGC0zbRAfJ/dc4Xj3gmmxi/3rFN5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChryPW4N0frgiBxrsezaLX0OeqIgIY+6Eu0zrQKJkiiBcgbEHM5zbqQ/wTtkxCFq9XKqCo9aUab19TgZKzs0L7z3X3rKzLQ5EEEHSKXqhP7qH7chCPxu8JccNetxMerVtfK+eReVtJxe8v3UyIIHBI2VQJczCfD5+tfgR4ZDwf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGeENmnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGeENmnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF582C4CEE4;
	Tue, 25 Mar 2025 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906172;
	bh=MgY+N+mKN/61N+yGC0zbRAfJ/dc4Xj3gmmxi/3rFN5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGeENmnM8iz+RW7Po+tpdj8F804EVezY/ujJPQlqma+XWIUWUFC/H+rt1FAs5/Nkn
	 UXFuf9I9qrXCsok6tFsovfy29IxWDCh5E1C726qdKYvus+xKRuIxw7lM0FpjYBKPZ1
	 lK5g6CXMXx4sEDu2asnZD2xqvdBgVJZFLdpArNZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.6 53/77] batman-adv: Ignore own maximum aggregation size during RX
Date: Tue, 25 Mar 2025 08:22:48 -0400
Message-ID: <20250325122145.738336825@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sven Eckelmann <sven@narfation.org>

commit 548b0c5de7619ef53bbde5590700693f2f6d2a56 upstream.

An OGMv1 and OGMv2 packet receive processing were not only limited by the
number of bytes in the received packet but also by the nodes maximum
aggregation packet size limit. But this limit is relevant for TX and not
for RX. It must not be enforced by batadv_(i)v_ogm_aggr_packet to avoid
loss of information in case of a different limit for sender and receiver.

This has a minor side effect for B.A.T.M.A.N. IV because the
batadv_iv_ogm_aggr_packet is also used for the preprocessing for the TX.
But since the aggregation code itself will not allow more than
BATADV_MAX_AGGREGATION_BYTES bytes, this check was never triggering (in
this context) prior of removing it.

Cc: stable@vger.kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Fixes: 9323158ef9f4 ("batman-adv: OGMv2 - implement originators logic")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    3 +--
 net/batman-adv/bat_v_ogm.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -324,8 +324,7 @@ batadv_iv_ogm_aggr_packet(int buff_pos,
 	/* check if there is enough space for the optional TVLV */
 	next_buff_pos += ntohs(ogm_packet->tvlv_len);
 
-	return (next_buff_pos <= packet_len) &&
-	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
+	return next_buff_pos <= packet_len;
 }
 
 /* send a batman ogm to a given interface */
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -839,8 +839,7 @@ batadv_v_ogm_aggr_packet(int buff_pos, i
 	/* check if there is enough space for the optional TVLV */
 	next_buff_pos += ntohs(ogm2_packet->tvlv_len);
 
-	return (next_buff_pos <= packet_len) &&
-	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
+	return next_buff_pos <= packet_len;
 }
 
 /**


