Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F1647141A;
	Tue, 21 Jul 2026 19:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663606; cv=none; b=jRhIZA0//DtUHlVnIfrDJOqQI+nvFW3Vdi5pSN+6pTbAjxO28JOH6S7kZ6mWn2bOcHY14QPzJYzU9tCIuliU4iyE4vbcjTvCRsT6St+pK5XRnvxCFtBzqU8yerC5I78v0dJJGwZ/W7cWANvyAVDUkxkic9k166VM0+pxGTHwAlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663606; c=relaxed/simple;
	bh=928X3bFs63iWPYBMWHfiYdBbtYRbWzfxyjHRl2G1Sjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKQVnxAT8UQyngNRpAF478GTpaEYLisNA0QZhNQDbOrcromrld1y6LFMOpg8MpF8agDFolGVrEypS/2Y/MTG1PJVTfW9KZYG5dvS63KO46H9qa4j1Rz8uAcT4ntq9UXqg/TkB3v630dGWCLvi7+YBESXFdjX7XjxomrENXxPp9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i59uLoU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i59uLoU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12001F000E9;
	Tue, 21 Jul 2026 19:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663605;
	bh=WGM+BtD9iRdiRp3YKFr+HKuvVM3tpVXpP+2zLo5G5uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i59uLoU9cVkxQ6yGlKQcXsyVQN4bjHcnLz6lzM26dk5hHp2TxiUWNgZUm8tddbDS7
	 T0oWWis7iS/ABZDIMEg9kHwKO9VqJID8L4YQff5c/K/9uT3H+xnhvziMR1pySiXERV
	 fGvApL/eg3AVUgxWFYkedHBB/Oi6p+CKMGa+S2Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0887/1276] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:22:10 +0200
Message-ID: <20260721152505.898149643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


