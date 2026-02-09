Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F0735CB6B;
	Mon,  9 Feb 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647270; cv=none; b=FBjVVf7S6i2W2hJlIsvCBrU0eKEXCjpkMOqw2mvuZEz2mNQJgwyI3BoeuNcAlxo3QosaRWOjrEieyFB1ONG9o+VLk+VgtRp/0SNFR4rj4ug33+w/NahqJl1JoHLnnvsW7Xa3yTvilowhN+lpMHzbxccHwqVp8l2qcNsrpmNR6s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647270; c=relaxed/simple;
	bh=rUvA6+rav0AaXU0ihG2ftAcR4N9B3Kks2Aky7pwnpkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzOQ0uKQvBhWv9KoWNhoSjXTt/cOWuh72EiyF4U+tbeiASEkWmxR00snEm8u69dQ9mI3XeLze3fOna+HM9QoGiDFDIuGBc5c+mCjJMEXjjNdptKQgw0ZAC6u0x22Agk1YGu0Tr46dv4fFoScjOBthK97FiacuS2o8j90mtrwbyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euLwyfTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euLwyfTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0134C16AAE;
	Mon,  9 Feb 2026 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647270;
	bh=rUvA6+rav0AaXU0ihG2ftAcR4N9B3Kks2Aky7pwnpkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euLwyfTN49NFJCESZ3x4R2EstuehaGJ4X9cW3/be8WMWOxARE8OTBo5vx+Txv7jb8
	 YQNBIOVuHl3msBwJMoKKFEcDjhfKaWcGLsGthDkk3wYfdEdOrvHi+EzXUyCk+jfq1P
	 NLYADwjd50IiVw3uLZ/Vt9k/PZZ/JGySCFoMjgYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/175] wifi: mac80211: ocb: skip rx_no_sta when interface is not joined
Date: Mon,  9 Feb 2026 15:22:01 +0100
Message-ID: <20260209142322.200456845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
index a5d4358f122ae..ebb4f4d88c237 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -47,6 +47,9 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
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



