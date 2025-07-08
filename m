Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE73176ADB;
	Tue,  8 Jul 2025 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992180; cv=none; b=JIrNP50cP+y59ltgb74b3b1yzPJ6FqsO6xsuG2tR2EYtDjuvC0Lgj9KmoddBQCNJJ6xyULfdjbLqr+fT3EwuCNUGSuV3vb2ycad7Eo1GpF8RJCSSSYRAzbrby5sIgslErJVNze6mq3uVZx2lkN+drkSAZUFPt62kAi+ap3ExXhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992180; c=relaxed/simple;
	bh=KPV6zNLNVaem2vy866CI1FDLJ0fKwHrv4cMTeDl0cJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od6/GnxWJVgEGoGab6NEK9oeG/wa91CMMXcw0FEfnQB405cASKwK5LJeUF/KC6HRq90bRPX1B1uDp5YhWqy+zJq2cgF0IbEinLuo9iZkRznu3myrUUzGnHKGGYz5CGdpSamJo4WxsDNfHvWD3hAqWRV4Wr0KJWSDVMTFNAojKLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6WfdHqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6WfdHqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B48C4CEED;
	Tue,  8 Jul 2025 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992180;
	bh=KPV6zNLNVaem2vy866CI1FDLJ0fKwHrv4cMTeDl0cJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6WfdHqu/Lam/fqSzro9zIyOfQrzbqwaSz89dslcMeE2wnZ+S3IIUZ3bKJarlCJhE
	 6L9Z+gZfpM9x7oQ52CKwfahxljnCW5JCvXlMBRc8xASSsGyrVH9sFkMe72BK0WhiU5
	 l7yJG6cazG8bqT01hQNhz8UQViVFkE8ZchfmX5iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 54/81] wifi: mac80211: drop invalid source address OCB frames
Date: Tue,  8 Jul 2025 18:23:46 +0200
Message-ID: <20250708162226.720975029@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d1b1a5eb27c4948e8811cf4dbb05aaf3eb10700c ]

In OCB, don't accept frames from invalid source addresses
(and in particular don't try to create stations for them),
drop the frames instead.

Reported-by: syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6788d2d9.050a0220.20d369.0028.GAE@google.com/
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20250616171838.7433379cab5d.I47444d63c72a0bd58d2e2b67bb99e1fea37eec6f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b6077a97af1dc..8c9267acb227b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4336,6 +4336,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (!multicast &&
 		    !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1))
 			return false;
+		/* reject invalid/our STA address */
+		if (!is_valid_ether_addr(hdr->addr2) ||
+		    ether_addr_equal(sdata->dev->dev_addr, hdr->addr2))
+			return false;
 		if (!rx->sta) {
 			int rate_idx;
 			if (status->encoding != RX_ENC_LEGACY)
-- 
2.39.5



