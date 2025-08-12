Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D1D18FC91;
	Tue, 12 Aug 2025 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022325; cv=none; b=NTuxM1AcrcLdTHae3IMmIJo7uFcfNYdZ5oiMcsoN0GAlC8XI6W7e0Qw1/UUCy6Wr9yeGyTyTY+16kfjumY71IGdy63XZcViuiN+oEaKeoZyd2Kzoa1XV3Scy/U44+D8JsVnfpNP8TWPTYFaeB744VhJ4N9vmOlycp46IHKYgjtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022325; c=relaxed/simple;
	bh=RvspUgmIdjhxTl/gl111J/ZfXe+UUT3y7sJG4TaqDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPBzmVaS8gZYOYf63NbVd8L1HRlOoB7mOJb4slia9SvpmEtAPgOXb4basZVXcuvZiBxVaPJB0TKULej9MUGjHFFB3cFMp+iXu2UzDkvSWAqDM2HCHgppd+pNp/bk9LCPSw4oVqKD9AzMlWO9gXrO73RIIF8XtpAcRh8J6m49Wlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnNnuhJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnNnuhJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A389C4CEF6;
	Tue, 12 Aug 2025 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022325;
	bh=RvspUgmIdjhxTl/gl111J/ZfXe+UUT3y7sJG4TaqDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnNnuhJrJv5P5/nmVnnUVU10DPy2xz+1di4TjWgMoUUAqTwGczuJv8wagnWs4/HFJ
	 nJ7ChPPayteSn2uGzQePX6Z9KmDhZJ0FcQ0q/08FdfeRkM+o5K/l1fx3cMGFvzlJl6
	 SJKzraJh8XUFfKtAq1HTY3RJvA7z++KGi15MOe4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/369] wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()
Date: Tue, 12 Aug 2025 19:26:59 +0200
Message-ID: <20250812173019.356060682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 4037c468d1b3c508d69e6df0ef47fdee3d440e39 ]

With 802.11 encapsulation offloading, ieee80211_tx_h_select_key() is
called on 802.3 frames. In that case do not try to use skb data as
valid 802.11 headers.

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/linux-wireless/20250410215527.3001-1-spasswolf@web.de
Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://patch.msgid.link/1af4b5b903a5fca5ebe67333d5854f93b2be5abe.1752765971.git.repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 16f8b24820ae..16a997d8442a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -622,6 +622,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else
 		tx->key = NULL;
 
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
+		if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+			info->control.hw_key = &tx->key->conf;
+		return TX_CONTINUE;
+	}
+
 	if (tx->key) {
 		bool skip_hw = false;
 
-- 
2.39.5



