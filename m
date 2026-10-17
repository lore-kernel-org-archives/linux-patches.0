Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225BD17BED0;
	Sat, 17 Oct 2026 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254066; cv=none; b=MPpAiOZtQ1IBsV58rsI3dKbelZbVjkQEqU5cyUes+g+tpQRO45X9vD1sFEEy6Rji1TMeyK/usc2dMy2g8mvqfBgUMMC5mfYawO3z/Gne8mso9AtxuqpXd7nPAN0QLPfU4OEyTq485eJq0PmZj/f1R5mRud2qrc+vp6lKE5eeCms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254066; c=relaxed/simple;
	bh=nnboW0y909OSzu2HT/bUAGJ6QtZkE2qxEI9E1SNen/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp8rbUj584P5b05xdSs6VF40wuZCpLizqe3Zpc8qtA7w+W3nVpiQQORQRs2Pf3xoElVKacjT4jEFFdiatLoLTH8ytWT7mdrdWdHEwW3/kutH/Z0uaXjEevnaA4HGqnxIDF12yKSDLQz/NwY/awrkUe7n5/tLpNnWPW6ihxkK9uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DX/Cls40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DX/Cls40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6991F000C4;
	Sat, 17 Oct 2026 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254065;
	bh=ylvb/Hu6/UsZOwdQ7bCmPddWe3bkRmeOWmhYr2AY610=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DX/Cls40SSmTVF4/fBao/MURyoPcKEMdk1w460Ts+0GVNrezi8umDRumnrDu8Ae7S
	 mJbX3DFxt/x5fw5rAvVSu+j9V/ssxYFVLy0JqDbAZy33LhmuEbgMoqBkH1D+OMkcLf
	 Oqx1Wub/CXxRCD1Lq/fepHh5A0laJM4jd3Pk9ar0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/869] wifi: fix leak if split 6 GHz scanning fails
Date: Sat, 17 Oct 2026 17:52:44 +0200
Message-ID: <20261017160045.358709579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit e8694f7cc29287e843648d1075177b9a2000d957 ]

rdev->int_scan_req is leaked if cfg80211_scan() fails.  Note that it's
supposed to be released at ___cfg80211_scan_done() but this doesn't happen
as rdev->scan_req is NULL at that point, too, leading to the early return
from the freeing function.

unreferenced object 0xffff8881161d0800 (size 512):
  comm "wpa_supplicant", pid 379, jiffies 4294749765
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 f0 81 13 16 81 88 ff ff  ................
  backtrace (crc c867fdb6):
    kmemleak_alloc+0x89/0x90
    __kmalloc_noprof+0x2fd/0x410
    cfg80211_scan+0x133/0x730
    nl80211_trigger_scan+0xc69/0x1cc0
    genl_family_rcv_msg_doit+0x204/0x2f0
    genl_rcv_msg+0x431/0x6b0
    netlink_rcv_skb+0x143/0x3f0
    genl_rcv+0x27/0x40
    netlink_unicast+0x4f6/0x820
    netlink_sendmsg+0x797/0xce0
    __sock_sendmsg+0xc4/0x160
    ____sys_sendmsg+0x5e4/0x890
    ___sys_sendmsg+0xf8/0x180
    __sys_sendmsg+0x136/0x1e0
    __x64_sys_sendmsg+0x76/0xc0
    x64_sys_call+0x13f0/0x17d0

Found by Linux Verification Center (linuxtesting.org).

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260601094157.92703-1-pchelkin@ispras.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6fab9abb47b2b..520dcc16920a8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1030,6 +1030,7 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
 	struct cfg80211_scan_request *request;
 	struct cfg80211_scan_request *rdev_req = rdev->scan_req;
 	u32 n_channels = 0, idx, i;
+	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SPLIT_SCAN_6GHZ))
 		return rdev_scan(rdev, rdev_req);
@@ -1056,8 +1057,14 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
 	}
 
 	rdev_req->scan_6ghz = false;
+	err = rdev_scan(rdev, request);
+	if (err) {
+		kfree(request);
+		return err;
+	}
+
 	rdev->int_scan_req = request;
-	return rdev_scan(rdev, request);
+	return 0;
 }
 
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
-- 
2.53.0



