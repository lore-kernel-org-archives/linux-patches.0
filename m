Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD2744AB8E;
	Tue, 21 Jul 2026 22:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674232; cv=none; b=UXeL0OisR0Fg88ZY/FF2rssaReoWYjG4X6TtPKtJhLqR9WCOmpFJmOyRuy5yuxrPkdbgLMNuaUrarGgBl7DJLTQFEwxSl66w86WDnyFU0Gd8bsgeiFGqW9zJl4D93REE/pCsDE+ieOTGEDxINahADjz3ixHsa5k8c/tOmYg9sx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674232; c=relaxed/simple;
	bh=ith04Fv+k8N2sKgNOBfuwIoxxwCdAk6UiOFen3gJsfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McyFKAn30ZP6gJRkcUZLTNulJYnLMKlT5T9PVvj6Nx2wYM25PRXFfdNLUCzGf+UF+zmUpqhMf8qSgS/eQvkAhSCUMYLsuukTjoDnaC9p7qLeAT/LYf0738m2qh9TVo3sT2KL4Ekpn4qN5KfZVXOw8vZPjeQhkRCHJQxrV77iwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXVY+OyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXVY+OyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CDD1F000E9;
	Tue, 21 Jul 2026 22:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674231;
	bh=jU4/75HXfQsoZv4oHVnpSqJ+/rZESy1hLnHe9V9FSUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXVY+OyZYnlNWsXH+SIAjU7pioK+6GQ8/uqLZES2Li8Wi3c3s+/xjPAMCgOhwRRms
	 mrdTc0dJ2bxnkQICBeWw2mWqr6ljhYclFJQ+fKPHz9G8COLyWmYIVSUDazEcN+TDEZ
	 PldAkSt+OFFr4LBcP9OdiQC5q9WmituxpXunMi1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 464/699] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:23:43 +0200
Message-ID: <20260721152406.163514175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,7 +548,7 @@ static bool batadv_is_orig_node_eligible
 	 * the one with the lowest address
 	 */
 	if (tmp_max == max && max_orig_node &&
-	    batadv_compare_eth(candidate->orig, max_orig_node->orig))
+	    memcmp(candidate->orig, max_orig_node->orig, ETH_ALEN) >= 0)
 		goto out;
 
 	ret = true;


