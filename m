Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1223F221FBF;
	Mon,  2 Jun 2025 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873803; cv=none; b=Wo18DYFmtXdRE+Ha8M8O2lsVPkJ57GRFtkhvhbyoiPhLrcESQVanbcI8yGyaee9d6KqEzRk4g6xai91CCGbqtEAr1v9fdwUKTHtgIH2fMF+K/muOW0l0dlcIkaOMxlrJcOCuf+R9251WcXK8JGZ8GM1U2nAUBO3d/Rxp/rlf7OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873803; c=relaxed/simple;
	bh=uVvHOG3tLgzoE9MSccsrE46H1ORyO7oeyyhjOkxBQBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmUJxtsYVeTfEuzfrg5beYEcHGo2oflabGldhp8q9yhYaSntMQ2UIPNdF99JibyHDY+GZobgDAegSH0Yc+E3NE5uHecPrC0kKHwgTNfbzbCNzw47TwDK8l83ek1rBhsfIb61qF2wJtlFmaJ6H8670aaKQSRjzIK8dXFfRq0AHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7L+lanv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7L+lanv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95432C4CEF0;
	Mon,  2 Jun 2025 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873802;
	bh=uVvHOG3tLgzoE9MSccsrE46H1ORyO7oeyyhjOkxBQBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7L+lanv9+aw4tgClLxHv6GgY9QujY4UCbOTmlxN83JqU96LF+vLR4Z8UHyb2RV6g
	 M/fiH3Y+jWEY2IQMNKJM5rE+cd0+oq0yZg6G7OZVsxlOzqQ/iIX7QtynPc/tWTLnqQ
	 Bnc4Nl79TLtSfu0Mh4WPkubf4gPXnEDRHL3vTNt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/444] wifi: mac80211: dont unconditionally call drv_mgd_complete_tx()
Date: Mon,  2 Jun 2025 15:45:21 +0200
Message-ID: <20250602134351.359704430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1798271b3604b902d45033ec569f2bf77e94ecc2 ]

We might not have called drv_mgd_prepare_tx(), so only call
drv_mgd_complete_tx() under the same conditions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.e091fc39a351.Ie6a3cdca070612a0aa4b3c6914ab9ed602d1f456@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 42e2c84ed2484..37163d84104fa 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2959,7 +2959,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (tx)
 		ieee80211_flush_queues(local, sdata, false);
 
-	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	if (tx || frame_buf)
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 
 	/* clear AP addr only after building the needed mgmt frames */
 	eth_zero_addr(sdata->deflink.u.mgd.bssid);
-- 
2.39.5



