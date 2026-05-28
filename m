Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE7B2E7379;
	Thu, 28 May 2026 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999791; cv=none; b=rEzFaDSMMnYwa4DkTIVkoIrSicnvF+q1CT8bBAgDNParfBUlDjGtdB8OutDg82Z0noBuP2oknVH8+fCfrSMsNecNnqtTsF4bxBHUVyeU+1999MTWL4OmBjG7eTyypLege9Puo7wAKbUakMt/XxAdmDrB8rUepxTp+Na+yL7uQWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999791; c=relaxed/simple;
	bh=yGLuZyZ4OCBAF6Bc3qIhtK4ioV9NkqJRIy5H4HRIvbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhvUgyk+MmtKowVv6lButLHrw+yL2N6GYAExFfMfZcRDt96AOKXG+nxuJ7UqGpg0fMFT1hEOkNoB7LeNwR0YvHrNl/eC8sI6Om8gtRBv6/Qh+e74JGzMbS9o4P32BjTCdpPwHN5bxd4sLH4+VGBdz03gbrsQNM61GzS9a0aC0QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOwlFX+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOwlFX+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59A81F000E9;
	Thu, 28 May 2026 20:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999789;
	bh=u8wAuRY2CBNLYD5s4qvBWm0pYqI7NFfqVjCNMvsTqtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOwlFX+6rUHSRZLRFUoSctZ8iz1pNdbxOllO2Y+JlVHJuX+7o6XvA4O1GheUYHEIN
	 qHDXJd/w1+cjsNl1bHZ2SkW+TB7ipxgc6pEe93rXVhGxYsLLmcFb0FTAaXFQBXvM2u
	 cGjTMUCoFRNYrNoXgS2vIt/v8DNqw98VN0iW3r6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 156/377] batman-adv: tt: reject oversized local TVLV buffers
Date: Thu, 28 May 2026 21:46:34 +0200
Message-ID: <20260528194642.914574545@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

commit 1e9fab756f8395096d5bba7be0c373c4c8f5d165 upstream.

The commit 3a359bf5c61d ("batman-adv: reject oversized global TT response
buffers") added a check to ensure that a global return buffer size can be
stored in an u16. The same buffer handling also exists for the local data
buffer but was not touched.

A similar check should be also be in place for the local TVLV buffer. It
doesn't have the similar attack surface because it is only generated from
locally discovered MAC addresses but the dynamic nature could still cause
temporarily to large buffers.

Cc: stable@kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -877,12 +877,12 @@ batadv_tt_prepare_tvlv_local_data(struct
 {
 	struct batadv_tvlv_tt_vlan_data *tt_vlan;
 	struct batadv_meshif_vlan *vlan;
+	size_t change_offset;
 	u16 num_vlan = 0;
 	u16 vlan_entries = 0;
 	u16 total_entries = 0;
 	u16 tvlv_len;
 	u8 *tt_change_ptr;
-	int change_offset;
 
 	spin_lock_bh(&bat_priv->meshif_vlan_list_lock);
 	hlist_for_each_entry(vlan, &bat_priv->meshif_vlan_list, list) {
@@ -897,8 +897,10 @@ batadv_tt_prepare_tvlv_local_data(struct
 	if (*tt_len < 0)
 		*tt_len = batadv_tt_len(total_entries);
 
-	tvlv_len = *tt_len;
-	tvlv_len += change_offset;
+	if (check_add_overflow(*tt_len, change_offset, &tvlv_len)) {
+		tvlv_len = 0;
+		goto out;
+	}
 
 	*tt_data = kmalloc(tvlv_len, GFP_ATOMIC);
 	if (!*tt_data) {


