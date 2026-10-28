Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215114;
	b=rGTixChsGaygOUN9Xq/Jm9tYnePbH3wEHB4phXLw1ZmdaodQmakpCGEYjv45sWWWPxMH
	 1xNEUAVQ0uJPpn+0CodMbTbs2WqM1mKOEv7i5hzLmvL7Jh4RHkrSrTprjMhOQlnzSYh4g
	 KkPXEzjOM9/FXO7PUb2rXvUZhXRXKQfF2AZ7TXaI4yW5Pwkc3gETKnW3QxA8FXP/V/1+f
	 6/86Ngr8P2eqq4ki1nRS20YdPOi+dM479YGkp79Q+It1KC730vy0dMGYQgEiMy+NyWoMu
	 b03s3woOjWZH6J7sIePhpHalzekGd8Fntlxs81Xu+bcJwiFkxqixV6DlRJPB0z2dnSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E+/KHq82JeYylFNQW3wIRE5P0SrQ0TaZo5bLkiycEtI=;
	b=wleBx+0l1d0JQaLDonBi3LuHeW3yUUtPnYZ2wRd9+NlaqDO+A6IV62kpJDmBsqPUJAu2
	 42z+XR0IvdduQQONsWxB26amEr5MsqSL96IwghFRdyrlcpKgcgm0ZOiOZlywAInHV9G5C
	 r56oW9UBw04w7kDDNSwglf1UMcyC1eSAVAFXAJEtuCC/NSAw2xRYNj5oj4TizLvB447lt
	 jR6ece89IxQ0LsxFkIp75CXPS/a+1zifWAwbRnCOfu2ss24JO2yogyCaXc5xLiJDwU1g3
	 qGUQZcSEGF3WJn+Q5f6t1U6s7JLCbcx8MZ0PApJ8D8HWPqdo1gaF43gsByuo0FVdRLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I9G0zR1/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06960606A31A;
	Wed, 28 Oct 2026 19:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9G0zR1/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8561F01825;
	Wed, 28 Oct 2026 19:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215113;
	bh=E+/KHq82JeYylFNQW3wIRE5P0SrQ0TaZo5bLkiycEtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9G0zR1/uTaeWb5AZfe1Ffihac7VcNJgtA8IasSTE8he6k0yKm+XxSd51jBKp+xZp
	 1WuvrQG5gHhK9edJiDWEc2IWnJfDiuM6q/C7JOV8ttr0X3M1tex/EZNfsFwWVb97gm
	 zgOiy36bleLYGPvhoQaSFbd3cJnaHjHyQjvnRGLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1098/1887] wifi: fix leak if split 6 GHz scanning fails
Date: Wed, 28 Oct 2026 17:53:14 +0100
Message-ID: <20261028170524.391471531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d6bd95857abf2..8998a48d0be54 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -995,6 +995,7 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
 	struct cfg80211_scan_request *request;
 	struct cfg80211_scan_request *rdev_req = rdev->scan_req;
 	u32 n_channels = 0, idx, i;
+	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SPLIT_SCAN_6GHZ))
 		return rdev_scan(rdev, rdev_req);
@@ -1021,8 +1022,14 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
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



