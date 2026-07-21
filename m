Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50CF388890;
	Tue, 21 Jul 2026 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658596; cv=none; b=SWOAHqvMWIk+LikjbbcoFznDzFG6KuBH5pSBoHtZUnV8t1HLpY0xBELHMfPhn7mMSlE2CAQPwFDT/zadqwHxr3Ae/8Mhnfw6o/gPqZ5e3j+uUttrRB5jTKi6Y5qfOx4QQQWODU4gxuKZAt+cQPNGRlZ2/Y7G0yfABWnhIcmdiM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658596; c=relaxed/simple;
	bh=aTqj9mqsTgmwbtS4eY8+B3isKZ+G7pl5xIYEMRaPxkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUXS6bInGhYySGrgaNeqZNuiPkiNOHcZg5DSa+Dni/y8cEcZgFNyRa8hc5qLw9n3en6Y2WRHg/PAWrjuSPa6++GfVONxNJ4XVZ3hxBkKKFNERxJ3/7zLLsIavrpFvsfJrJR1eRdWmE2rbRc4DMthiUb+vm/bSdylBHUc2/+lJgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9H8jd4N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9H8jd4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172391F000E9;
	Tue, 21 Jul 2026 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658595;
	bh=6g9rKjV3HFU8PS+h06QsHD2hvQ7e2zfwtmW30+k8Ink=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9H8jd4NPKMBWlP0ucaGAsd2mU/Zy1bqMdXffqn6ddM3KVM6alV6eVDTCCbX9tfGk
	 QMG9KjtUgUAV4Ae44I5skGZ87/9lNwNR6PylWgIhhqdOzFvb99MI0tPxIbfJIRnIfN
	 U+t4o2ug7ElDXWK/JAefNW1xfinJ8LYW88YtcCkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1201/1611] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:21:57 +0200
Message-ID: <20260721152542.447339486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -545,7 +545,7 @@ static bool batadv_is_orig_node_eligible
 	 * the one with the lowest address
 	 */
 	if (tmp_max == max && max_orig_node &&
-	    batadv_compare_eth(candidate->orig, max_orig_node->orig))
+	    memcmp(candidate->orig, max_orig_node->orig, ETH_ALEN) >= 0)
 		goto out;
 
 	ret = true;


