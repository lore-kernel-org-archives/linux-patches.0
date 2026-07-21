Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D4D30D3FF;
	Tue, 21 Jul 2026 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667147; cv=none; b=dG7/Tl+8Vwz17xJMbAFL5kS6Zb02ouf6Ar4bP/hLO/+9N/PGzbli9ejQggMwrYlde250Q5Ay60p8tXGCcotMBP870oI8la+MFOUg2j7w4TQGqtE/M/SqsOA9lpNelWyayZa898yg8w8ZGiL1oAR/ZHAczV7ksQJoJhbIzDLNcmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667147; c=relaxed/simple;
	bh=4dZVM6OL6GTF6KlcSodWhnCFPp1ipkCE6DKijSCNd00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFbedY+1tnNEjuq1hZ8+qTiTZkBA25dGUnW1F9EUWwOebLE1bB5A0NkAU9N4gOl7QoaTvNA8KHuczIe81temY7VpGlr2yJwTv8bfeFwmXAtt4UeyoRqPNlWlSLyG/velGAdGHF7+0lteABzXEJlzcEwxgNFdiVVM3yMxPQtw6i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCDnsMXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCDnsMXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F01F000E9;
	Tue, 21 Jul 2026 20:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667146;
	bh=F7zXXiZp447Y05qunLUDXs6k8CnMqhdxDc+PJvP+5M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCDnsMXlbgooCY3kQublxTOb80ZPSzvNFj4VfUiEQRbegeQ1nA8s8WV3r4QxGeS3n
	 bsHIqTg34yhgMqBNIMIiahOWLSByvV13YNhOKLa5qh9v80n3agQlxOiSw9faR4C51h
	 Hc4tO1WXfleG/sJSQVMYgA9BNkTpD1+XR5H58m8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0950/1266] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152503.086710547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 98052bdaf6ac1639a63ffc10244eeeab1f62ed2b upstream.

The original version of the candidate selection for DAT attempted to
compare both candidate and max_orig_node to identify which has the smaller
MAC address. This comparison is required as tie-break when a hash collision
happened.

But the used function returned 0 when the function was not equal and a
non-zero value when it was equal. As result, the actually selected
node was dependent on the order of entries in the orig_hash and not
actually on the mac addresses. The last originator in the hash collision
would always win.

To have a proper ordering, it must diff the actual MAC address bytes and
reject the candidate when the diff is not smaller than 0.

Cc: stable@vger.kernel.org
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -546,7 +546,7 @@ static bool batadv_is_orig_node_eligible
 	 * the one with the lowest address
 	 */
 	if (tmp_max == max && max_orig_node &&
-	    batadv_compare_eth(candidate->orig, max_orig_node->orig))
+	    memcmp(candidate->orig, max_orig_node->orig, ETH_ALEN) >= 0)
 		goto out;
 
 	ret = true;


