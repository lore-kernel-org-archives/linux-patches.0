Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACDD28725B;
	Mon,  9 Feb 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648478; cv=none; b=XgHfiJ8x8kuIPIVe9CsLkxUnT7UT+k0HCy6Re6nSbFwABdoYX8r62SZhecSenYLoxJpaNa+jodhj+oOk+qgTrSS17KB1doQxPKeaY35qifxkZOTN3B3EecX1Pqj30FBmA9bT5FKd/7/DqxOPTqbKCKQ5YNE2PukvVQSzOs0945U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648478; c=relaxed/simple;
	bh=E5B9jzKd5o3Dk/dwf5MrKvDhmdMORT2g+NcbAHCSkM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABsClybYmulNOu78AfGQNCNH5Onr/8CBzfahSrA6FuN1OmvtUEP5I3YjqgUaot+bMimVaUl5tRhqpWUabgzRBHIcW1zox515g3mq0CT23c4q30VTaORjsZckH9wK5Ay8nyXP9Yp7HwzvoqV12zqG58LA1uSYGkr/9S53+Qg/2vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfnfLUPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfnfLUPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD01C116C6;
	Mon,  9 Feb 2026 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648478;
	bh=E5B9jzKd5o3Dk/dwf5MrKvDhmdMORT2g+NcbAHCSkM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfnfLUPn8Kzi1/Jgx/KrElZHtL9DCD2fciqOW7YtLHrUwdcdBBPNWH3psF0IvoPUR
	 xELtonMP41801z+lsnakRkw7dsW3dd55EmUoCkwtU+SpwrGl1gSAKHs6fWYAY1ivA9
	 QCmY3+MEu/kx0CVlf0j8yfcxj1FQ0C23UukE4/M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/86] wifi: mac80211: ocb: skip rx_no_sta when interface is not joined
Date: Mon,  9 Feb 2026 15:23:45 +0100
Message-ID: <20260209142305.580178680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit ff4071c60018a668249dc6a2df7d16330543540e ]

ieee80211_ocb_rx_no_sta() assumes a valid channel context, which is only
present after JOIN_OCB.

RX may run before JOIN_OCB is executed, in which case the OCB interface
is not operational. Skip RX peer handling when the interface is not
joined to avoid warnings in the RX path.

Reported-by: syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b364457b2d1d4e4a3054
Tested-by: syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Link: https://patch.msgid.link/20251216035932.18332-1-moonhee.lee.ca@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ocb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index b44896e145224..1800d59d8b152 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -48,6 +48,9 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int band;
 
+	if (!ifocb->joined)
+		return;
+
 	/* XXX: Consider removing the least recently used entry and
 	 *      allow new one to be added.
 	 */
-- 
2.51.0



