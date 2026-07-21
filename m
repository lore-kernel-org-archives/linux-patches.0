Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9A3B8407;
	Tue, 21 Jul 2026 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670005; cv=none; b=YKtujTAX9o6SnjUjRiuB5YWC56jMfGqtt2ydfLEYFoVNsiwKCjvhONnerYa0ilRAjWZs4m5tjTySPyGHoOOEYw56gnhFcJ/mP7vSOaAHmzOpEKhm5bPztw6CcI+X9qJi74ucohTladWa9vV3iyWDv1c2qR7o3f75unuooe8Q5V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670005; c=relaxed/simple;
	bh=9jGmIqabX/60E+B9AQF1l1YCWDja2vMLhkkdzSqSsv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGbO3uJ/BXyfttwjMEJeXAEDkq58G9asaPWwMX3bxsTMclR1vMC3bTGM8aFL9SZuekw/3HYfBCWJ17prLpgLgxEwmZsbvaEeju6CLmmMiBuXKgHW7wjyFEE9Yso7RthjjQev6cKazQAMJJcMDruF3mENv4jPSi/VveAKQjfQyKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTRML+Mz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTRML+Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03741F000E9;
	Tue, 21 Jul 2026 21:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670000;
	bh=xq0N1qoS/+Tsdu6QHyBXq/p3bXUjQq4GyfsHLLlMr4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTRML+Mz41u2zGxCAZsOI8vNLvrt+D+gHXPF5ze0dtd472Mhv8NN+Q/WjgF+XkDHU
	 mVD3x058JYogisr2FmEfnY3sklUE2IaFN8r7+NMQHv4zruuYoPhQu5/jzLFEUoew9v
	 ffQZkqJMU33BoQJNjYSq2m5QrEn8klZP6yoXGOT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0767/1067] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:22:48 +0200
Message-ID: <20260721152441.732428569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


