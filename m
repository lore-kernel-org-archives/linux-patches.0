Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8F269D08;
	Tue,  8 Apr 2025 12:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115322; cv=none; b=kEESVJCppb8KqoFs6hmTgaXK0qBzBeFkEFi3eqD7CdhYrNxy/mHz1hGunzRLsRc3thkcNXnNVLaDa/oSLUx7P8/YpgO1cSs6dcZGufYCa63+tjzFYtf9WYTFbikes+l1S1IPPAiF7KO/Z3RtMTkFUZhBIrxgvQMQlUrxyu35+EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115322; c=relaxed/simple;
	bh=UUya+A2CucvhjxRjAXawOWOfBdq5WpMoptCjRp+6Gbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXuXY9C3SDTuYWyf3GGBYC6Nr60bXOb4K57EYtvTLtIKI0rL9rzq1PdznpxaCm1kXhhfgrIZUmRnxsLl/9aJspyFa2xe3roa49B8nxJ42+TIXDHKRVdpY21Kybgx0xUO8sG98GyX3g+FDS+pIxg2LMQy0BwRVccGRFJ1CUahYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dndoLMFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dndoLMFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB31C4CEE7;
	Tue,  8 Apr 2025 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115322;
	bh=UUya+A2CucvhjxRjAXawOWOfBdq5WpMoptCjRp+6Gbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dndoLMFxWflWDoL76fZdQndma+SzRxcUq4e8QnwachaZaNa1zWSeGWF7kgzpIbs1k
	 RR2NOCHpU92XT1XB/ISydGZZbDwHqturSDw0H3NLfdY+gmLlTO8mttTxRV8SRnzuNq
	 utFxihugtmG0PHe2/D9eqoUUTOyi+uQomsDqTM98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	kernel test robot <lkp@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.13 432/499] wifi: mac80211: Fix sparse warning for monitor_sdata
Date: Tue,  8 Apr 2025 12:50:44 +0200
Message-ID: <20250408104902.001606256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wetzel <Alexander@wetzel-home.de>

commit 861d0445e72e9e33797f2ceef882c74decb16a87 upstream.

Use rcu_access_pointer() to avoid sparse warning in
drv_remove_interface().

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502130534.bVrZZBK0-lkp@intel.com/
Fixes: 646262c71aca ("wifi: mac80211: remove debugfs dir for virtual monitor")
Link: https://patch.msgid.link/20250213214330.6113-1-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/driver-ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -121,7 +121,7 @@ void drv_remove_interface(struct ieee802
 	 * The virtual monitor interface doesn't get a debugfs
 	 * entry, so it's exempt here.
 	 */
-	if (sdata != local->monitor_sdata)
+	if (sdata != rcu_access_pointer(local->monitor_sdata))
 		ieee80211_debugfs_recreate_netdev(sdata,
 						  sdata->vif.valid_links);
 


