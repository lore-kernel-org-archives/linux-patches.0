Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6B12F37;
	Tue, 20 May 2025 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749870; cv=none; b=Nk3JKWPZkg2EAH9MPY5mEpE/093su20a/7KoQIqtw7KdLvqjCQUJX+UjLWaue0awf395BIZNdpBITmeUjTtt+X/pNoTJOy9kElnniNOx4eZz7tEnJ6N2CcSNGTd1yc4gnHef0oYQGX5S6Nq3r4t8jo/5phYf4IZvbqSo2zQlxs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749870; c=relaxed/simple;
	bh=LV7k+mnu8GRa/QqKT8KVTU+tSHMry0B7Vc2HUO6KWzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su+thAbfoQAYMTtPTcaojJ7HAj5ZVJViqvZmrgS71toaY8z/xXKDdm+tFQ7pAJKQPtWxMk5mEnUguQktQn433PmHmhOIVlIHRgtXejvZNyKKo9kchBhQJN38NKaqOk7wSdBN8z0A5LxonSE/cuojARCWI53JjbBdoKxVGQU2n8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PeNseFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PeNseFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D5DC4CEE9;
	Tue, 20 May 2025 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749869;
	bh=LV7k+mnu8GRa/QqKT8KVTU+tSHMry0B7Vc2HUO6KWzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PeNseFjjh7zGv7atAluHiONKRsfL+mzpAFUKlGsE8FIWCQShwlORxtPBRzPe8Igl
	 xzX2cw3vfTrjToCEQT0tM4Nl41KoGkRUwVRQTbE7ZuyJrVFdZgyog0ZDbxXr9HWaLd
	 GscoPZ0RKIx2V6v0C+Gz9knFkRiJUPn2kbUoVO0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bcdddd48bb6f0be0da1@syzkaller.appspotmail.com,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/117] wifi: mac80211: Set n_channels after allocating struct cfg80211_scan_request
Date: Tue, 20 May 2025 15:50:20 +0200
Message-ID: <20250520125806.173100889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 82bbe02b2500ef0a62053fe2eb84773fe31c5a0a ]

Make sure that n_channels is set after allocating the
struct cfg80211_registered_device::int_scan_req member. Seen with
syzkaller:

UBSAN: array-index-out-of-bounds in net/mac80211/scan.c:1208:5
index 0 is out of range for type 'struct ieee80211_channel *[] __counted_by(n_channels)' (aka 'struct ieee80211_channel *[]')

This was missed in the initial conversions because I failed to locate
the allocation likely due to the "sizeof(void *)" not matching the
"channels" array type.

Reported-by: syzbot+4bcdddd48bb6f0be0da1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/680fd171.050a0220.2b69d1.045e.GAE@google.com/
Fixes: e3eac9f32ec0 ("wifi: cfg80211: Annotate struct cfg80211_scan_request with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20250509184641.work.542-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d1046f495e63f..3a6fff98748b8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1186,10 +1186,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 				return -EINVAL;
 	}
 
-	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
-				      sizeof(void *) * channels, GFP_KERNEL);
+	local->int_scan_req = kzalloc(struct_size(local->int_scan_req,
+						  channels, channels),
+				      GFP_KERNEL);
 	if (!local->int_scan_req)
 		return -ENOMEM;
+	local->int_scan_req->n_channels = channels;
 
 	eth_broadcast_addr(local->int_scan_req->bssid);
 
-- 
2.39.5



