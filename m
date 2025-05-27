Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CAA28003D;
	Tue, 27 May 2025 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368618; cv=none; b=W9k3WFDDEm0I1XH3anNRc01Dg8DnxQEV3VkcGqKoAsuZS2uDkqY8hdhNUkku9Lyd9RzeWQgRrElrYy94/CB3O/NI3qbY48/3ynGrVcGa91ooI9yn2nW8LEGMaUUNAA4GOU62s45CPZDcT+USIYUdMsU/QWWudmyHiQg+4AZrn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368618; c=relaxed/simple;
	bh=rN3UyShpLdr/+wh2UBR5zZfXCp9QHewOYHjwzpx/PEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWn9t1tX8fLtf1LigUgePnzpb2Pd3MD13o0owut8HevVN21dSKi+fCGA5tvsUM7Iht4HQ0ox2SpeaRp4HeleeFyHtfw4i9Wa9MrqrpTU8x8z7N/Wp8Ibq3lPdxLad5XR7keXV+MdOl0P7sReWV8legzlP7C1IKIyNLlu/jY1OWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHHPp4Fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHHPp4Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16431C4CEE9;
	Tue, 27 May 2025 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368617;
	bh=rN3UyShpLdr/+wh2UBR5zZfXCp9QHewOYHjwzpx/PEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHHPp4FroqBOvI0bU94LcXkVTHuvYoGK/UCzQmc8vj0dxRHydHzTJJwO9iixeBo3w
	 RTuwxe0lU1ZdQEqb/5np/uioLEgi3ThXJnvbBVvgGWXVr1/V9TJqidmzsRWAOBG5dL
	 CAXeJ4epAvdXgA2rnbUlOY1DNurfl73CdRkiX92I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.14 764/783] wifi: mac80211: restore monitor for outgoing frames
Date: Tue, 27 May 2025 18:29:21 +0200
Message-ID: <20250527162544.242563361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit abf078c0a322159f5ebe2adaa0cd69dc45b1e710 upstream.

This code was accidentally dropped during the cooked
monitor removal, but really should've been simplified
instead. Add the simple version back.

Fixes: 286e69677065 ("wifi: mac80211: Drop cooked monitor support")
Link: https://patch.msgid.link/20250422213251.b3d65fd0f323.Id2a6901583f7af86bbe94deb355968b238f350c6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/status.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1085,7 +1085,13 @@ static void __ieee80211_tx_status(struct
 
 	ieee80211_report_used_skb(local, skb, false, status->ack_hwtstamp);
 
-	if (status->free_list)
+	/*
+	 * This is a bit racy but we can avoid a lot of work
+	 * with this test...
+	 */
+	if (local->tx_mntrs)
+		ieee80211_tx_monitor(local, skb, retry_count, status);
+	else if (status->free_list)
 		list_add_tail(&skb->list, status->free_list);
 	else
 		dev_kfree_skb(skb);


