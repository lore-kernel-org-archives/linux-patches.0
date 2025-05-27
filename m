Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999AF1DB34C;
	Tue, 27 May 2025 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365655; cv=none; b=VKqxXdtx2E8ACu+6PTgXudNbbyN4KYdCTGdd/0+F2CI4dmYDpYJeZht4nD1GLlSljsQDTQstzpYsB0xYncRxD35Kj2L6bTQHVvSMvc8yNHuOyMkth/6Aa+C6o5/zwkWsxOdpiUCAc8a8itEY/qK9gwJHw8pZxdqTudrmd+/2ZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365655; c=relaxed/simple;
	bh=v2SU9HIzVxQToH3j0thbpdcREyB9XBSbmv9x7n5BjHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkaTNiu50lRId4i1z+m34fp5eIgpzKkjJCoTiAtVUKucY+nEUYgLMLTy1zRk8dri4D1FvtMjB2TS+LPJZglptpQtbYlTQejvvfVP6ywvf4bG2PV/0soWlLBP3LsLw+c3JzXqjL3mWto9RTZ4EmGzHVHN9pHTdxhKhZs5uJTRQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eluqOTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eluqOTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F5BC4CEE9;
	Tue, 27 May 2025 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365655;
	bh=v2SU9HIzVxQToH3j0thbpdcREyB9XBSbmv9x7n5BjHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eluqOTbwLc+lVOhD4TOkdJtaRk0NXwDwRFmHTDMykmGOIt5EnEaeB6XAvIqPKUwP
	 LBSZTVipA6FViCvEINfKiFtdV7E+Oz/Pwhj0qnrttjToNJGxZC3+H+djuJk+AmmLzg
	 /ExB8fAJmv9a1TxtaJBoQnYVXv0yt97csniXwUjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/626] wifi: mac80211: dont unconditionally call drv_mgd_complete_tx()
Date: Tue, 27 May 2025 18:25:09 +0200
Message-ID: <20250527162501.907573167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3a279ded46c2f..6a29877fd7b37 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3589,7 +3589,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (tx)
 		ieee80211_flush_queues(local, sdata, false);
 
-	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	if (tx || frame_buf)
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 
 	/* clear AP addr only after building the needed mgmt frames */
 	eth_zero_addr(sdata->deflink.u.mgd.bssid);
-- 
2.39.5



